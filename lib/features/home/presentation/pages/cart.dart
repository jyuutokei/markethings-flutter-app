import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/features/home/domain/usecases/get_cart_item_details.dart';
import 'package:mt/features/home/presentation/widgets/cart_item_card.dart';
import 'package:mt/features/home/presentation/widgets/header_appbar.dart';
import 'package:mt/features/home/presentation/widgets/sidebar.dart';
import 'package:mt/injection_container.dart';
import 'package:sidebarx/sidebarx.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Future<List<CartItemDetailsEntity>> _cartItemsFuture;

  // double get _total => demoProduct.fold(
  //   0,
  //   (sum, product) => sum + (product.price * product.quantity),
  // );

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = sl<GetCartItemDetails>().call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: HeaderAppbar(scaffoldKey: _scaffoldKey, title: "Cart"),
      body: Column(
        children: [
          const Gap(defaultPadding / 2),
          Expanded(
            child: FutureBuilder(
              future: _cartItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitPianoWave(color: Colors.white),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final cartItems = snapshot.data ?? [];

                return cartItems.isNotEmpty
                    ? ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];

                          return CartItemCard(cartItem: cartItem);
                        },
                      )
                    : const Center(child: Text("No items added to cart yet."));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text("", style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const Gap(defaultPadding / 2),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text("Checkout"),
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
