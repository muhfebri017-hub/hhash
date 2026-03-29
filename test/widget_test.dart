import 'package:flutter_test/flutter_test.dart';
import 'package:raha_reels/main.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const RahaReelsApp());
    expect(find.text('RAHA REELS'), findsOneWidget);
  });
}
