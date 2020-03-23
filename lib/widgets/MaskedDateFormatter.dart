import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaskedDateFormatter extends TextInputFormatter {
  final String mask = 'DD/MM/YYYY';
  final String separator = '/';

  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;

        var newLet = newValue.text.substring(newValue.text.length - 1);
        if (int.tryParse(newLet) == null) return oldValue;

        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator$newLet',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        } else if (newValue.text.length < mask.length &&
            mask[newValue.text.length] == separator) {
          return TextEditingValue(
            text: '${newValue.text}$separator',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}