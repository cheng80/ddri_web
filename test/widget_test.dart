import 'package:flutter_test/flutter_test.dart';

import 'package:ddri_web/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('대여소 조회'), findsOneWidget);
  });
}
