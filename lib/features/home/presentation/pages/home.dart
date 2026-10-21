import 'package:flutter/material.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/features/home/presentation/widgets/categories.dart';
import 'package:mt/features/home/presentation/widgets/new_arrival_products.dart';
import 'package:mt/features/home/presentation/widgets/search_form_fake.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
              child: SearchFormFake(),
            ),
            Categories(),
            NewArrivalProducts(),
          ],
        ),
      ),
    );
  }
}
