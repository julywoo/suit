import 'package:bykak/src/components/hex_color.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  // const CustomTextFormField({
  //   Key? key,
  // }) : super(key: key);

  final String hint;
  final TextEditingController controller;
  final int? lines;
  final TextInputType? type;
  final Function? searchMethod;
  const CustomTextFormField(
      {required this.hint,
      required this.controller,
      this.lines,
      this.type,
      this.searchMethod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        maxLines: lines,
        controller: controller,
        keyboardType: type,
        obscureText: hint == "Password" ? true : false,
        textInputAction: TextInputAction.go,
        onSubmitted: (value) async {
          await searchMethod!(controller.text.toString());
        },
        decoration: InputDecoration(
          filled: true,
          labelStyle: TextStyle(fontSize: 12),
          // /fillColor: Colors.grey,
          hintText: "$hint",
          hintStyle: TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: HexColor('#172543')),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
