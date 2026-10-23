import 'dart:typed_data';

import 'package:mt/features/home/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getUserProfile(String userId);
  Future<void> updateUserProfile({
    required String userId,
    required String displayName,
    required String? storeName,
    required String? avatarUrl,
    required Uint8List? avatarBytes,
  });
}
