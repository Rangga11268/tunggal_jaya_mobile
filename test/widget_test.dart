import 'package:flutter_test/flutter_test.dart';
import 'package:tunggal_jaya_mobile/main.dart';

void main() {
  testWidgets('App should render', (WidgetTester tester) async {
    await tester.pumpWidget(const TunggalJayaApp());
    expect(find.byType(TunggalJayaApp), findsOneWidget);
  });
}
