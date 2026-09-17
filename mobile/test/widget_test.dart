import 'package:flutter_test/flutter_test.dart';
import 'package:fasalrakshak/main.dart';

void main() {
  testWidgets('FasalRakshak app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FasalRakshakApp());
    expect(find.byType(FasalRakshakApp), findsOneWidget);
  });
}
