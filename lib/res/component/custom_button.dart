import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final double height, width;
  final Color buttonColor, textColor;
  final bool loading;
  const CustomButton(
      {super.key,
      required this.title,
      required this.onPress,
      this.buttonColor = Colors.white,
      this.textColor = Colors.black,
      this.loading = false,
      this.height = 50,
      this.width = 100});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            fixedSize: Size(width, height),
            elevation: 5),
        onPressed: onPress,
        child: loading
            ? CircularProgressIndicator.adaptive(
                backgroundColor: Colors.black,
              )
            : Text(
                title,
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
