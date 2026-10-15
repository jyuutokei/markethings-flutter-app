import 'package:mt/features/home/domain/entities/product_title_entity.dart';

class ProductTitleModel extends ProductTitleEntity {
  const ProductTitleModel({required super.title, required super.id});

  factory ProductTitleModel.fromJson(Map<String, dynamic> json) {
    return ProductTitleModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}
