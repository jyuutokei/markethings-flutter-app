import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/features/home/data/models/product.dart';
import 'package:mt/features/home/presentation/widgets/header_appbar.dart';
import 'package:mt/features/home/presentation/widgets/sidebar.dart';
import 'package:sidebarx/sidebarx.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  double get _total => demoProduct.fold(
    0,
    (sum, product) => sum + (product.price) * (product.quantity),
  );

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: HeaderAppbar(scaffoldKey: _scaffoldKey, title: "Cart"),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: demoProduct.length,
              itemBuilder: (context, index) {
                final product = demoProduct[index];
                return Dismissible(
                  key: Key(product.title),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => setState(
                    () => demoProduct.removeWhere(
                      (x) => x.title == product.title,
                    ),
                  ),
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: defaultPadding),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(product.title),
                      subtitle: Text('\$${product.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              product.quantityAdd();
                            },
                          ),
                          Text(
                            "${product.quantity}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              product.quantityReduce();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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
                    Text(
                      "\$${_total.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
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
