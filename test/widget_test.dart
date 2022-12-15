import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/shared/app_color.dart';
import 'package:flutter_app_book_store/shared/widget/normal_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Testing phone',
    (WidgetTester tester) async {
      Widget parent = MaterialApp(
        theme: ThemeData(
          primarySwatch: AppColor.yellow,
        ),
        home: Scaffold(
          body: NormalButton(
            onPressed: () {},
            title: 'Sign In',
          ),
        ),
      );

      await tester.pumpWidget(parent);

      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Click'), findsNothing);
    },
  );
}
