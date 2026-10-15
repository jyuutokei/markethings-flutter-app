import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/category_entity.dart';
import 'package:mt/features/home/domain/entities/product_card_entity.dart';
import 'package:mt/features/home/domain/usecases/get_categories.dart';
import 'package:mt/features/home/domain/usecases/get_product_card_page.dart';
import 'package:mt/features/home/presentation/widgets/product_card.dart';
import 'package:mt/features/home/presentation/widgets/search_form_fake.dart';
import 'package:mt/injection_container.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late List<CategoryEntity> _categories;
  bool _isLoading = true;
  int? selectedCategoryIndex;
  int? categoryId;
  static const _pageSize = 6;
  late final _pagingController = PagingController<int, ProductCardEntity>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) => sl<GetProductCardPage>().call(
      limit: _pageSize,
      offset: (pageKey - 1) * _pageSize,
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await sl<GetCategories>().call();

      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (error) {
      AppHelpers.logger().error(error);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _modalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      enableDrag: false,
      isScrollControlled: true,

      builder: (sheetContext) => StatefulBuilder(
        builder: (BuildContext context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter', style: Theme.of(context).textTheme.titleLarge),
                const Gap(defaultPadding),
                _isLoading
                    ? const Center(child: SpinKitHourGlass(color: Colors.white))
                    : Expanded(
                        child: Wrap(
                          spacing: defaultPadding / 2,
                          runSpacing: defaultPadding / 2,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                            _categories.length,
                            (index) => ChoiceChip(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2,
                                vertical: defaultPadding / 4,
                              ),
                              shape: const StadiumBorder(),
                              avatar: SizedBox(
                                width: 20,
                                height: 20,
                                child: SvgPicture.network(
                                  _categories[index].imageUrl,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  placeholderBuilder: (context) => const Center(
                                    child: SpinKitDoubleBounce(
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image_outlined,
                                        size: 20,
                                      ),
                                ),
                              ),
                              label: Text(_categories[index].name),
                              labelStyle: TextStyle(
                                color: selectedCategoryIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              selected: selectedCategoryIndex == index,
                              onSelected: (selected) {
                                setSheetState(() {
                                  selectedCategoryIndex = selected
                                      ? index
                                      : null;
                                  categoryId = selected
                                      ? _categories[index].id
                                      : null;
                                });
                              },
                              selectedColor: AppHelpers.primaryColor(context),
                              showCheckmark: false,
                            ),
                          ),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppHelpers.errorColor(context)),
                      ),
                      child: Text(
                        "Close",
                        style: TextStyle(color: AppHelpers.errorColor(context)),
                      ),
                    ),
                    const Gap(defaultPadding / 2),
                    FilledButton(onPressed: () {}, child: const Text("Search")),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const SearchFormFake(),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Filter"),
              const Gap(defaultPadding / 2),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: defaultPadding / 2,
                ),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _modalBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppHelpers.primaryColor(context),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Filter.svg",
                      width: 30,
                      height: 30,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: PagingListener(
                controller: _pagingController,
                builder: (context, state, fetchNextPage) {
                  return PagedGridView<int, ProductCardEntity>(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    padding: const EdgeInsets.all(defaultPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.sizeOf(context).width > 600
                          ? 3
                          : 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    builderDelegate:
                        PagedChildBuilderDelegate<ProductCardEntity>(
                          itemBuilder: (context, product, index) => ProductCard(
                            title: product.title,
                            image: product.mainImageUrl,
                            price: product.price,
                            press: () {
                              context.pushNamed(
                                AppRoute.productDetails,
                                pathParameters: {
                                  'productId': product.id.toString(),
                                },
                              );
                            },
                          ),
                        ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
