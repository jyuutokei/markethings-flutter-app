import 'package:mt/features/home/domain/entities/order_card_entity.dart';

class OrderLineItemModel extends OrderLineItemEntity {
  const OrderLineItemModel({
    required super.id,
    super.productId,
    super.variantId,
    required super.productTitle,
    required super.variantName,
    required super.unitPrice,
    required super.quantity,
    super.imageUrl,
  });

  factory OrderLineItemModel.fromJson(Map<String, dynamic> json) {
    return OrderLineItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int?,
      variantId: json['variant_id'] as int,
      productTitle: json['product_title'] as String,
      variantName: json['variant_name'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }
}

class OrderCardModel extends OrderCardEntity {
  const OrderCardModel({
    required super.id,
    required super.status,
    required super.createdAt,
    required super.items,
  });

  factory OrderCardModel.fromJson(Map<String, dynamic> json) {
    final orderItems = json['order_items'] as List<dynamic>;

    return OrderCardModel(
      id: json['id'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: orderItems
          .map(
            (item) => OrderLineItemModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
