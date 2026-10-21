import 'package:flutter/foundation.dart';
import 'package:mt/features/home/domain/usecases/get_favorite_product_ids.dart';
import 'package:mt/features/home/domain/usecases/toggle_favorite.dart';

class FavoritesStore extends ChangeNotifier {
  final GetFavoriteProductIds _getIds;
  final ToggleFavorite _toggle;

  FavoritesStore(this._getIds, this._toggle);

  final ValueNotifier<Set<int>> ids = ValueNotifier(<int>{});
  final Set<int> _busy = {}; // ignore double-taps while a request is in flight

  String? _userId;

  Future<void> syncWithUser(String? userId) async {
    if (userId == _userId) return;
    _userId = userId;

    if (userId == null) {
      ids.value = <int>{};
      return;
    }

    try {
      final fetched = await _getIds();
      if (_userId == userId) {
        ids.value = fetched;
      }
    } catch (_) {
      _userId = null;
    }
  }

  // special use case
  void clear() {
    _userId = null;
    ids.value = <int>{};
  }

  void _set(int productId, bool favorite) {
    final next = {...ids.value};
    if (favorite) {
      next.add(productId);
    } else {
      next.remove(productId);
    }
    ids.value = next;
  }

  Future<bool> toggle(int productId) async {
    if (!_busy.add(productId)) return true;
    final wasFavorite = ids.value.contains(productId);
    _set(productId, !wasFavorite); // optimisic update

    try {
      await _toggle.call(productId, isCurrentlyFavorite: wasFavorite);
      notifyListeners();
      return true;
    } catch (_) {
      _set(productId, wasFavorite); // rollback
      return false;
    } finally {
      _busy.remove(productId);
    }
  }
}
