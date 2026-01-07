import 'package:flutter_test/flutter_test.dart';
import 'package:agrivision_ntb/main.dart';

void main() {
  testWidgets('AgriVision app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AgriVisionApp());

    // Verify that app loads with splash screen
    expect(find.text('AgriVision'), findsOneWidget);
  });
}
