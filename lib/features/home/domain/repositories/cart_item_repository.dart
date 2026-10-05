import 'package:mt/features/home/domain/entities/cart_item_add_entity.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';

abstract class CartItemRepository {
  Future<CartItemAddEntity> addCartItem({required int variantId});
  Future<List<CartItemDetailsEntity>> getCartItemDetails();
}
