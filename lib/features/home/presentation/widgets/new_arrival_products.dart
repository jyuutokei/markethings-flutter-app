import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/home/data/models/product.dart';
import 'product_card.dart';
import 'section_title.dart';

class NewArrivalProducts extends StatelessWidget {
  const NewArrivalProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: SectionTitle(title: "New Arrival", pressSeeAll: () {}),
        ),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              demoProduct.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: ProductCard(
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
