import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.title,
    this.image,
    required this.price,
    required this.press,
  });
  final String title;
  final String? image;
  final VoidCallback press;
  final num price;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        width: 154,
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEFBF9),
                    borderRadius: BorderRadius.all(
                      Radius.circular(defaultBorderRadius),
                    ),
                  ),
                  child: Image.asset(
                    "assets/images/sample/product_0.png",
                    height: 132,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const Gap(defaultPadding / 4),
                Text(
                  AppHelpers.pesoFormatter(widget.price),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppHelpers.primaryColor(context),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset("assets/icons/Heart.svg", height: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
