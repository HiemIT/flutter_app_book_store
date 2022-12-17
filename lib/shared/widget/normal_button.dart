import 'package:flutter/material.dart';
import 'package:flutter_app_book_store/shared/style/btn_style.dart';

class NormalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const NormalButton({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          disabledBackgroundColor: Colors.yellow[500],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(
          title,
          style: BtnStyle.normal(),
        ),
      ),
    );
  }
}

// note
/*
* ProxyProvider là một widget Provider, nó sẽ cung cấp một giá trị mới cho các widget con của nó.
* Nó sẽ được gọi mỗi khi một giá trị nào đó thay đổi.
*
* */
