import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/tab_refresher.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartItemCard extends StatefulWidget {
  final CartItemDetailsEntity cartItem;
  final int quantity;
  final bool isUpdating;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.quantity,
    required this.isUpdating,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  CartItemDetailsEntity get cartItem => widget.cartItem;
  final SupabaseClient _client = sl<SupabaseClient>();

  Future<void> deleteCartItem(int id) async {
    await _client.from('cart_items').delete().eq('id', id);

    if (mounted) {
      cartTabRefresher.notifyCartTabSelected();

      AppHelpers.showSnackBar(
        context,
        'Cart item deleted',
        'Deleted a cart item successfully',
        ContentType.success,
      );
    }
  }

  Future<bool> _confirmDelete() {
    return AppHelpers.showCenterModal(
      context,
      'Do you want to remove this item?',
      '${cartItem.productTitle}\nVariant: ${cartItem.variantName}',
    );
  }

  Future<void> _confirmAndDelete() async {
    if (await _confirmDelete()) {
      await deleteCartItem(cartItem.cartItemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cartItem.productTitle),
      direction: widget.isUpdating
          ? DismissDirection.none
          : DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(),
      onDismissed: (_) => deleteCartItem(cartItem.cartItemId),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(defaultPadding / 16),
            ],
          ),
          subtitle: Text(
            AppHelpers.pesoFormatter(cartItem.price * widget.quantity),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppHelpers.primaryColor(context),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  widget.quantity == 1 ? Icons.delete : Icons.remove,
                  color: widget.isUpdating
                      ? Colors.grey
                      : AppHelpers.primaryColor(context),
                ),
                onPressed: widget.isUpdating
                    ? null
                    : widget.quantity == 1
                    ? _confirmAndDelete
                    : widget.onDecrease,
              ),
              Text("${widget.quantity}", style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: widget.isUpdating
                      ? Colors.grey
                      : AppHelpers.primaryColor(context),
                ),
                onPressed: widget.isUpdating ? null : widget.onIncrease,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
