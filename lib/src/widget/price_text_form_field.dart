import 'package:bykak/src/components/hex_color.dart';
import 'package:flutter/material.dart';

class PriceTextFormField extends StatelessWidget {
  // const CustomTextFormField({
  //   Key? key,
  // }) : super(key: key);

  final String hint;

  final int? lines;
  final String? label;
  final TextInputType? type;

  const PriceTextFormField(
      {required this.hint, required this.label, this.lines, this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "$label",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            maxLines: lines,
            keyboardType: type,
            obscureText: hint == "Password" ? true : false,
            decoration: InputDecoration(
              filled: true,
              // /fillColor: Colors.grey,
              hintText: "$hint",
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
        ),
      ],
    );
  }
}
