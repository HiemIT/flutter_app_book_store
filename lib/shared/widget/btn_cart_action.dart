import 'package:flutter/material.dart';

class BtnCartAction extends StatelessWidget {
  final title;
  final VoidCallback onPressed;

  BtnCartAction({required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
