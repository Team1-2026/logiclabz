import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, SelectedProduct> _selectedProducts = {};
  bool _domainAddonSelected = false;
  String _domainName = 'mycompany.com';
  double _domainPrice = 999.0;

  bool _hostingAddonSelected = false;
  String _hostingPlan = 'Standard NVMe Cloud Server';
  double _hostingPrice = 8000.0;

  Map<String, SelectedProduct> get selectedProducts => _selectedProducts;
  bool get domainAddonSelected => _domainAddonSelected;
  String get domainName => _domainName;
  double get domainPrice => _domainPrice;
  bool get hostingAddonSelected => _hostingAddonSelected;
  String get hostingPlan => _hostingPlan;
  double get hostingPrice => _hostingPrice;

  int get itemCount => _selectedProducts.length;

  bool isProductSelected(String slug) => _selectedProducts.containsKey(slug);

  bool isModuleSelected(String slug, String moduleCode) {
    return _selectedProducts[slug]?.selectedModules.contains(moduleCode) ?? false;
  }

  void toggleProduct(ProductCatalogItem product) {
    if (_selectedProducts.containsKey(product.slug)) {
      _selectedProducts.remove(product.slug);
    } else {
      Map<String, double> prices = {};
      Map<String, double> renewals = {};
      Map<String, String> types = {};
      Map<String, PerUserCharges> perUser = {};

      for (var m in product.modulesSchema) {
        prices[m.code] = m.price;
        renewals[m.code] = m.renewalCharge;
        types[m.code] = m.licenseType;
        if (m.perUserCharges != null) {
          perUser[m.code] = m.perUserCharges!;
        }
      }

      // Pre-select mandatory modules or primary modules
      List<String> defaultModules = [];
      for (var m in product.modulesSchema) {
        if (m.isMandatory || ['ACCOUNTING', 'ATTENDANCE'].contains(m.code)) {
          defaultModules.add(m.code);
        }
      }

      _selectedProducts[product.slug] = SelectedProduct(
        productId: product.id,
        slug: product.slug,
        title: product.title,
        basePrice: product.basePrice,
        setupCharge: product.setupCharge,
        type: product.type,
        selectedModules: defaultModules,
        modulePrices: prices,
        moduleRenewals: renewals,
        moduleLicenseTypes: types,
        modulePerUserCharges: perUser,
      );
    }
    notifyListeners();
  }

  void toggleModule(ProductCatalogItem product, String moduleCode) {
    if (!_selectedProducts.containsKey(product.slug)) {
      toggleProduct(product);
    }

    final current = _selectedProducts[product.slug]!;
    final List<String> updated = List.from(current.selectedModules);

    if (updated.contains(moduleCode)) {
      updated.remove(moduleCode);
    } else {
      updated.add(moduleCode);
    }

    _selectedProducts[product.slug] = current.copyWith(selectedModules: updated);
    notifyListeners();
  }

  void setUserTier(String slug, String tierKey) {
    final current = _selectedProducts[slug];
    if (current != null) {
      _selectedProducts[slug] = current.copyWith(userTier: tierKey);
      notifyListeners();
    }
  }

  void selectAllModules(ProductCatalogItem product) {
    if (!_selectedProducts.containsKey(product.slug)) {
      toggleProduct(product);
    }
    final current = _selectedProducts[product.slug]!;
    final allCodes = product.modulesSchema.map((m) => m.code).toList();
    _selectedProducts[product.slug] = current.copyWith(selectedModules: allCodes);
    notifyListeners();
  }

  void deselectAllModules(String slug) {
    final current = _selectedProducts[slug];
    if (current != null) {
      _selectedProducts[slug] = current.copyWith(selectedModules: []);
      notifyListeners();
    }
  }

  void setDomainAddon(bool selected, {String? name, double? price}) {
    _domainAddonSelected = selected;
    if (name != null) _domainName = name;
    if (price != null) _domainPrice = price;
    notifyListeners();
  }

  void setHostingAddon(bool selected, {String? plan, double? price}) {
    _hostingAddonSelected = selected;
    if (plan != null) _hostingPlan = plan;
    if (price != null) _hostingPrice = price;
    notifyListeners();
  }

  void clearCart() {
    _selectedProducts.clear();
    _domainAddonSelected = false;
    _hostingAddonSelected = false;
    notifyListeners();
  }

  PricingSummary get pricing {
    double baseTotal = 0.0;
    double setupTotal = 0.0;
    double modulesTotal = 0.0;
    double modulesRenewalTotal = 0.0;

    for (final p in _selectedProducts.values) {
      baseTotal += p.basePrice;
      setupTotal += p.setupCharge;
      modulesTotal += p.calculateModulesTotal();
      modulesRenewalTotal += p.calculateModulesRenewalTotal();
    }

    double addonsTotal = 0.0;
    if (_domainAddonSelected) addonsTotal += _domainPrice;
    if (_hostingAddonSelected) addonsTotal += _hostingPrice;

    final subtotal = baseTotal + setupTotal + modulesTotal + addonsTotal;
    final cgst = subtotal * 0.09;
    final sgst = subtotal * 0.09;
    final tax = cgst + sgst; // 18% GST
    final grandTotal = subtotal + tax;

    final estimatedAnnualRenewal = baseTotal + modulesRenewalTotal + (_hostingAddonSelected ? _hostingPrice : 0.0) + (_domainAddonSelected ? _domainPrice : 0.0);

    return PricingSummary(
      baseTotal: baseTotal,
      setupTotal: setupTotal,
      modulesTotal: modulesTotal,
      modulesRenewalTotal: modulesRenewalTotal,
      addonsTotal: addonsTotal,
      subtotal: subtotal,
      cgst: cgst,
      sgst: sgst,
      tax: tax,
      grandTotal: grandTotal,
      estimatedAnnualRenewal: estimatedAnnualRenewal,
    );
  }
}
