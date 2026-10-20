import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/presentation/store/favorites_store.dart';
import 'package:mt/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.title,
    this.image,
    required this.price,
    required this.press,
    required this.productId,
    required this.sellerId,
  });

  final String title;
  final String? image;
  final VoidCallback press;
  final num price;
  final int productId;
  final String sellerId;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String fallbackImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIVapXPpvWb8ds1BaPIHsUEKnobPWCWI3srk7Wc5hFNA&s=10';

  Future<void> _onToggleFavorite() async {
    final ok = await sl<FavoritesStore>().toggle(widget.productId);
    if (!ok && mounted) {
      AppHelpers.showSnackBar(
        context,
        "Error",
        "Failed to update favorites",
        ContentType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOwner =
        sl<SupabaseClient>().auth.currentUser?.id == widget.sellerId;

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
                  child: SizedBox(
                    width: double.infinity,
                    height: 132,
                    child: Skeleton.replace(
                      width: double.infinity,
                      height: 132,
                      child: CachedNetworkImage(
                        imageUrl: widget.image ?? fallbackImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 132,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const SizedBox.expand(),
                        errorBuilder: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const Gap(defaultPadding / 2),
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
            if (!isOwner)
              Positioned(
                top: 0,
                right: 0,
                child: ValueListenableBuilder<Set<int>>(
                  valueListenable: sl<FavoritesStore>().ids,
                  builder: (context, ids, _) {
                    final isFavorite = ids.contains(widget.productId);
                    return IconButton(
                      onPressed: _onToggleFavorite,
                      icon: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
