import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/router/tab_refresher.dart';
import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/usecases/get_product_card_details.dart';
import 'package:mt/features/home/presentation/widgets/product_card.dart';
import 'package:mt/injection_container.dart';
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
          child: SectionTitle(title: "New Arrival", pressSeeAll: () {}),
        ),
        FutureBuilder<List<ProductCardEntity>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: SpinKitCubeGrid(color: Colors.white));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final productCardDetails = snapshot.data ?? [];
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(defaultPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: productCardDetails.length,
              itemBuilder: (context, index) {
                final productCardDetail = productCardDetails[index];

                return ProductCard(
                  title: productCardDetail.title,
                  image: productCardDetail.mainImageUrl,
                  price: productCardDetail.price,
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
      ],
    );
  }
}
