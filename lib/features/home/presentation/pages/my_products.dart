import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/features/home/presentation/widgets/my_product_card.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
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
              if (action == 'draft') return;
              if (action == 'add') {
                context.pushNamed(AppRoute.createProduct);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'draft',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.edit_note),
                  title: Text('Your drafts'),
                ),
              ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = MyProductCard.productGridColumns(
            constraints.maxWidth,
          );
          const spacing = 16.0;

          final tileWidth =
              (constraints.maxWidth -
                  defaultPadding * 2 -
                  spacing * (columns - 1)) /
              columns;

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(defaultPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: MyProductCard.estimatedHeightForWidth(tileWidth),
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: 1,
            itemBuilder: (context, index) {
              return MyProductCard(
                title: "Product title",
                price: 100,
                productId: 1,
                sellerId: '1',
                press: () {},
              );
            },
          );
        },
      ),
    );
  }
}
