import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/usecases/get_favorite_products.dart';
import 'package:mt/features/home/presentation/store/favorites_store.dart';
import 'package:mt/features/home/presentation/widgets/product_card.dart';
import 'package:mt/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  static const _pageSize = 6;
  late final _favoritesStore = sl<FavoritesStore>();
  late final _pagingController = PagingController<int, ProductCardEntity>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => sl<GetFavoriteProducts>().call(
      limit: _pageSize,
      offset: (pageKey - 1) * _pageSize,
    ),
  );

  @override
  void initState() {
    super.initState();
    _favoritesStore.addListener(_refreshFavorites);
  }

  void _refreshFavorites() {
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _favoritesStore.removeListener(_refreshFavorites);
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) {
          return ValueListenableBuilder(
            valueListenable: sl<FavoritesStore>().ids,
            builder: (context, favoriteIds, _) {
              final visibleState = state.filterItems(
                (product) => favoriteIds.contains(product.id),
              );

              return LayoutBuilder(
                builder: (context, constraints) {
                  final columns = ProductCard.productGridColumns(
                    constraints.maxWidth,
                  );
                  const spacing = defaultPadding;

                  final tileWidth =
                      (constraints.maxWidth -
                          defaultPadding * 4 -
                          spacing * (columns - 1)) /
                      columns;

                  return PagedGridView<int, ProductCardEntity>(
                    state: visibleState,
                    fetchNextPage: fetchNextPage,
                    padding: const EdgeInsets.all(defaultPadding * 2),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: ProductCard.estimatedHeightForWidth(
                        tileWidth,
                      ),
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<ProductCardEntity>(
                      itemBuilder: (context, product, index) => ProductCard(
                        title: product.title,
                        price: product.price,
                        image: product.mainImageUrl,
                        productId: product.id,
                        sellerId: product.sellerId,
                        press: () {
                          context.pushNamed(
                            AppRoute.productDetails,
                            pathParameters: {
                              'productId': product.id.toString(),
                            },
                          );
                        },
                      ),
                      firstPageProgressIndicatorBuilder: (_) =>
                          Skeletonizer.zone(
                            child: Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: List.generate(
                                _pageSize,
                                (_) => SizedBox(
                                  width: tileWidth,
                                  height: ProductCard.estimatedHeightForWidth(
                                    tileWidth,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                      defaultPadding / 2,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(defaultBorderRadius),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Bone(
                                          width: double.infinity,
                                          height:
                                              ProductCard.imageHeightForWidth(
                                                tileWidth,
                                              ),
                                        ),
                                        const Gap(defaultPadding / 1.5),
                                        const Bone.text(words: 2),
                                        const Gap(defaultPadding),
                                        const Bone.text(words: 2),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      noItemsFoundIndicatorBuilder: (_) =>
                          const Center(child: Text('No favorites yet')),
                    ),
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
