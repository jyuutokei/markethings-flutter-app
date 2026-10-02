import 'package:mt/features/home/domain/entities/cart_item_entity.dart';
import 'package:mt/features/home/domain/repositories/cart_item_repository.dart';

class AddCartItem {
  final CartItemRepository repository;

  const AddCartItem(this.repository);

  Future<CartItemEntity> call({required int variantId, int quantity = 1}) {
    return repository.addItem(variantId: variantId, quantity: quantity);
  }
}
