import 'package:mt/features/home/domain/entities/cart_item_add_entity.dart';
import 'package:mt/features/home/domain/repositories/cart_item_repository.dart';

class AddCartItem {
  final CartItemRepository repository;

  const AddCartItem(this.repository);

  Future<CartItemAddEntity> call({required int variantId}) {
    return repository.addCartItem(variantId: variantId);
  }
}
