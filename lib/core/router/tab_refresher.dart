import 'package:flutter/foundation.dart';

class CartTabRefresher extends ChangeNotifier {
  void notifyCartTabSelected() => notifyListeners();
}

final cartTabRefresher = CartTabRefresher();

class HomeTabRefresher extends ChangeNotifier {
  void notifyHomeTabSelected() => notifyListeners();
}

final homeTabRefresher = HomeTabRefresher();

class FavoriteTabRefresher extends ChangeNotifier {
  void notifyFavoriteTabSelected() => notifyListeners();
}

final favoriteTabRefresher = FavoriteTabRefresher();
