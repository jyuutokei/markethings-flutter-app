import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SellerProductCard extends StatefulWidget {
  const SellerProductCard({
    super.key,
    required this.title,
    this.image,
    required this.price,
    required this.press,
    required this.productId,
    required this.sellerId,
    required this.isActive,
    required this.actionsEnabled,
    required this.onToggleActive,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final String? image;
  final VoidCallback press;
  final num price;
  final int productId;
  final String sellerId;
  final bool isActive;
  final bool actionsEnabled;
  final VoidCallback onToggleActive;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static double imageHeightForWidth(double width) =>
      (width * 0.85).clamp(96.0, 132.0).toDouble();

  static double estimatedHeightForWidth(double width) {
    final imageHeight = imageHeightForWidth(width);

    return defaultPadding +
        imageHeight +
        (defaultPadding / 1.5) +
        40 +
        (defaultPadding / 2) +
        20;
  }

  static int productGridColumns(double availableWidth) {
    if (availableWidth < 600) return 2;
    if (availableWidth < 900) return 3;
    if (availableWidth < 1200) return 4;
    return 5;
  }

  @override
  State<SellerProductCard> createState() => _SellerProductCardState();
}

class _SellerProductCardState extends State<SellerProductCard> {
  String fallbackImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIVapXPpvWb8ds1BaPIHsUEKnobPWCWI3srk7Wc5hFNA&s=10';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = SellerProductCard.imageHeightForWidth(
          constraints.maxWidth,
        );

        return GestureDetector(
          onTap: widget.press,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? const Color(0xFF287A4B)
                          : const Color(0xFF5F6368),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.isActive ? 'Active' : 'Inactive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
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
                      child: SizedBox(
                        width: double.infinity,
                        height: imageHeight,
                        child: Skeleton.replace(
                          width: double.infinity,
                          height: imageHeight,
                          child: CachedNetworkImage(
                            imageUrl: widget.image ?? fallbackImageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              height: imageHeight,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageProvider,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const SizedBox.expand(),
                            errorBuilder: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    const Gap(defaultPadding / 1.5),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(defaultPadding / 2),
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
                    onPressed: widget.actionsEnabled
                        ? widget.onToggleActive
                        : null,
                    tooltip: widget.isActive
                        ? 'Deactivate product'
                        : 'Activate product',
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        widget.isActive
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 0,
                  child: IconButton(
                    onPressed: widget.actionsEnabled ? widget.onEdit : null,
                    tooltip: 'Edit product',
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.edit,
                        color: AppHelpers.primaryColor(context),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  right: 0,
                  child: IconButton(
                    onPressed: widget.actionsEnabled ? widget.onDelete : null,
                    tooltip: 'Delete product',
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
