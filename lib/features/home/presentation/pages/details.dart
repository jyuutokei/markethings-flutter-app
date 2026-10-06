import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/tab_refresher.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/product_details_entity.dart';
import 'package:mt/features/home/domain/usecases/adjust_cart_item_quantity.dart';
import 'package:mt/features/home/domain/usecases/get_product_details.dart';
import 'package:mt/features/home/presentation/widgets/product_details.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Details extends StatefulWidget {
  final String productId;

  const Details({super.key, required this.productId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<ProductDetailsEntity> _productDetailsFuture;
  int? _selectedVariantIndex;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  // failsafe, to ensure that if the productId changes (random bullshit in the db), reload the product details
  @override
  void didUpdateWidget(covariant Details oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _loadProductDetails();
    }
  }

  void _loadProductDetails() {
    _selectedVariantIndex = null;

    late Future<ProductDetailsEntity> future;
    future = sl<GetProductDetails>().call(int.parse(widget.productId)).then((
      details,
    ) {
      if (mounted && identical(_productDetailsFuture, future)) {
        if (details.variants.length == 1 &&
            details.variants.first.stockQuantity > 0) {
          _selectedVariantIndex = 0;
        }
      }

      return details;
    });

    _productDetailsFuture = future;
  }

  void _onVariantSelected(int? index) {
    setState(() {
      _selectedVariantIndex = index;
    });
  }

  Future<void> _onAddToCart(
    ProductDetailsEntity productDetails,
    int variantIndex,
  ) async {
    setState(() => _isLoading = true);
    try {
      await sl<AdjustCartItemQuantity>().call(
        variantId: productDetails.variants[variantIndex].id,
        quantityValue: 1,
      );

      if (mounted) {
        AppHelpers.showSnackBar(
          context,
          "Added to cart",
          "Item added to cart successfully.",
          ContentType.success,
        );
      }
    } catch (error) {
      if (mounted) {
        AppHelpers.showSnackBar(
          context,
          "Error",
          "Failed to add item to cart.",
          ContentType.failure,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductDetailsEntity>(
      future: _productDetailsFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final productDetails = snapshot.data;
        final hasProductDetails =
            productDetails != null && !snapshot.hasError && !isLoading;
        final isSeller =
            hasProductDetails &&
            sl<SupabaseClient>().auth.currentUser?.id ==
                productDetails.sellerId;
        final canAddToCart = _selectedVariantIndex != null && !isSeller;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
              onPressed: () {
                homeTabRefresher.notifyHomeTabSelected();
              },
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset("assets/icons/Heart.svg", height: 20),
                ),
              ),
              IconButton(
                onPressed: () {
                  cartTabRefresher.notifyCartTabSelected();
                  context.goNamed(AppRoute.cart);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ],
          ),
          body: isLoading
              ? const Center(child: SpinKitSpinningLines(color: Colors.white))
              : snapshot.hasError
              ? Center(child: Text('Error: ${snapshot.error}'))
              : hasProductDetails
              ? ProductDetails(
                  productDetails: productDetails,
                  selectedVariantIndex: _selectedVariantIndex,
                  onVariantSelected: _onVariantSelected,
                )
              : const SizedBox.shrink(),
          bottomNavigationBar: hasProductDetails
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: canAddToCart || _isLoading
                            ? () {
                                _onAddToCart(
                                  productDetails,
                                  _selectedVariantIndex!,
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppHelpers.primaryColor(context),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
