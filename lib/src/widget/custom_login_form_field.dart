import 'package:bykak/src/components/hex_color.dart';
import 'package:flutter/material.dart';

class CustomLoginFormField extends StatelessWidget {
  // const CustomTextFormField({
  //   Key? key,
  // }) : super(key: key);

  final String hint;
  final TextEditingController controller;
  final int? lines;
  final TextInputType? type;
  final Function? loginMethod;

  const CustomLoginFormField(
      {required this.hint,
      required this.controller,
      this.lines,
      this.type,
      this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Please enter some text';
        //   }
        //   return null;
        // },
        maxLines: lines,
        controller: controller,
        keyboardType: type,
        obscureText: hint.contains("비밀번호") ? true : false,
        textInputAction: TextInputAction.go,

        onSubmitted: (value) async {
          await loginMethod!();
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "$hint",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black45),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black45),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black45),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
