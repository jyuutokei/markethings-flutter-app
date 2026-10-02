import 'package:mt/features/home/domain/entities/cart_item_entity.dart';

abstract class CartItemRepository {
  Future<CartItemEntity> addItem({required int variantId, int quantity = 1});
}
