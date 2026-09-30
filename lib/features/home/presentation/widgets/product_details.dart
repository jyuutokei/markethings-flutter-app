import 'package:flutter/material.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/product_details_entity.dart';
import 'package:mt/features/home/presentation/widgets/color_dot.dart';

class ProductDetails extends StatelessWidget {
  final ProductDetailsEntity productDetails;

  const ProductDetails({super.key, required this.productDetails});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Column(
        children: [
          Image.asset(
            "assets/images/sample/product_0.png",
            height: MediaQuery.of(context).size.height * 0.4,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: defaultPadding * 1.5),
          Container(
            padding: const EdgeInsets.fromLTRB(
              defaultPadding,
              defaultPadding * 2,
              defaultPadding,
              defaultPadding,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius * 3),
                topRight: Radius.circular(defaultBorderRadius * 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        productDetails.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Text(
                      AppHelpers.pesoFormatter(
                        productDetails.variants[1].price,
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(productDetails.description ?? "No description"),
                ),
                Text("Colors", style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: defaultPadding / 2),
                const Row(
                  children: [
                    ColorDot(color: Color(0xFFBEE8EA), isActive: false),
                    ColorDot(color: Color(0xFF141B4A), isActive: true),
                    ColorDot(color: Color(0xFFF4E5C3), isActive: false),
                  ],
                ),
                const SizedBox(height: defaultPadding * 2),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Add to Cart"),
                    ),
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
