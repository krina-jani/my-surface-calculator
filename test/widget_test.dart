import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surface_area_calculator/main.dart';

void main() {
  testWidgets('Surface Area Calculator UI and Navigation Test', (WidgetTester tester) async {
    await tester.pumpWidget(const SurfaceAreaCalculatorApp());
    await tester.pumpAndSettle();

    // Verify main title on Home Screen
    expect(find.text('SURFACE AREA CALCULATOR'), findsOneWidget);
    expect(find.text('Ball / Sphere'), findsOneWidget);
    expect(find.text('Cone'), findsOneWidget);
    expect(find.text('Cube'), findsOneWidget);

    // Tap on Sphere Calculator
    await tester.tap(find.text('Ball / Sphere'));
    await tester.pumpAndSettle();

    // Verify Sphere detail screen opened
    expect(find.text('Radius (r)'), findsOneWidget);
    expect(find.text('Calculate'), findsOneWidget);

    // Enter radius = 2
    await tester.enterText(find.byType(TextField).first, '2');
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    // Verify result appears (Area = 4 * pi * 4 = 50.2655 m²)
    expect(find.text('Surface Area'), findsOneWidget);
    expect(find.text('50.2655'), findsOneWidget);

    // Tap back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Switch to Reference tab
    await tester.tap(find.text('Reference'));
    await tester.pumpAndSettle();

    expect(find.text('Formula Reference'), findsOneWidget);
    expect(find.text('Surface Area Formula Reference'), findsOneWidget);

    // Switch to About tab
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('Surface Area Calculator'), findsOneWidget);
    expect(find.text('Emperor Smart Solutions'), findsAtLeastNWidgets(1));
    expect(find.text('Privacy Policy'), findsOneWidget);
  });
}
