import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, slug, createdAt];
}
