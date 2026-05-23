import 'package:flutter_test/flutter_test.dart';

import 'package:mvvm_elementary/app.dart';

void main() {
  testWidgets('App builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('My Tasks'), findsOneWidget);
  });
}
