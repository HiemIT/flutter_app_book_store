import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/shared/style/btn_style.dart';

import '../app_color.dart';

class NormalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  NormalButton({required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 45,
      child: ElevatedButton(
        // disable button or enable button
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.yellow),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: BtnStyle.normal(),
        ),
      ),
    );
  }
}
