import 'package:mt/features/home/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.displayName,
    super.storeName,
    super.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      storeName: json['store_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
