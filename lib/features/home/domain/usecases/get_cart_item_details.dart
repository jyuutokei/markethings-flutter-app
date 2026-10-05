import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/features/home/domain/repositories/cart_item_repository.dart';

class GetCartItemDetails {
  final CartItemRepository repository;

  const GetCartItemDetails(this.repository);

  Future<List<CartItemDetailsEntity>> call() {
    return repository.getCartItemDetails();
  }
}
