import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/router/tab_refresher.dart';
import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/usecases/get_product_card_details.dart';
import 'package:mt/features/home/presentation/widgets/product_card.dart';
import 'package:mt/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'section_title.dart';

class NewArrivalProducts extends StatefulWidget {
  const NewArrivalProducts({super.key});

  @override
  State<NewArrivalProducts> createState() => _NewArrivalProductsState();
}

class _NewArrivalProductsState extends State<NewArrivalProducts> {
  late Future<List<ProductCardEntity>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = sl<GetProductCardDetails>().call(10);
    homeTabRefresher.addListener(_onHomeTabSelected);
  }

  void _onHomeTabSelected() {
    setState(() {
      _productsFuture = sl<GetProductCardDetails>().call(10);
    });
  }

  @override
  void dispose() {
    homeTabRefresher.removeListener(_onHomeTabSelected);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: defaultPadding),
          child: SectionTitle(
            title: "New Arrival",
            pressSeeAll: () {
              context.pushNamed(AppRoute.products);
            },
          ),
        ),
        FutureBuilder<List<ProductCardEntity>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            final loading =
                !snapshot.hasData &&
                snapshot.connectionState != ConnectionState.done;

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final productCardDetails = loading
                ? List.generate(
                    10,
                    (index) => ProductCardEntity(
                      id: -index - 1,
                      title: 'Product title',
                      categoryId: 0,
                      sellerId: '',
                      price: 0,
                      createdAt: DateTime(2000),
                    ),
                  )
                : snapshot.data ?? const <ProductCardEntity>[];

            return Skeletonizer(
              enabled: loading,
              ignorePointers: true,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = ProductCard.productGridColumns(
                    constraints.maxWidth,
                  );
                  const spacing = 16.0;

                  final tileWidth =
                      (constraints.maxWidth -
                          defaultPadding * 2 -
                          spacing * (columns - 1)) /
                      columns;

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(defaultPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: ProductCard.estimatedHeightForWidth(
                        tileWidth,
                      ),
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                    ),
                    itemCount: productCardDetails.length,
                    itemBuilder: (context, index) {
                      final productCardDetail = productCardDetails[index];

                      return ProductCard(
                        title: productCardDetail.title,
                        image: productCardDetail.mainImageUrl,
                        price: productCardDetail.price,
                        productId: productCardDetail.id,
                        sellerId: productCardDetail.sellerId,
                        press: () {
                          context.pushNamed(
                            AppRoute.productDetails,
                            pathParameters: {
                              'productId': productCardDetail.id.toString(),
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
