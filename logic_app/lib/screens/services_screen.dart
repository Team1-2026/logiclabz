import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/app_navbar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/demo_booking_dialog.dart';
import '../providers/catalog_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final cart = context.watch<CartProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 860;
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    final categories = [
      'All',
      ...catalog.products.map((p) => p.category).toSet(),
    ];
    final filteredProducts = _selectedCategory == 'All'
        ? catalog.products
        : catalog.products
              .where((p) => p.category == _selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: const AppNavbar(activeRoute: '/services'),
      drawer: isDesktop ? null : const AppDrawer(activeRoute: '/services'),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1160),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : 16,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ENTERPRISE CATALOG',
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Software & Cloud Services',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Configure software modules, setup charges, user licensing tiers, and view real-time estimates.',
                            style: TextStyle(
                              color: const Color(0xFF94A3B8),
                              fontSize: isDesktop ? 14 : 12,
                            ),
                          ),
                        ],
                      ),
                      if (cart.itemCount > 0)
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                          ),
                          label: Text(
                            'Checkout (${cart.itemCount}) • ${currencyFormatter.format(cart.pricing.grandTotal)}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/checkout'),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Category Filter Pills
                  Wrap(
                    spacing: 8,
                    children: categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: const Color(0xFF2563EB),
                        backgroundColor: const Color(0xFF1E293B),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF94A3B8),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 12,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF334155),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedCategory = cat);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  // Products List
                  if (catalog.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (filteredProducts.isEmpty)
                    const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...filteredProducts.map(
                      (product) => _productCard(
                        context,
                        product,
                        cart,
                        currencyFormatter,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCard(
    BuildContext context,
    ProductCatalogItem product,
    CartProvider cart,
    NumberFormat currencyFormatter,
  ) {
    final isSelected = cart.isProductSelected(product.slug);
    final selectedProduct = cart.selectedProducts[product.slug];
    final hasModules = product.modulesSchema.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      decoration: BoxDecoration(
        color: const Color(0xFF131C31),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF1E293B),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header details
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.layers,
                    color: Color(0xFF38BDF8),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product.category,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pricing summary on top right
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormatter.format(product.basePrice),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'per ${product.billingCycle}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                    if (product.setupCharge > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+ ${currencyFormatter.format(product.setupCharge)} setup cost',
                          style: const TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Features Pills
          if (product.features.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.features.map((f) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check,
                          color: Color(0xFF10B981),
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          f,
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 16),

          // Dynamic Modules Section (if modular)
          if (hasModules) ...[
            const Divider(color: Color(0xFF1E293B), height: 1),
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF0F172A).withValues(alpha: 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.tune,
                            color: Color(0xFF38BDF8),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Customize Application Modules & Pricing',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${product.modulesSchema.length} modules available',
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => cart.selectAllModules(product),
                            child: const Text(
                              'Select All',
                              style: TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Text(
                            '|',
                            style: TextStyle(color: Color(0xFF334155)),
                          ),
                          TextButton(
                            onPressed: () =>
                                cart.deselectAllModules(product.slug),
                            child: const Text(
                              'Deselect All',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // User Tier Selector (if any module is per-user)
                  if (product.modulesSchema.any((m) => m.isPerUser)) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.people_alt_outlined,
                            color: Color(0xFFF59E0B),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'User Licensing Tier:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              children: [
                                _tierChip(
                                  '1-3 Users',
                                  '1_3',
                                  selectedProduct?.userTier ?? '1_3',
                                  (k) => cart.setUserTier(product.slug, k),
                                ),
                                _tierChip(
                                  '4-10 Users',
                                  '4_10',
                                  selectedProduct?.userTier ?? '1_3',
                                  (k) => cart.setUserTier(product.slug, k),
                                ),
                                _tierChip(
                                  '11-50 Users',
                                  '11_50',
                                  selectedProduct?.userTier ?? '1_3',
                                  (k) => cart.setUserTier(product.slug, k),
                                ),
                                _tierChip(
                                  '51+ Users',
                                  '51_plus',
                                  selectedProduct?.userTier ?? '1_3',
                                  (k) => cart.setUserTier(product.slug, k),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Modules Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          mainAxisExtent: 110,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: product.modulesSchema.length,
                    itemBuilder: (context, idx) {
                      final module = product.modulesSchema[idx];
                      final isModChecked = cart.isModuleSelected(
                        product.slug,
                        module.code,
                      );

                      double activePrice = module.price;
                      if (module.isPerUser && module.perUserCharges != null) {
                        final tier = selectedProduct?.userTier ?? '1_3';
                        final cost = module.perUserCharges!.chargeForTier(tier);
                        if (cost != null && cost > 0) activePrice = cost;
                      }

                      return InkWell(
                        onTap: () => cart.toggleModule(product, module.code),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isModChecked
                                ? const Color(0xFF1E3A8A).withValues(alpha: 0.4)
                                : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isModChecked
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF334155),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isModChecked
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: isModChecked
                                        ? const Color(0xFF38BDF8)
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      module.name,
                                      style: TextStyle(
                                        color: isModChecked
                                            ? Colors.white
                                            : const Color(0xFFCBD5E1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                module.description,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currencyFormatter.format(activePrice),
                                    style: TextStyle(
                                      color: isModChecked
                                          ? const Color(0xFF38BDF8)
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (module.renewalCharge > 0)
                                    Text(
                                      'Renews: ${currencyFormatter.format(module.renewalCharge)}/yr',
                                      style: const TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 9,
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: module.isPerUser
                                          ? Colors.orange.withValues(alpha: 0.2)
                                          : Colors.blue.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      module.isPerUser
                                          ? 'Per User'
                                          : 'Flat Rate',
                                      style: TextStyle(
                                        color: module.isPerUser
                                            ? Colors.orangeAccent
                                            : Colors.lightBlueAccent,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],

          // Footer / Cart action bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.help_outline, size: 16),
                      label: const Text('Book Demo'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF475569)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => DemoBookingDialog.show(
                        context,
                        productName: product.title,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (isSelected && selectedProduct != null)
                      Text(
                        '${selectedProduct.selectedModules.length} Modules Selected • Modules Total: ${currencyFormatter.format(selectedProduct.calculateModulesTotal())}',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(
                        isSelected ? Icons.check : Icons.add_shopping_cart,
                        size: 16,
                      ),
                      label: Text(
                        isSelected ? 'Selected in Cart' : 'Add to Cart',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? const Color(0xFF10B981)
                            : const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => cart.toggleProduct(product),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (!isSelected) cart.toggleProduct(product);
                        Navigator.pushNamed(context, '/checkout');
                      },
                      child: const Text('Buy Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tierChip(
    String label,
    String key,
    String selectedKey,
    Function(String) onSelect,
  ) {
    final isSelected = key == selectedKey;
    return InkWell(
      onTap: () => onSelect(key),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF60A5FA)
                : const Color(0xFF334155),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
