import 'package:baideshikrojgar/utlis/global/responsive_ui.dart';
import 'package:baideshikrojgar/utlis/global/textView.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final String label;
  final double radius;
  final double elevation;
  Function onTextChange = (String text) {};
  Function onSubmit = (String text) {};
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;
  int maxLines;

  CustomTextField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.label = '',
    this.radius = 30,
    this.elevation = 0,
    this.onTextChange,
    this.onSubmit,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this.label.length > 0
            ? SizedBox(
                child: TextFormatted(
                  text: this.label,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                height: 25,
              )
            : SizedBox(
                height: 1,
              ),
        Material(
          borderRadius: BorderRadius.circular(this.radius),
          elevation: this.elevation > 0
              ? this.elevation
              : (large ? 12 : (medium ? 10 : 8)),
          child: TextFormField(
            controller: textEditingController,
            keyboardType: keyboardType,
            cursorColor: Theme.of(context).primaryColor,
            obscureText: obscureText,
            maxLines: this.maxLines,
            decoration: InputDecoration(
              prefixIcon:
                  Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(this.radius),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (String text) {
              this.onTextChange(text);
            },
            onFieldSubmitted: (String text) {
              this.onSubmit(text);
            },
          ),
        ),
      ],
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
  bool medium, border;
  int maxLine;

  AppTextInputField({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.onTextChange,
    this.elevation = true,
    this.border = false,
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
            borderSide: this.border ? BorderSide() : BorderSide.none,
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
