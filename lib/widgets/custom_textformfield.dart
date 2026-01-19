// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.validator,
    required this.onSaved,
    this.controller = TextEditingController,
    this.isObscure = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = FB_TEXT_COLOR_WHITE,
    required this.height,
    required this.width,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
    this.suffixIcon,
  });

  final validator;
  final onSaved;
  final controller;
  final isObscure;
  final fontSize;
  final fontColor;
  final double height, width;
  final hintTextSize;
  final hintText;
  final fillColor;
  final Widget? suffixIcon;
  TextInputType keyboardType;
  int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      style: TextStyle(fontSize: fontSize, color: fontColor),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(width, height, width, height),
        focusColor: Colors.black12,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: FB_LIGHT_PRIMARY, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorStyle: const TextStyle(fontFamily: 'Frutiger'),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: FB_LIGHT_PRIMARY, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: FB_TEXT_COLOR_GREY,
          fontSize: hintTextSize,
          fontFamily: 'Frutiger',
        ),
        hintText: hintText,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
