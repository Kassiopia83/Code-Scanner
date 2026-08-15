import 'package:flutter_test/flutter_test.dart';

import 'package:code_scanner/main.dart';

void main() {
  testWidgets('App startet und zeigt den Scan-Screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Barcode scannen'), findsOneWidget);
  });
}
