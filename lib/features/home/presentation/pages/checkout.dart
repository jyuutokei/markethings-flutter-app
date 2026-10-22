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

  Future<void> insertOrder() async {
    try {
      final order = await sl<PlaceOrder>().call(
        cartItemIds: _cartItems.map((item) => item.cartItemId).toList(),
      );

      if (!mounted) return;
      context.pushReplacementNamed(AppRoute.orderConfirm, extra: order.orderId);
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
            content: Text(
              'Order total: ${AppHelpers.pesoFormatter(totalCartItems())}',
            ),
          ),
        ],
      ),
    );
  }
}
