import 'dart:typed_data';

import 'package:mt/features/home/domain/repositories/profile_repository.dart';

class UpdateUserProfile {
  final ProfileRepository repository;

  const UpdateUserProfile(this.repository);

  Future<void> call({
    required String userId,
    required String displayName,
    required String? storeName,
    required String? avatarUrl,
    required Uint8List? avatarBytes,
  }) {
    return repository.updateUserProfile(
      userId: userId,
      displayName: displayName,
      storeName: storeName,
      avatarUrl: avatarUrl,
      avatarBytes: avatarBytes,
    );
  }
}
