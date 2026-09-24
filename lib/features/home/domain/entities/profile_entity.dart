import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id; // uuid, references auth.users
  final String displayName;
  final String? storeName;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.id,
    required this.displayName,
    this.storeName,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    displayName,
    storeName,
    avatarUrl,
    createdAt,
    updatedAt,
  ];
}
