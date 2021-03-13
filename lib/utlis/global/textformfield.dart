import 'package:baideshikrojgar/utlis/global/responsive_ui.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;

  CustomTextField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Theme.of(context).primaryColor,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class AppTextInputField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final Function onTextChange;
  double _width;
  double _pixelRatio;
  bool large;
  bool elevation;
  bool medium;
  int maxLine;

  AppTextInputField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.onTextChange,
    this.elevation = true,
    this.maxLine = 1,
  });
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(1.0),
      elevation: !elevation ? 0 : (large ? 12 : (medium ? 10 : 8)),
      child: TextFormField(
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Theme.of(context).primaryColor,
        obscureText: obscureText,
        maxLines: this.maxLine,
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (onTextChange != null) {
            onTextChange(value);
          }
        },
      ),
    );
  }
}
