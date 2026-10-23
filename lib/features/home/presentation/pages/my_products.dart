import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/seller_product_entity.dart';
import 'package:mt/features/home/domain/usecases/delete_seller_product.dart';
import 'package:mt/features/home/domain/usecases/get_seller_product_page.dart';
import 'package:mt/features/home/domain/usecases/set_seller_product_active.dart';
import 'package:mt/features/home/presentation/widgets/seller_product_card.dart';
import 'package:mt/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  static const _pageSize = 6;
  final Set<int> _pendingProductActions = {};

  late final _pagingController = PagingController<int, SellerProductEntity>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => sl<GetSellerProductPage>().call(
      limit: _pageSize,
      offset: (pageKey - 1) * _pageSize,
    ),
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _toggleProductActive(SellerProductEntity product) async {
    if (!_pendingProductActions.add(product.id)) return;

    final previousValue = product.isActive;
    final nextValue = !previousValue;
    setState(() {});
    _pagingController.mapItems(
      (item) =>
          item.id == product.id ? item.copyWith(isActive: nextValue) : item,
    );

    try {
      await sl<SetSellerProductActive>().call(
        productId: product.id,
        isActive: nextValue,
      );
    } catch (_) {
      if (mounted) {
        _pagingController.mapItems(
          (item) => item.id == product.id
              ? item.copyWith(isActive: previousValue)
              : item,
        );
        AppHelpers.showSnackBar(
          context,
          'Error',
          'Could not update product status. Try again.',
          ContentType.failure,
        );
      }
    } finally {
      _pendingProductActions.remove(product.id);
      if (mounted) setState(() {});
    }
  }

  Future<void> _deleteProduct(SellerProductEntity product) async {
    if (_pendingProductActions.contains(product.id)) return;

    final confirmed = await AppHelpers.showCenterModal(
      context,
      'Delete product?',
      'Delete "${product.title}"? This cannot be undone.',
    );
    if (!confirmed || !mounted) return;

    _pendingProductActions.add(product.id);
    setState(() {});
    _pagingController.value = _pagingController.value.filterItems(
      (item) => item.id != product.id,
    );

    try {
      await sl<DeleteSellerProduct>().call(productId: product.id);
      if (mounted) {
        AppHelpers.showSnackBar(
          context,
          'Deleted',
          'Product deleted successfully.',
          ContentType.success,
        );
      }
      if (mounted) _pagingController.refresh();
    } catch (_) {
      if (mounted) {
        _pagingController.refresh();
        AppHelpers.showSnackBar(
          context,
          'Error',
          'Could not delete product. Try again.',
          ContentType.failure,
        );
      }
    } finally {
      _pendingProductActions.remove(product.id);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/Location.svg"),
            const Gap(defaultPadding / 2),
            const Text("My Products"),
            const Gap(defaultPadding * 2),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: '',
            color: Colors.white,
            icon: const Icon(Icons.more_vert),
            onSelected: (action) {
              if (action == 'add') {
                context.pushNamed(AppRoute.createProduct);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.add_card),
                  title: Text('Add product'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => LayoutBuilder(
          builder: (context, constraints) {
            final columns = SellerProductCard.productGridColumns(
              constraints.maxWidth,
            );
            const spacing = 16.0;
            final tileWidth =
                (constraints.maxWidth -
                    defaultPadding * 2 -
                    spacing * (columns - 1)) /
                columns;

            return PagedGridView<int, SellerProductEntity>(
              state: state,
              fetchNextPage: fetchNextPage,
              padding: const EdgeInsets.all(defaultPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: SellerProductCard.estimatedHeightForWidth(
                  tileWidth,
                ),
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              builderDelegate: PagedChildBuilderDelegate<SellerProductEntity>(
                itemBuilder: (context, product, index) => SellerProductCard(
                  title: product.title,
                  image: product.mainImageUrl,
                  price: product.price,
                  productId: product.id,
                  sellerId: product.sellerId,
                  isActive: product.isActive,
                  actionsEnabled: !_pendingProductActions.contains(product.id),
                  onToggleActive: () => _toggleProductActive(product),
                  onEdit: () => context.pushNamed(
                    AppRoute.createProduct,
                    queryParameters: {'productId': product.id.toString()},
                  ),
                  onDelete: () => _deleteProduct(product),
                  press: () => context.pushNamed(
                    AppRoute.productDetails,
                    pathParameters: {'productId': product.id.toString()},
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) => Skeletonizer.zone(
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(
                      _pageSize,
                      (_) => SizedBox(
                        width: tileWidth,
                        height: SellerProductCard.estimatedHeightForWidth(
                          tileWidth,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding / 2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(defaultBorderRadius),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Bone(
                                width: double.infinity,
                                height: SellerProductCard.imageHeightForWidth(
                                  tileWidth,
                                ),
                              ),
                              const Gap(defaultPadding / 1.5),
                              const Bone.text(words: 3),
                              const Gap(defaultPadding),
                              const Bone.text(words: 3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                firstPageErrorIndicatorBuilder: (_) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Could not load your products.'),
                      const Gap(defaultPadding / 2),
                      OutlinedButton.icon(
                        onPressed: _pagingController.refresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
                noItemsFoundIndicatorBuilder: (_) => const Center(
                  child: Text('You have not added any products yet.'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
