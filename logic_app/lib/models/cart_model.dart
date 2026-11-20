import 'product_model.dart';

class SelectedProduct {
  final int productId;
  final String slug;
  final String title;
  final double basePrice;
  final double setupCharge;
  final String type;
  final List<String> selectedModules;
  final String userTier; // '1_3' | '4_10' | '11_50' | '51_plus'
  final Map<String, double> modulePrices;
  final Map<String, double> moduleRenewals;
  final Map<String, String> moduleLicenseTypes;
  final Map<String, PerUserCharges> modulePerUserCharges;

  SelectedProduct({
    required this.productId,
    required this.slug,
    required this.title,
    required this.basePrice,
    this.setupCharge = 0.0,
    required this.type,
    required this.selectedModules,
    this.userTier = '1_3',
    this.modulePrices = const {},
    this.moduleRenewals = const {},
    this.moduleLicenseTypes = const {},
    this.modulePerUserCharges = const {},
  });

  SelectedProduct copyWith({
    List<String>? selectedModules,
    String? userTier,
  }) {
    return SelectedProduct(
      productId: productId,
      slug: slug,
      title: title,
      basePrice: basePrice,
      setupCharge: setupCharge,
      type: type,
      selectedModules: selectedModules ?? this.selectedModules,
      userTier: userTier ?? this.userTier,
      modulePrices: modulePrices,
      moduleRenewals: moduleRenewals,
      moduleLicenseTypes: moduleLicenseTypes,
      modulePerUserCharges: modulePerUserCharges,
    );
  }

  double calculateModulesTotal() {
    double total = 0.0;
    for (final code in selectedModules) {
      final isPerUser = moduleLicenseTypes[code] == 'per_user';
      if (isPerUser) {
        final charges = modulePerUserCharges[code];
        final tierCost = charges?.chargeForTier(userTier);
        if (tierCost != null && tierCost > 0) {
          total += tierCost;
        } else {
          total += modulePrices[code] ?? 0.0;
        }
      } else {
        total += modulePrices[code] ?? 0.0;
      }
    }
    return total;
  }

  double calculateModulesRenewalTotal() {
    double total = 0.0;
    for (final code in selectedModules) {
      total += moduleRenewals[code] ?? 0.0;
    }
    return total;
  }
}

class PricingSummary {
  final double baseTotal;
  final double setupTotal;
  final double modulesTotal;
  final double modulesRenewalTotal;
  final double addonsTotal;
  final double subtotal;
  final double cgst;
  final double sgst;
  final double tax;
  final double grandTotal;
  final double estimatedAnnualRenewal;

  PricingSummary({
    required this.baseTotal,
    required this.setupTotal,
    required this.modulesTotal,
    required this.modulesRenewalTotal,
    required this.addonsTotal,
    required this.subtotal,
    required this.cgst,
    required this.sgst,
    required this.tax,
    required this.grandTotal,
    required this.estimatedAnnualRenewal,
  });

  factory PricingSummary.empty() {
    return PricingSummary(
      baseTotal: 0,
      setupTotal: 0,
      modulesTotal: 0,
      modulesRenewalTotal: 0,
      addonsTotal: 0,
      subtotal: 0,
      cgst: 0,
      sgst: 0,
      tax: 0,
      grandTotal: 0,
      estimatedAnnualRenewal: 0,
    );
  }
}
