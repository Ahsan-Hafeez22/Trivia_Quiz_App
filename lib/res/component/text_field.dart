import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String type;
  final FocusNode focusNode;
  final FocusNode? focusNode2;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.type,
    required this.focusNode,
    this.focusNode2,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true; // Controls password visibility

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {},
      readOnly: widget.type == 'email' ? true : false,
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPassword ? _isObscure : false,
      textInputAction: widget.focusNode2 != null
          ? TextInputAction.next
          : TextInputAction.done,
      onEditingComplete: widget.focusNode2 != null
          ? () => FocusScope.of(context).requestFocus(widget.focusNode2)
          : null,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.type == 'email'
            ? 40
            : widget.type == 'phone'
                ? 13
                : 15)
      ], // Limit input length
      keyboardType: widget.type == 'email'
          ? TextInputType.emailAddress
          : widget.type == 'phone'
              ? TextInputType.number
              : TextInputType.name,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        prefixIcon: Icon(
          widget.type == 'password'
              ? Icons.lock
              : widget.type == 'email'
                  ? Icons.email
                  : Icons.person,
          color: Colors.blue,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
                icon:
                    Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
              )
            : null,
      ),
    );
  }
}
