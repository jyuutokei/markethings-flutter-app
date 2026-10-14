import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/order_card_entity.dart';

class OrderItemsCard extends StatefulWidget {
  final OrderLineItemEntity _orderLineItem;
  const OrderItemsCard({super.key, required this._orderLineItem});

  @override
  State<OrderItemsCard> createState() => _OrderItemsCardState();
}

class _OrderItemsCardState extends State<OrderItemsCard> {
  OrderLineItemEntity get orderLineItem => widget._orderLineItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset("assets/images/sample/product_0.png", height: 132),
      title: Text(
        orderLineItem.productTitle,
        style: const TextStyle(color: Colors.black),
      ),
      tileColor: Colors.white70,
      subtitle: Text(
        'Variant: ${orderLineItem.variantName}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Quantity: ${orderLineItem.quantity}',
            style: const TextStyle(fontSize: 12),
          ),
          const Gap(defaultPadding / 3),
          Text(
            'Subtotal: ${AppHelpers.pesoFormatter(orderLineItem.lineTotal)}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      onTap: () {
        context.pushNamed(
          AppRoute.productDetails,
          pathParameters: {'productId': orderLineItem.productId.toString()},
        );
      },
    );
  }
}
