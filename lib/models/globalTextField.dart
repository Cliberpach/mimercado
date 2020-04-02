import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/util.dart';
import '../util/pref.dart';

class GloblaTextField {
  Util util = Util();
  Pref pref = Pref();

  Widget textOne(context,
      {keyboardType: TextInputType.text,
      validator(input),
      controller,
      onSaved(input),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      obscureText: false,
      focusNode,
      focusNodeNext,
      onFieldSubmitted(),
      hintText: '',
      labelText: '',
      double borderRadius: 20.0,
      paddingVe: 15.0,
      paddingHo: 20.0,
      filled: true,
      fillColor: Colors.white,
      int enabledBorderColor: 0xFFDFDFDF,
      int focusedBorderColor: 0xFFFF8000,
      enabledBorderWidth: 1.0,
      focusedBorderWidth: 2.0,
      fontSize: 20.0,
      color: 0xFF050505,
      max: 255}) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(focusedBorderColor),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          keyboardType: keyboardType,
          validator: (input) => validator(input),
          controller: controller,
          onSaved: (input) => onSaved(input),
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          focusNode: focusNode,
          obscureText: obscureText,
          onFieldSubmitted: (_) {
            if (onFieldSubmitted != null) onFieldSubmitted();
            FocusScope.of(context).requestFocus(focusNodeNext);
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(max),
          ],
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            filled: filled,
            fillColor: fillColor,
            contentPadding: EdgeInsets.symmetric(
                vertical: paddingVe, horizontal: paddingHo),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(enabledBorderColor), width: enabledBorderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(enabledBorderColor), width: enabledBorderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(focusedBorderColor),
                    width: focusedBorderWidth),
                borderRadius: BorderRadius.circular(borderRadius)),
          ),
          style: TextStyle(
            fontSize: fontSize,
            color: Color(color),
          ),
        ),
      ),
    );
  }

  Widget textTwo(context, prefixIcon,
      {keyboardType: TextInputType.text,
      validator(input),
      controller,
      onSaved(input),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      obscureText: false,
      focusNode,
      focusNodeNext,
      onFieldSubmitted(),
      hintText: '',
      labelText: '',
      double borderRadius: 20.0,
      paddingVe: 15.0,
      paddingHo: 20.0,
      filled: true,
      fillColor: Colors.white,
      int enabledBorderColor: 0xFFDFDFDF,
      int focusedBorderColor: 0xFF99C6F6,
      enabledBorderWidth: 1.0,
      focusedBorderWidth: 2.0,
      fontSize: 20.0,
      color: 0xFF050505,
      max: 255}) {
    return Theme(
      data: ThemeData(
        primaryColor: Color(focusedBorderColor),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          keyboardType: keyboardType,
          validator: (input) => validator(input),
          controller: controller,
          onSaved: (input) => onSaved(input),
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          focusNode: focusNode,
          obscureText: obscureText,
          onFieldSubmitted: (_) {
            if (onFieldSubmitted != null) onFieldSubmitted();
            FocusScope.of(context).requestFocus(focusNodeNext);
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(max),
          ],
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            filled: filled,
            fillColor: fillColor,
            prefixIcon: Icon(prefixIcon, color: Color(enabledBorderColor)),
            contentPadding: EdgeInsets.symmetric(
                vertical: paddingVe, horizontal: paddingHo),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(enabledBorderColor), width: enabledBorderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(enabledBorderColor), width: enabledBorderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(focusedBorderColor),
                    width: focusedBorderWidth),
                borderRadius: BorderRadius.circular(borderRadius)),
          ),
          style: TextStyle(
            fontSize: fontSize,
            color: Color(color),
          ),
        ),
      ),
    );
  }
}
