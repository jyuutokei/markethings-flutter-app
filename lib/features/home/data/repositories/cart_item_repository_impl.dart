import 'package:mt/features/home/data/datasources/cart_item_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/cart_item_entity.dart';
import 'package:mt/features/home/domain/repositories/cart_item_repository.dart';

class CartItemRepositoryImpl implements CartItemRepository {
  final CartItemRemoteDataSource remoteDataSource;

  const CartItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<CartItemEntity> addItem({required int variantId, int quantity = 1}) {
    return remoteDataSource.addCartItem(
      variantId: variantId,
      quantity: quantity,
    );
  }
}
