import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    required this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    required this.onSaved,
    this.keyboardType = TextInputType.text,
    required this.validator,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final void Function(String?) onSaved;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none,
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[500]),
        fillColor: Colors.grey.withOpacity(0.2),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
