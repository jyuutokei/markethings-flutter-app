import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/usecases/get_favorite_products.dart';
import 'package:mt/features/home/presentation/store/favorites_store.dart';
import 'package:mt/features/home/presentation/widgets/appbar_main.dart';
import 'package:mt/features/home/presentation/widgets/product_card.dart';
import 'package:mt/features/home/presentation/widgets/sidebar.dart';
import 'package:mt/injection_container.dart';
import 'package:sidebarx/sidebarx.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);
  late final Future<List<ProductCardEntity>> _favoriteProductCardsFuture;

  @override
  void initState() {
    super.initState();
    _favoriteProductCardsFuture = sl<GetFavoriteProducts>().call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: AppBarMain(scaffoldKey: _scaffoldKey, title: "Favorites"),
      body: FutureBuilder<List<ProductCardEntity>>(
        future: _favoriteProductCardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitPumpingHeart(color: Colors.white),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ValueListenableBuilder<Set<int>>(
            valueListenable: sl<FavoritesStore>().ids,
            builder: (context, ids, _) {
              final items = snapshot.data!
                  .where((prd) => ids.contains(prd.id))
                  .toList();

              if (items.isEmpty) {
                return const Center(child: Text('No favorites yet'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(defaultPadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final products = items[index];

                  return ProductCard(
                    title: products.title,
                    image: products.mainImageUrl,
                    price: products.price,
                    productId: products.id,
                    sellerId: products.sellerId,
                    press: () {
                      context.pushNamed(
                        AppRoute.productDetails,
                        pathParameters: {'productId': products.id.toString()},
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
