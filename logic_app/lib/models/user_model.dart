class UserModel {
  final int id;
  final String name;
  final String email;
  final String? companyName;
  final String? phone;
  final String? gstin;
  final String? billingAddress;
  final String role;
  final String? erpCustomerId;
  final String? apiToken;

  String? get tenantKey => apiToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.companyName,
    this.phone,
    this.gstin,
    this.billingAddress,
    this.role = 'customer',
    this.erpCustomerId,
    this.apiToken,
  });

  bool get isAdmin => role == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      companyName: json['company_name']?.toString(),
      phone: json['phone']?.toString(),
      gstin: json['gstin']?.toString(),
      billingAddress: json['billing_address']?.toString(),
      role: json['role']?.toString() ?? 'customer',
      erpCustomerId: json['erp_customer_id']?.toString(),
      apiToken: json['api_token']?.toString() ?? json['tenant_key']?.toString() ?? json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'company_name': companyName,
      'phone': phone,
      'gstin': gstin,
      'billing_address': billingAddress,
      'role': role,
      'erp_customer_id': erpCustomerId,
      'api_token': apiToken,
      'tenant_key': apiToken,
    };
  }

  static UserModel defaultDemoClient() {
    return UserModel(
      id: 1,
      name: 'Jesvin Client',
      email: 'client@logiclabz.com',
      companyName: 'Logic Enterprise Solutions Ltd',
      phone: '+91 9876543210',
      gstin: '29ABCDE1234F1Z5',
      billingAddress: 'Suite 402, Cyber Tower, Infopark, Kochi, Kerala, India - 682042',
      role: 'customer',
      apiToken: 'LL-TENANT-DEMO-CLIENT-2026',
    );
  }

  static UserModel defaultDemoAdmin() {
    return UserModel(
      id: 2,
      name: 'System Administrator',
      email: 'admin@logiclabz.com',
      companyName: 'LogicLabz Technologies Corp',
      phone: '+91 9876543211',
      gstin: '32AABCL1234F1Z0',
      billingAddress: 'Tower B, Tech Innovation Hub, SmartCity, Kochi - 682050',
      role: 'admin',
      apiToken: 'LL-TENANT-DEMO-ADMIN-2026',
    );
  }
}
