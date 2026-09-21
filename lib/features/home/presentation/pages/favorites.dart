import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/home/data/models/product.dart';
import 'package:mt/features/home/presentation/widgets/header_appbar.dart';
import 'package:mt/features/home/presentation/widgets/product_card.dart';
import 'package:mt/features/home/presentation/widgets/sidebar.dart';
import 'package:sidebarx/sidebarx.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: HeaderAppbar(scaffoldKey: _scaffoldKey, title: "Favorites"),
      body: GridView.builder(
        padding: const EdgeInsets.all(defaultPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
        ),
        itemBuilder: (context, index) {
          final product = demoProduct[index];

          if (!product.isFavorite) {
            return null;
          }

          return ProductCard(
            title: demoProduct[index].title,
            image: demoProduct[index].image,
            price: demoProduct[index].price,
            bgColor: demoProduct[index].bgColor,
            press: () {
              context.pushNamed(
                AppRoute.productDetails,
                extra: demoProduct[index],
              );
            },
          );
        },
      ),
    );
  }
}
