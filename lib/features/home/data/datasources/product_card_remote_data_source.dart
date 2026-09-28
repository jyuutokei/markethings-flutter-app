import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/data/models/product_card_model.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class ProductCardRemoteDataSource {
  Future<List<ProductCardModel>> getProductCardDetails([int? limit]);
}

class ProductCardRemoteDataSourceImpl implements ProductCardRemoteDataSource {
  final SupabaseClient client;

  const ProductCardRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductCardModel>> getProductCardDetails([int? limit]) async {
    try {
      final response = await client.rpc(
        'get_product_card_details',
        params: {'_limit': limit},
      );

      return (response as List)
          .map((row) => ProductCardModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (error) {
      AppHelpers.logger().error(error);
      rethrow;
    }
  }
}
