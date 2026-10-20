import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/product_details_entity.dart';

class ProductDetails extends StatefulWidget {
  final ProductDetailsEntity productDetails;
  final int? selectedVariantIndex;
  final ValueChanged<int?> onVariantSelected;

  const ProductDetails({
    super.key,
    required this.productDetails,
    this.selectedVariantIndex,
    required this.onVariantSelected,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<VariantEntity> get variants => widget.productDetails.variants;
  String fallbackImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIVapXPpvWb8ds1BaPIHsUEKnobPWCWI3srk7Wc5hFNA&s=10';

  @override
  void initState() {
    super.initState();
  }

  String priceLabel() {
    if (widget.selectedVariantIndex != null) {
      return AppHelpers.pesoFormatter(
        variants[widget.selectedVariantIndex!].price,
      );
    }

    if (variants.length == 1) {
      return AppHelpers.pesoFormatter(variants.first.price);
    }

    return "${AppHelpers.pesoFormatter(variants.first.price)} - "
        "${AppHelpers.pesoFormatter(variants.last.price)}";
  }

  String stockQuantityLabel() {
    if (widget.selectedVariantIndex == null) {
      return "Select a variant";
    }

    return "${variants[widget.selectedVariantIndex!].stockQuantity} pieces available";
  }

  String? variantImageDisplay() {
    if (widget.selectedVariantIndex != null) {
      return variants[widget.selectedVariantIndex!].imageUrl;
    }

    return widget.productDetails.mainImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: variantImageDisplay() ?? fallbackImageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
              ),
            ),
            placeholder: (context, url) =>
                const SpinKitRing(color: Colors.white),
            errorBuilder: (context, url, error) => const Icon(Icons.error),
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
                Text(
                  priceLabel(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppHelpers.primaryColor(context),
                  ),
                ),
                const Gap(defaultPadding),
                Text(
                  widget.productDetails.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(defaultPadding * 2),
                const Text(
                  "Variants",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Gap(defaultPadding / 2),
                Wrap(
                  spacing: defaultPadding / 2,
                  runSpacing: defaultPadding / 2,
                  alignment: WrapAlignment.start,
                  children: List.generate(
                    variants.length,
                    (index) => ChoiceChip(
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                        vertical: defaultPadding / 4,
                      ),
                      shape: const StadiumBorder(),
                      avatar: CachedNetworkImage(
                        imageUrl:
                            variants[index].imageUrl ??
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIVapXPpvWb8ds1BaPIHsUEKnobPWCWI3srk7Wc5hFNA&s=10',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const SpinKitRing(color: Colors.white),
                        errorBuilder: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      label: Text(
                        widget.productDetails.variants[index].name,
                        softWrap: true,
                      ),
                      labelStyle: TextStyle(
                        color: widget.selectedVariantIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      side: const BorderSide(color: Colors.black12, width: 1),
                      selected: widget.selectedVariantIndex == index,
                      onSelected: variants[index].stockQuantity == 0
                          ? null
                          : (selected) {
                              widget.onVariantSelected(selected ? index : null);
                            },
                      selectedColor: AppHelpers.primaryColor(context),
                      showCheckmark: false,
                    ),
                  ),
                ),
                const Gap(defaultPadding / 2),
                const Text(
                  "Stock quantity:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(stockQuantityLabel()),
                const Gap(defaultPadding * 2),
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding / 2,
                  ),
                  child: Text(
                    widget.productDetails.description ?? "No description",
                  ),
                ),
                const Gap(defaultPadding / 2),
                // display seller name
                const Text(
                  "Seller:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.productDetails.sellerStoreName ??
                      widget.productDetails.sellerDisplayName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
