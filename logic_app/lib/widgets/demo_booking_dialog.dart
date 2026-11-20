import 'package:flutter/material.dart';

class DemoBookingDialog extends StatefulWidget {
  final String productName;

  const DemoBookingDialog({super.key, this.productName = 'Enterprise ERP'});

  static void show(BuildContext context, {String productName = 'Enterprise ERP'}) {
    showDialog(
      context: context,
      builder: (ctx) => DemoBookingDialog(productName: productName),
    );
  }

  @override
  State<DemoBookingDialog> createState() => _DemoBookingDialogState();
}

class _DemoBookingDialogState extends State<DemoBookingDialog> {
  final _nameCtrl = TextEditingController(text: 'Jesvin Mathew');
  final _emailCtrl = TextEditingController(text: 'client@logiclabz.com');
  final _companyCtrl = TextEditingController(text: 'Logic Enterprise Solutions');
  final _phoneCtrl = TextEditingController(text: '+91 9876543210');
  String _preferredSlot = 'Tomorrow, 11:00 AM IST';
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _submitted
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 48),
                    const SizedBox(height: 16),
                    const Text('Demo Request Confirmed!', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Our solution architect will connect with you on $_preferredSlot to walk you through ${widget.productName}.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Book 1-on-1 Demo: ${widget.productName}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const Divider(color: Color(0xFF334155), height: 20),
                    _field('Full Name', _nameCtrl),
                    _field('Work Email', _emailCtrl),
                    _field('Company Name', _companyCtrl),
                    _field('Phone Number', _phoneCtrl),
                    const SizedBox(height: 10),
                    const Text('Preferred Time Slot', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1E293B),
                          value: _preferredSlot,
                          items: const [
                            DropdownMenuItem(value: 'Tomorrow, 11:00 AM IST', child: Text('Tomorrow, 11:00 AM IST', style: TextStyle(color: Colors.white, fontSize: 13))),
                            DropdownMenuItem(value: 'Tomorrow, 3:00 PM IST', child: Text('Tomorrow, 3:00 PM IST', style: TextStyle(color: Colors.white, fontSize: 13))),
                            DropdownMenuItem(value: 'Day after tomorrow, 10:30 AM IST', child: Text('Day after tomorrow, 10:30 AM IST', style: TextStyle(color: Colors.white, fontSize: 13))),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _preferredSlot = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => setState(() => _submitted = true),
                        child: const Text('Schedule Product Demo'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1E293B),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF334155))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF38BDF8))),
            ),
          ),
        ],
      ),
    );
  }
}
