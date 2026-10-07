import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Checkout extends StatefulWidget {
  final List<CartItemDetailsEntity> cartItems;

  const Checkout({super.key, required this.cartItems});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  List<CartItemDetailsEntity> get _cartItems => widget.cartItems;
  var _step = 0;

  Future<void> deleteMultipleRows(List<CartItemDetailsEntity> items) async {
    try {
      final List<int> cartItemIds = items
          .map((item) => item.cartItemId)
          .toList();

      await sl<SupabaseClient>()
          .from('cart_items')
          .delete()
          .inFilter('id', cartItemIds);
    } catch (error) {
      AppHelpers.logger().error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/Location.svg"),
            const Gap(defaultPadding / 2),
            const Text("Checkout"),
            const Gap(defaultPadding * 2),
          ],
        ),
      ),
      body: Stepper(
        currentStep: _step,
        onStepContinue: () async {
          if (_step == 2) {
            await deleteMultipleRows(_cartItems);

            if (mounted) {
              context.pushReplacementNamed(AppRoute.orderConfirm);
            }
            return;
          }

          return setState(() => _step = (_step + 1).clamp(0, 2));
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
              'Order total: ${AppHelpers.pesoFormatter(_cartItems.fold(0, (sum, item) => sum + item.price * item.quantity))}',
            ),
          ),
        ],
      ),
    );
  }
}
