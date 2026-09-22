import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';


void main() {

  testWidgets(
    'Agriculture App Test',
    (WidgetTester tester) async {


      await tester.pumpWidget(
        const AgricultureApp(),
      );


    },
  );

}