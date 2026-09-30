import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mt/features/home/domain/entities/product_details_entity.dart';
import 'package:mt/features/home/domain/usecases/get_product_details.dart';
import 'package:mt/features/home/presentation/widgets/product_details.dart';
import 'package:mt/injection_container.dart';

class Details extends StatelessWidget {
  final String productId;

  const Details({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: SvgPicture.asset("assets/icons/Heart.svg", height: 20),
            ),
          ),
        ],
      ),
      body: FutureBuilder<ProductDetailsEntity>(
        future: sl<GetProductDetails>().call(int.parse(productId)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitSpinningLines(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final productDetails = snapshot.data!;

          return ProductDetails(productDetails: productDetails);
        },
      ),
    );
  }
}
