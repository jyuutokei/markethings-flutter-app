import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String icon, title;

  const CategoryEntity({required this.icon, required this.title});

  @override
  List<Object?> get props => [icon, title];
}
