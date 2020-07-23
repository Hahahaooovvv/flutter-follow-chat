import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetInput extends TextField {
  WidgetInput({
    String hintText,
    Widget prefixIcon,
    TextEditingController controller,
    List<TextInputFormatter> inputFormatters,
    Function(String value) onChanged,
    bool obscureText: false,
  }) : super(
          obscureText: obscureText,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            fillColor: Color.fromARGB(255, 245, 248, 249),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(4),
            ),
            prefixIcon: prefixIcon,
            hintText: hintText,
          ),
        );
}
