import 'package:flutter_test/flutter_test.dart';
import 'package:math_tool/app.dart';

void main() {
  testWidgets('Приложение запускается', (WidgetTester tester) async {
    await tester.pumpWidget(const MathToolApp());
    expect(find.text('Math Tool'), findsOneWidget);
  });
}
