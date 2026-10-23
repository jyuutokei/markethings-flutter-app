import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getUserProfile(String userId);
  Future<void> updateUserProfile({
    required String userId,
    required String displayName,
    required String? storeName,
    required String? avatarUrl,
    required Uint8List? avatarBytes,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _client;
  static const _avatarBucket = 'avatars';

  const ProfileRemoteDataSourceImpl(this._client);

  @override
  Future<ProfileModel> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('id, display_name, store_name, avatar_url')
          .eq('id', userId)
          .single();

      return ProfileModel.fromJson(response);
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required String displayName,
    required String? storeName,
    required String? avatarUrl,
    required Uint8List? avatarBytes,
  }) async {
    try {
      if (_client.auth.currentUser?.id != userId) {
        throw StateError('You can only update your own profile.');
      }

      var savedAvatarUrl = avatarUrl;
      if (avatarBytes != null) {
        final compressedAvatar = await FlutterImageCompress.compressWithList(
          avatarBytes,
          minWidth: 512,
          minHeight: 512,
          quality: 85,
          format: CompressFormat.webp,
        );

        if (compressedAvatar.isEmpty) {
          throw StateError('Avatar image compression returned no data.');
        }

        const avatarPath = 'avatar.webp';
        final storagePath = '$userId/$avatarPath';
        await _client.storage
            .from(_avatarBucket)
            .uploadBinary(
              storagePath,
              compressedAvatar,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                contentType: 'image/webp',
                upsert: true,
              ),
            );

        savedAvatarUrl = _client.storage
            .from(_avatarBucket)
            .getPublicUrl(
              storagePath,
              cacheNonce: DateTime.now().millisecondsSinceEpoch.toString(),
            );
      }

      final response = await _client
          .from('profiles')
          .update({
            'display_name': displayName,
            'store_name': storeName,
            'avatar_url': savedAvatarUrl,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', userId)
          .select('id')
          .maybeSingle();

      if (response == null) {
        throw StateError('The profile was not updated.');
      }
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
