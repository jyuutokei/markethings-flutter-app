import 'package:mt/features/home/data/datasources/cart_item_remote_data_source.dart';
import 'package:mt/features/home/domain/entities/cart_item_add_entity.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/features/home/domain/repositories/cart_item_repository.dart';

class CartItemRepositoryImpl implements CartItemRepository {
  final CartItemRemoteDataSource remoteDataSource;

  const CartItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<CartItemAddEntity> adjustCartItemQuantity({
    required int variantId,
    required int quantityValue,
  }) {
    return remoteDataSource.adjustCartItemQuantity(
      variantId: variantId,
      quantityValue: quantityValue,
    );
  }

  @override
  Future<List<CartItemDetailsEntity>> getCartItemDetails() {
    return remoteDataSource.getCartItemDetails();
  }
}
