import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/catalog_service.dart';

class CatalogProvider extends ChangeNotifier {
  List<ProductCatalogItem> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductCatalogItem> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CatalogProvider() {
    loadCatalog();
  }

  Future<void> loadCatalog() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final items = await CatalogService.getCatalog();
      _products = items;
    } catch (e) {
      _products = CatalogService.getDefaultCatalog();
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ProductCatalogItem? findBySlug(String slug) {
    try {
      return _products.firstWhere((p) => p.slug == slug);
    } catch (_) {
      return null;
    }
  }
}
