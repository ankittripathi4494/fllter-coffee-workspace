import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormWidgets {
  static buildTextFormField(BuildContext context,
      {Function()? onChanged,
      bool? obscureText,
      String obscuringCharacter = '•',
      List<TextInputFormatter>? inputFormatters,
      Widget? suffixIcon,
      Widget? prefixIcon,
      String? labelText,
      String? hintText,
      String? errorText,
      String? helperText,
      TextInputType? keyboardType,
      int? maxLength,
      bool? enabled,
      TextEditingController? controller}) {
    return TextFormField(
      enabled: enabled,
      onChanged: (value) => onChanged,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: (obscureText != null) ? obscureText : false,
      obscuringCharacter: obscuringCharacter,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          counterText: "",
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.green,
          suffixIcon: (suffixIcon != null) ? suffixIcon : null,
          suffixIconColor: Colors.green,
          helperText: helperText,
          helperStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 10),
          labelText: (labelText != null) ? labelText : null,
          labelStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
          hintText: (hintText != null) ? hintText : null,
          hintStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 10),
          errorText: (errorText != null) ? errorText : null,
          errorStyle: const TextStyle(
              color: Colors.red, fontWeight: FontWeight.w300, fontSize: 10),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2)),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2))),
    );
  }
}
