import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/features/home/domain/usecases/place_order.dart';
import 'package:mt/features/home/presentation/widgets/appbar_sub.dart';
import 'package:mt/features/home/presentation/widgets/payment_form.dart';
import 'package:mt/injection_container.dart';

class Checkout extends StatefulWidget {
  final List<CartItemDetailsEntity> cartItems;

  const Checkout({super.key, required this.cartItems});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  List<CartItemDetailsEntity> get _cartItems => widget.cartItems;
  var _step = 0;
  String fallbackImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIVapXPpvWb8ds1BaPIHsUEKnobPWCWI3srk7Wc5hFNA&s=10';

  Future<void> insertOrder() async {
    try {
      final order = await sl<PlaceOrder>().call(
        cartItemIds: _cartItems.map((item) => item.cartItemId).toList(),
      );

      if (!mounted) return;
      context.pushReplacementNamed(
        AppRoute.orderConfirm,
        extra: {'orderId': order.orderId, 'cartItems': _cartItems},
      );
    } catch (error) {
      AppHelpers.logger().error(error);
    }
  }

  num totalCartItems() {
    return _cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarSub(title: 'Checkout'),
      body: Stepper(
        currentStep: _step,
        onStepContinue: () async {
          if (_step == 2) {
            final confirmed = await AppHelpers.showCenterModal(
              context,
              'Place order?',
              'Are you sure you want to place this order?',
            );
            if (!confirmed) return;

            await insertOrder();
            return;
          }

          setState(() => _step = (_step + 1).clamp(0, 2));
        },
        onStepCancel: () => setState(() => _step = (_step - 1).clamp(0, 2)),
        steps: [
          Step(
            title: const Text('Shipping'),
            content: Column(
              children: [
                const Gap(defaultPadding / 2),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Recipient name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(defaultPadding / 2),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(defaultPadding / 2),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Street address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(defaultPadding / 2),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Barangay/Neighborhood',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(defaultPadding / 2),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'City/Municipality',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(defaultPadding / 2),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'State/Province',
                    border: OutlineInputBorder(),
                  ),
                ),
                const Gap(defaultPadding / 2),
                TextFormField(
                  // ph lenght postal code
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'ZIP/Postal code',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const Step(
            title: Text('Payment'),
            content: Column(children: [Gap(defaultPadding), PaymentForm()]),
          ),
          Step(
            title: const Text('Summary'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final item in _cartItems) ...[
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 6,
                    ),
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(defaultBorderRadius),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius,
                          ),
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: CachedNetworkImage(
                              imageUrl: item.imageUrl ?? fallbackImageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider,
                                      ),
                                    ),
                                  ),
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const SizedBox.expand(),
                              errorBuilder: (context, url, error) {
                                AppHelpers.logger().error(error);
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                        ),
                        const Gap(defaultPadding / 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Variant: ${item.variantName}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text('Quantity: ${item.quantity}'),
                              const Gap(defaultPadding / 2),
                              Text(
                                AppHelpers.pesoFormatter(
                                  item.price * item.quantity,
                                ),
                                style: TextStyle(
                                  color: AppHelpers.primaryColor(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(defaultPadding / 2),
                ],
                const Gap(defaultPadding / 2),
                Text(
                  'Order Total: ${AppHelpers.pesoFormatter(totalCartItems())}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
