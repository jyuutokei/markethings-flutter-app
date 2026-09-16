import 'package:flutter/material.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/features/home/presentation/widgets/categories.dart';
import 'package:mt/features/home/presentation/widgets/header_appbar.dart';
import 'package:mt/features/home/presentation/widgets/new_arrival_products.dart';
import 'package:mt/features/home/presentation/widgets/popular_products.dart';
import 'package:mt/features/home/presentation/widgets/search_form_fake.dart';
import 'package:mt/features/home/presentation/widgets/sidebar.dart';
import 'package:sidebarx/sidebarx.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: HeaderAppbar(
        scaffoldKey: _scaffoldKey,
        title: "Everything is a placeholder",
      ),
      body: const SingleChildScrollView(
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
            PopularProducts(),
          ],
        ),
      ),
    );
  }
}
