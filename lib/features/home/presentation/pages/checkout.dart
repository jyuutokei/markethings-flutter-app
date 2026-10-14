import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/features/home/domain/usecases/place_order.dart';
import 'package:mt/features/home/presentation/widgets/appbar_sub.dart';
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
          const Step(
            title: Text('Shipping'),
            content: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const Step(
            title: Text('Payment'),
            content: TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
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
