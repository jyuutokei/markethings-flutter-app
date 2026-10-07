import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/router/tab_refresher.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/cart_item_details_entity.dart';
import 'package:mt/features/home/domain/usecases/adjust_cart_item_quantity.dart';
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);

  final Map<int, int> _quantities = {};
  final Map<int, int> _pendingDeltas = {};
  final Map<int, Debouncer> _itemDebouncers = {};
  final Set<int> _updatingItemIds = {};
  final Set<int> _selectedCartItemIds = {};

  int _quantityFor(CartItemDetailsEntity item) =>
      _quantities[item.cartItemId] ?? item.quantity;

  Debouncer _debouncerFor(int itemId) =>
      _itemDebouncers.putIfAbsent(itemId, Debouncer.new);

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = sl<GetCartItemDetails>().call();
    cartTabRefresher.addListener(_onCartTabSelectedCart);
  }

  @override
  void dispose() {
    cartTabRefresher.removeListener(_onCartTabSelectedCart);
    for (final debouncer in _itemDebouncers.values) {
      debouncer.cancel();
    }
    super.dispose();
  }

  void _onCartTabSelectedCart() {
    setState(() {
      _cartItemsFuture = sl<GetCartItemDetails>().call();
    });
  }

  void _changeQuantity(CartItemDetailsEntity item, int delta) {
    final id = item.cartItemId;
    final nextQuantity = _quantityFor(item) + delta;

    if (nextQuantity < 1) return;

    setState(() {
      _quantities[id] = nextQuantity;
      _pendingDeltas.update(
        id,
        (pending) => pending + delta,
        ifAbsent: () => delta,
      );
    });

    final pendingDelta = _pendingDeltas[id]!;
    if (pendingDelta == 0) {
      _debouncerFor(id).cancel();
      setState(() {
        _pendingDeltas.remove(id);
        _quantities.remove(id);
      });
      return;
    }

    _debouncerFor(id).debounce(
      duration: const Duration(milliseconds: 400),
      onDebounce: () => _saveQuantityChange(item),
    );
  }

  void _toggleSelection(CartItemDetailsEntity item) {
    setState(() {
      if (!_selectedCartItemIds.add(item.cartItemId)) {
        _selectedCartItemIds.remove(item.cartItemId);
      }
    });
  }

  Future<void> _saveQuantityChange(CartItemDetailsEntity item) async {
    final id = item.cartItemId;
    final delta = _pendingDeltas.remove(id) ?? 0;
    if (delta == 0 || !mounted) return;

    final previousQuantity = _quantityFor(item) - delta;
    setState(() => _updatingItemIds.add(id));

    try {
      final result = await sl<AdjustCartItemQuantity>().call(
        variantId: item.variantId,
        quantityValue: delta,
      );

      if (!mounted) return;
      setState(() => _quantities[id] = result.quantity);
    } catch (error) {
      if (!mounted) return;
      setState(() => _quantities[id] = previousQuantity);
      AppHelpers.showSnackBar(
        context,
        'Error',
        'Could not update item quantity.',
        ContentType.failure,
      );
      AppHelpers.logger().error(error);
    } finally {
      if (mounted) {
        setState(() => _updatingItemIds.remove(id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: HeaderAppbar(scaffoldKey: _scaffoldKey, title: 'Shopping cart'),
      body: FutureBuilder<List<CartItemDetailsEntity>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitPianoWave(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cartItems = snapshot.data ?? [];
          final selectedItems = cartItems
              .where((item) => _selectedCartItemIds.contains(item.cartItemId))
              .toList();
          final total = selectedItems.fold<double>(
            0,
            (sum, item) => sum + item.price * _quantityFor(item),
          );

          return Column(
            children: [
              const Gap(defaultPadding / 2),
              const Text(
                "Select the item you want to checkout.",
                textAlign: TextAlign.start,
              ),
              const Gap(defaultPadding / 2),
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(child: Text('No items added to cart yet.'))
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final id = item.cartItemId;
                          final quantity = _quantityFor(item);

                          return CartItemCard(
                            cartItem: item,
                            quantity: quantity,
                            isUpdating: _updatingItemIds.contains(id),
                            isSelected: _selectedCartItemIds.contains(
                              item.cartItemId,
                            ),
                            onTap: () => _toggleSelection(item),
                            onIncrease: () => _changeQuantity(item, 1),
                            onDecrease: () => _changeQuantity(item, -1),
                          );
                        },
                      ),
              ),
              Padding(
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
                          AppHelpers.pesoFormatter(total),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const Gap(defaultPadding / 2),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: selectedItems.isEmpty
                            ? null
                            : () {
                                context.pushNamed(
                                  AppRoute.checkout,
                                  extra: selectedItems,
                                );
                              },
                        child: const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
