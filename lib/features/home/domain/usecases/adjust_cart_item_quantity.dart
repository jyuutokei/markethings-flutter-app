import 'package:mt/features/home/domain/entities/cart_item_add_entity.dart';
import 'package:mt/features/home/domain/repositories/cart_item_repository.dart';

class AdjustCartItemQuantity {
  final CartItemRepository repository;

  const AdjustCartItemQuantity(this.repository);

  Future<CartItemAddEntity> call({
    required int variantId,
    required int quantityValue,
  }) {
    return repository.adjustCartItemQuantity(
      variantId: variantId,
      quantityValue: quantityValue,
    );
  }
}
