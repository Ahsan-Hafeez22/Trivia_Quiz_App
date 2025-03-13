import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.type,
    required this.focusNode,
    this.focusNode2,
  });

  final TextEditingController controller;
  final String hintText;
  final String type;
  final FocusNode focusNode;
  final FocusNode? focusNode2;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isObscureText = ValueNotifier(type == 'password');
    return ValueListenableBuilder<bool>(
      valueListenable: isObscureText,
      builder: (context, obscure, child) {
        return TextFormField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          inputFormatters: [LengthLimitingTextInputFormatter(45)],
          controller: controller,
          focusNode: focusNode,
          textInputAction:
              type == 'password' ? TextInputAction.done : TextInputAction.next,
          onEditingComplete: () =>
              FocusScope.of(context).requestFocus(focusNode2),
          obscureText: type == 'password' ? obscure : false,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: type == 'password'
                ? IconButton(
                    onPressed: () {
                      isObscureText.value = !isObscureText.value;
                    },
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ))
                : null,
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
                type == 'password' ? Icons.lock_sharp : Icons.email,
                color: Colors.blue),
          ),
          style: const TextStyle(color: Colors.black),
          keyboardType: type == 'password'
              ? TextInputType.text
              : TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return type == 'password'
                  ? 'Please enter your password'
                  : 'Please enter your email';
            } else if (type == 'email' &&
                !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        );
      },
    );
  }
}
