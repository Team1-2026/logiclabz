class PerUserCharges {
  final double? tier1To3;
  final double? tier4To10;
  final double? tier11To50;
  final double? tier51Plus;

  PerUserCharges({
    this.tier1To3,
    this.tier4To10,
    this.tier11To50,
    this.tier51Plus,
  });

  factory PerUserCharges.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PerUserCharges();
    return PerUserCharges(
      tier1To3: _toDouble(json['1_3']),
      tier4To10: _toDouble(json['4_10']),
      tier11To50: _toDouble(json['11_50']),
      tier51Plus: _toDouble(json['51_plus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '1_3': tier1To3,
      '4_10': tier4To10,
      '11_50': tier11To50,
      '51_plus': tier51Plus,
    };
  }

  double? chargeForTier(String tierKey) {
    switch (tierKey) {
      case '1_3':
        return tier1To3;
      case '4_10':
        return tier4To10;
      case '11_50':
        return tier11To50;
      case '51_plus':
        return tier51Plus;
      default:
        return null;
    }
  }

  static double? _toDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString());
  }
}

class ModuleItem {
  final String code;
  final String name;
  final String description;
  final double price;
  final double renewalCharge;
  final String licenseType; // 'flat_rate' | 'per_user'
  final PerUserCharges? perUserCharges;
  final bool isMandatory;

  ModuleItem({
    required this.code,
    required this.name,
    required this.description,
    required this.price,
    this.renewalCharge = 0.0,
    this.licenseType = 'flat_rate',
    this.perUserCharges,
    this.isMandatory = false,
  });

  bool get isPerUser => licenseType.toLowerCase() == 'per_user';

  factory ModuleItem.fromJson(Map<String, dynamic> json) {
    return ModuleItem(
      code: json['code']?.toString() ?? json['slug']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _toDouble(json['price'] ?? json['license_price']),
      renewalCharge: _toDouble(json['renewal_charge'] ?? json['renewal_price'] ?? 0.0),
      licenseType: json['license_type']?.toString() ?? 'flat_rate',
      perUserCharges: json['per_user_charges'] != null
          ? PerUserCharges.fromJson(Map<String, dynamic>.from(json['per_user_charges']))
          : (json['per_user_price_1_3'] != null
              ? PerUserCharges(
                  tier1To3: _toDouble(json['per_user_price_1_3']),
                  tier4To10: _toDouble(json['per_user_price_4_10']),
                  tier11To50: _toDouble(json['per_user_price_11_50']),
                  tier51Plus: _toDouble(json['per_user_price_51_plus']),
                )
              : null),
      isMandatory: json['is_mandatory'] == true || json['is_mandatory'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'price': price,
      'renewal_charge': renewalCharge,
      'license_type': licenseType,
      'per_user_charges': perUserCharges?.toJson(),
      'is_mandatory': isMandatory,
    };
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}

class ProductCatalogItem {
  final int id;
  final String slug;
  final String title;
  final String category;
  final String type; // 'modular' | 'standalone' | 'infrastructure'
  final String? icon;
  final String description;
  final double basePrice;
  final double setupCharge; // First-time one-off setup fee
  final String currency;
  final String billingCycle;
  final List<String> features;
  final List<ModuleItem> modulesSchema;

  ProductCatalogItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.category,
    this.type = 'modular',
    this.icon,
    required this.description,
    required this.basePrice,
    this.setupCharge = 0.0,
    this.currency = 'INR',
    this.billingCycle = 'annual',
    this.features = const [],
    this.modulesSchema = const [],
  });

  bool get isModular => type == 'modular';

  factory ProductCatalogItem.fromJson(Map<String, dynamic> json) {
    var rawFeatures = json['features'];
    List<String> parsedFeatures = [];
    if (rawFeatures is List) {
      parsedFeatures = rawFeatures.map((e) => e.toString()).toList();
    } else if (rawFeatures is String && rawFeatures.isNotEmpty) {
      parsedFeatures = rawFeatures.split(',').map((e) => e.trim()).toList();
    }

    var rawModules = json['modules_schema'] ?? json['modules'];
    List<ModuleItem> parsedModules = [];
    if (rawModules is List) {
      parsedModules = rawModules
          .whereType<Map>()
          .map((m) => ModuleItem.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    }

    return ProductCatalogItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Software',
      type: json['type']?.toString() ?? 'modular',
      icon: json['icon']?.toString(),
      description: json['description']?.toString() ?? '',
      basePrice: ModuleItem._toDouble(json['base_price'] ?? json['price']),
      setupCharge: ModuleItem._toDouble(json['setup_charge'] ?? json['setup_cost'] ?? 0.0),
      currency: json['currency']?.toString() ?? 'INR',
      billingCycle: json['billing_cycle']?.toString() ?? 'annual',
      features: parsedFeatures,
      modulesSchema: parsedModules,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'category': category,
      'type': type,
      'icon': icon,
      'description': description,
      'base_price': basePrice,
      'setup_charge': setupCharge,
      'currency': currency,
      'billing_cycle': billingCycle,
      'features': features,
      'modules_schema': modulesSchema.map((m) => m.toJson()).toList(),
    };
  }
}
