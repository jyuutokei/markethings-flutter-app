import 'package:mt/features/home/domain/entities/product_title_entity.dart';

abstract class ProductTitleRepository {
  Future<List<ProductTitleEntity>> getProductTitles();
}
