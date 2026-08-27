import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/widgets/custom_font.dart';
import 'package:tuazon_mobprog/constants.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  late String buttonType, buttonName;
  // Nullable so they can default to the theme-aware text color at build time
  // (a getter cannot be used as a const default value here).
  Color? fontColor, outlineColor;
  late dynamic onPressed;

  CustomButton(
    {super.key,
    this.buttonType = 'elevated',
    required this.buttonName,
    this.fontColor,
    required this.onPressed,
    this.outlineColor});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    // Fall back to the theme-aware colors so button text/outline adapt to dark mode.
    final Color fontColor = widget.fontColor ?? FB_TEXT_PRIMARY;
    final Color outlineColor = widget.outlineColor ?? FB_TEXT_PRIMARY;
    widget.buttonType == widget.buttonType.toLowerCase();
    if (widget.buttonType == 'outlined'){
      return OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),  
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: outlineColor),
        ), 
        child: CustomFont(
          text: widget.buttonName, 
          fontSize: ScreenUtil().setSp(12), 
          color: fontColor),
          );
    }else if (widget.buttonType == 'text'){
      return TextButton(
        onPressed: widget.onPressed, 
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ), 
        child: CustomFont(
          text: widget.buttonName, 
          fontSize: ScreenUtil().setSp(12), 
          color: fontColor),
          );
    }else {
      return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ), child: CustomFont(
          text: widget.buttonName, 
          fontSize: ScreenUtil().setSp(12), 
          color: fontColor),
          );
    }
  }
}