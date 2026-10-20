import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/tab_refresher.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartItemCard extends StatefulWidget {
  final CartItemDetailsEntity cartItem;
  final int quantity;
  final bool isUpdating;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.quantity,
    required this.isUpdating,
    required this.isSelected,
    required this.onTap,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  CartItemDetailsEntity get cartItem => widget.cartItem;
  final SupabaseClient _client = sl<SupabaseClient>();
  String fallbackImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIVapXPpvWb8ds1BaPIHsUEKnobPWCWI3srk7Wc5hFNA&s=10';

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
      key: ValueKey(cartItem.cartItemId),
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
        color: widget.isSelected
            ? AppHelpers.primaryColor(context)
            : Colors.white,
        margin: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: 4,
        ),
        child: ListTile(
          onTap: widget.onTap,
          leading: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
            ),
            child: Skeleton.replace(
              width: 56,
              height: 56,
              child: CachedNetworkImage(
                imageUrl: cartItem.imageUrl ?? fallbackImageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  height: 56,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: imageProvider,
                    ),
                  ),
                ),
                placeholder: (context, url) => const SizedBox.expand(),
                errorBuilder: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.productTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected ? Colors.white : Colors.black,
                ),
              ),
              const Gap(defaultPadding / 16),
              Text(
                'Variant:',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isSelected ? Colors.white : Colors.grey,
                ),
              ),
              Text(
                cartItem.variantName,
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isSelected ? Colors.white : Colors.grey,
                ),
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
              color: widget.isSelected
                  ? Colors.white
                  : AppHelpers.primaryColor(context),
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
                      : widget.isSelected
                      ? Colors.white
                      : AppHelpers.primaryColor(context),
                ),
                onPressed: widget.isUpdating
                    ? null
                    : widget.quantity == 1
                    ? _confirmAndDelete
                    : widget.onDecrease,
              ),
              Text(
                "${widget.quantity}",
                style: TextStyle(
                  fontSize: 16,
                  color: widget.isSelected ? Colors.white : Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: widget.isUpdating
                      ? Colors.grey
                      : widget.isSelected
                      ? Colors.white
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
