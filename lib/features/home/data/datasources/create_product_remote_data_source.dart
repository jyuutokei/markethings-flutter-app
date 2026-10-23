import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/create_product_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CreateProductRemoteDataSource {
  Future<int> submitProduct({required CreateProductInput input});
  Future<int> updateProduct({required CreateProductInput input});
}

class CreateProductRemoteDataSourceImpl
    implements CreateProductRemoteDataSource {
  final SupabaseClient _client;
  static const _bucket = 'products';

  const CreateProductRemoteDataSourceImpl(this._client);

  @override
  Future<int> submitProduct({required CreateProductInput input}) async {
    final sellerId = _client.auth.currentUser?.id;
    if (sellerId == null) {
      throw StateError('A signed-in user is required to submit a product.');
    }

    final productFolder = '$sellerId/${_newFolderId()}';
    final uploadedPaths = <String>[];
    var rpcAttempted = false;

    try {
      String? mainImagePath;
      if (input.mainImageBytes != null) {
        mainImagePath = '$productFolder/main.webp';
        uploadedPaths.add(mainImagePath);
        await _compressAndUpload(input.mainImageBytes!, mainImagePath);
      }

      final variants = <Map<String, dynamic>>[];
      for (var index = 0; index < input.variants.length; index++) {
        final variant = input.variants[index];
        String? imagePath;
        if (variant.imageBytes != null) {
          imagePath = '$productFolder/variants/variant_${index + 1}.webp';
          uploadedPaths.add(imagePath);
          await _compressAndUpload(variant.imageBytes!, imagePath);
        }

        variants.add({
          'name': variant.name,
          'price': variant.price,
          'stock_quantity': variant.stockQuantity,
          'image_path': imagePath,
        });
      }

      rpcAttempted = true;
      final response = await _client.rpc(
        'submit_product_with_variants',
        params: {
          'p_category_id': input.categoryId,
          'p_title': input.title,
          'p_variants': variants,
          'p_description': input.description,
          'p_main_image_path': mainImagePath,
        },
      );

      if (response is! num) {
        throw const FormatException(
          'Product submission RPC returned an invalid product ID.',
        );
      }

      return response.toInt();
    } catch (error) {
      final rpcRejected = error is PostgrestException;
      if (uploadedPaths.isNotEmpty && (!rpcAttempted || rpcRejected)) {
        try {
          await _client.storage.from(_bucket).remove(uploadedPaths);
        } catch (cleanupError) {
          AppHelpers.logger().error(cleanupError);
        }
      }

      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<int> updateProduct({required CreateProductInput input}) async {
    final productId = input.productId;
    final sellerId = _client.auth.currentUser?.id;
    if (productId == null) {
      throw ArgumentError('A product ID is required for updates.');
    }
    if (sellerId == null) {
      throw StateError('A signed-in user is required to update a product.');
    }

    final productFolder = '$sellerId/${_newFolderId()}';
    final uploadedPaths = <String>[];
    final previousPaths = <String>{};
    var rpcAttempted = false;

    try {
      final existingProduct = await _client
          .from('products')
          .select('main_image_url, variants:product_variants(image_url)')
          .eq('id', productId)
          .eq('seller_id', sellerId)
          .maybeSingle();

      if (existingProduct == null) {
        throw StateError('The product was not found or is not owned by you.');
      }

      final oldMainImagePath = existingProduct['main_image_url'] as String?;
      if (oldMainImagePath != null) previousPaths.add(oldMainImagePath);
      for (final variant in existingProduct['variants'] as List) {
        final oldImagePath = (variant as Map)['image_url'] as String?;
        if (oldImagePath != null) previousPaths.add(oldImagePath);
      }

      String? mainImagePath = input.mainImagePath;
      if (input.mainImageBytes != null) {
        mainImagePath = '$productFolder/main.webp';
        uploadedPaths.add(mainImagePath);
        await _compressAndUpload(input.mainImageBytes!, mainImagePath);
      }

      final variants = <Map<String, dynamic>>[];
      for (var index = 0; index < input.variants.length; index++) {
        final variant = input.variants[index];
        var imagePath = variant.imagePath;
        if (variant.imageBytes != null) {
          imagePath = '$productFolder/variants/variant_${index + 1}.webp';
          uploadedPaths.add(imagePath);
          await _compressAndUpload(variant.imageBytes!, imagePath);
        }

        variants.add({
          'id': variant.variantId,
          'name': variant.name,
          'price': variant.price,
          'stock_quantity': variant.stockQuantity,
          'image_path': imagePath,
        });
      }

      rpcAttempted = true;
      final response = await _client.rpc(
        'update_product_with_variants',
        params: {
          'p_product_id': productId,
          'p_category_id': input.categoryId,
          'p_title': input.title,
          'p_variants': variants,
          'p_description': input.description,
          'p_main_image_path': mainImagePath,
        },
      );

      if (response is! num || response.toInt() != productId) {
        throw const FormatException(
          'Product update RPC returned an invalid product ID.',
        );
      }

      final retainedPaths = <String>{
        ?mainImagePath,
        for (final variant in variants)
          if (variant['image_path'] case final String path) path,
      };
      final obsoletePaths = previousPaths.difference(retainedPaths);
      if (obsoletePaths.isNotEmpty) {
        try {
          await _client.storage.from(_bucket).remove(obsoletePaths.toList());
        } catch (cleanupError) {
          AppHelpers.logger().error(cleanupError);
        }
      }

      return productId;
    } catch (error) {
      final rpcRejected = error is PostgrestException;
      if (uploadedPaths.isNotEmpty && (!rpcAttempted || rpcRejected)) {
        try {
          await _client.storage.from(_bucket).remove(uploadedPaths);
        } catch (cleanupError) {
          AppHelpers.logger().error(cleanupError);
        }
      }

      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  Future<void> _compressAndUpload(Uint8List source, String path) async {
    final compressed = await FlutterImageCompress.compressWithList(
      source,
      minWidth: 1600,
      minHeight: 1600,
      quality: 82,
      format: CompressFormat.webp,
    );

    if (compressed.isEmpty) {
      throw StateError('Image compression returned no data.');
    }

    await _client.storage
        .from(_bucket)
        .uploadBinary(
          path,
          compressed,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            contentType: 'image/webp',
            upsert: false,
          ),
        );
  }

  String _newFolderId() {
    final random = Random.secure();
    return List<int>.generate(
      16,
      (_) => random.nextInt(256),
    ).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}
