import 'package:equatable/equatable.dart';

class ProductTitleEntity extends Equatable {
  final int id;
  final String title;

  const ProductTitleEntity({required this.title, required this.id});

  @override
  List<Object?> get props => [id, title];
}
