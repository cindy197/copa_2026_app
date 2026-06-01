import 'package:flutter_test/flutter_test.dart';

import 'package:copa_2026_app/app.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const CopaApp());
    expect(find.byType(CopaApp), findsOneWidget);
  });
}
