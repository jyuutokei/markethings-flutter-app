import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/create_product_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CreateProductRemoteDataSource {
  Future<int> submitProduct({required CreateProductInput input});
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
