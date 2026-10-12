import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String displayName;
  final String? storeName;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.displayName,
    this.storeName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, displayName, storeName, avatarUrl];
}
