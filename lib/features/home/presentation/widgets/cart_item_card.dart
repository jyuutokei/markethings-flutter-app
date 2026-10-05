import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';

class CartItemCard extends StatefulWidget {
  final CartItemDetailsEntity cartItem;

  const CartItemCard({super.key, required this.cartItem});

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  CartItemDetailsEntity get cartItem => widget.cartItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cartItem.productTitle),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {},
      background: Container(
        color: AppHelpers.errorColor(context),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: defaultPadding),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 4,
        ),
        child: ListTile(
          leading: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
            ),
            child: Image.asset(
              "assets/images/sample/product_0.png",
              height: 132,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.productTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Gap(defaultPadding / 16),
              const Text(
                'Variant:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                cartItem.variantName,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Gap(defaultPadding / 16),
            ],
          ),
          subtitle: Text(
            AppHelpers.pesoFormatter(cartItem.price),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppHelpers.primaryColor(context),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              cartItem.quantity == 1
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: AppHelpers.primaryColor(context),
                      ),
                      onPressed: () {},
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: AppHelpers.primaryColor(context),
                      ),
                      onPressed: () {},
                    ),
              Text(
                "${cartItem.quantity}",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.add, color: AppHelpers.primaryColor(context)),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
