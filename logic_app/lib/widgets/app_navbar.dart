import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String activeRoute;

  const AppNavbar({super.key, this.activeRoute = '/'});

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 860;

    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      titleSpacing: 20,
      title: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, '/'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                children: [
                  TextSpan(text: 'Logic', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'Labz', style: TextStyle(color: Color(0xFF38BDF8))),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (isDesktop) ...[
          _navItem(context, 'Home', '/', Icons.home_outlined),
          _navItem(context, 'Services', '/services', Icons.layers_outlined),
          _navItem(context, 'Dashboard', '/dashboard', Icons.dashboard_outlined),
          _navItem(context, 'Admin', '/admin', Icons.admin_panel_settings_outlined),
          _navItem(context, 'ERP Config', '/admin/erp-config', Icons.sync_alt_outlined),
          const SizedBox(width: 8),
        ],

        // Cart Icon with badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              tooltip: 'Cart & Checkout',
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
            ),
            if (cart.itemCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 8),

        // User Account Dropdown
        PopupMenuButton<String>(
          color: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF334155)),
          ),
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: auth.isAdmin ? const Color(0xFF7C3AED) : const Color(0xFF2563EB),
            child: Text(
              auth.isAuthenticated ? (auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : 'U') : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          itemBuilder: (context) {
            if (auth.isAuthenticated) {
              return [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(auth.user?.name ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(auth.user?.email ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: auth.isAdmin ? Colors.purple.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          auth.isAdmin ? 'ADMINISTRATOR' : 'CLIENT PORTAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: auth.isAdmin ? Colors.purpleAccent : Colors.lightBlueAccent,
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFF334155)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'switch_role',
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz, size: 18, color: Colors.indigoAccent),
                      const SizedBox(width: 10),
                      Text(
                        auth.isAdmin ? 'Switch to Demo Client' : 'Switch to Demo Admin',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 18, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text('Logout', style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                ),
              ];
            } else {
              return const [
                PopupMenuItem(
                  value: 'login',
                  child: Row(
                    children: [
                      Icon(Icons.login, size: 18, color: Colors.blueAccent),
                      SizedBox(width: 10),
                      Text('Sign In', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ];
            }
          },
          onSelected: (value) {
            if (value == 'logout') {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            } else if (value == 'switch_role') {
              auth.switchDemoAccount(!auth.isAdmin);
            } else if (value == 'login') {
              Navigator.pushNamed(context, '/login');
            }
          },
        ),

        const SizedBox(width: 16),
      ],
    );
  }

  Widget _navItem(BuildContext context, String title, String route, IconData icon) {
    final isSelected = activeRoute == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        icon: Icon(icon, size: 16, color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFF94A3B8)),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF38BDF8) : const Color(0xFFCBD5E1),
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (!isSelected) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }
}
