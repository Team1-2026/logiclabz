import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const LogicLabzApp());
    await tester.pumpAndSettle();

    expect(find.text('LogicLabz Technologies'), findsWidgets);
    expect(find.text('Configure ERP & Modules'), findsOneWidget);
  });
}
