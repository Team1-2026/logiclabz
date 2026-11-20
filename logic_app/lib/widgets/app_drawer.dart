import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  final String activeRoute;

  const AppDrawer({super.key, this.activeRoute = '/'});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'LogicLabz',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _drawerItem(context, 'Home', '/', Icons.home_outlined),
                  _drawerItem(context, 'Products & Services', '/services', Icons.layers_outlined),
                  _drawerItem(context, 'Cart & Checkout', '/checkout', Icons.shopping_cart_outlined),
                  _drawerItem(context, 'Client Dashboard', '/dashboard', Icons.dashboard_outlined),
                  const Divider(color: Color(0xFF1E293B), height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Text('ADMINISTRATION', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  _drawerItem(context, 'Admin Console', '/admin', Icons.admin_panel_settings_outlined),
                  _drawerItem(context, 'ERP Integration', '/admin/erp-config', Icons.sync_alt_outlined),
                ],
              ),
            ),

            // User Info Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF1E293B))),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: auth.isAdmin ? Colors.purple : Colors.blue,
                    radius: 18,
                    child: Text(
                      auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : 'U',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.user?.name ?? 'User',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          auth.user?.email ?? '',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, color: Color(0xFF38BDF8), size: 20),
                    tooltip: 'Switch Demo Role',
                    onPressed: () => auth.switchDemoAccount(!auth.isAdmin),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, String route, IconData icon) {
    final isSelected = activeRoute == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF38BDF8) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        Navigator.pop(context); // close drawer
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
