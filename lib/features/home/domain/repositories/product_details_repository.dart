import 'package:mt/features/home/domain/entities/product_details_entity.dart';

abstract class ProductDetailsRepository {
  Future<ProductDetailsEntity> getProductDetail(int productId);
}
