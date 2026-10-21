import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/tab_refresher.dart';
import 'package:mt/features/home/presentation/widgets/appbar_main.dart';
import 'package:mt/features/home/presentation/widgets/sidebar.dart';
import 'package:sidebarx/sidebarx.dart';

class BottomNav extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNav({required this.navigationShell, super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool _isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sbxController = SidebarXController(selectedIndex: 0, extended: true);

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _onItemTapped(int index) {
    final currentIndex = widget.navigationShell.currentIndex;
    if (currentIndex == index) return;

    widget.navigationShell.goBranch(index);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.navigationShell.currentIndex != index) return;

      switch (index) {
        case 0:
          homeTabRefresher.notifyHomeTabSelected();
        case 1:
          cartTabRefresher.notifyCartTabSelected();
        case 2:
          favoriteTabRefresher.notifyFavoriteTabSelected();
        case 3:
          profileTabRefresher.notifyProfileTabSelected();
      }
    });
  }

  String _titleFor(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Shopping cart';
      case 2:
        return 'Favorites';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: SpinKitPouringHourGlassRefined(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarNav(controller: _sbxController),
      appBar: AppBarMain(
        scaffoldKey: _scaffoldKey,
        title: _titleFor(widget.navigationShell.currentIndex),
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person_2),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
