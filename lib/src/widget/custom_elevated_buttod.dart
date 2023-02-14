import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bykak/src/user/login_page.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final pageRoute;
  final String buttonColor;
  final String buttonTextColor;

  const CustomElevatedButton(
      {required this.text,
      required this.pageRoute,
      required this.buttonColor,
      required this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: TextButton.styleFrom(
            primary: HexColor('#172543'), //글자색
            onSurface: HexColor('#172543'), //onpressed가 null일때 색상
            backgroundColor: HexColor(buttonColor),
            shadowColor: Colors.white, //그림자 색상
            elevation: 1, // 버튼 입체감
            textStyle: TextStyle(fontSize: 18),
            //padding: EdgeInsets.all(16.0),
            minimumSize: Size(200, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: pageRoute,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.mail,
              //   size: 18,
              //   color: HexColor(buttonTextColor),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              Text("$text",
                  style: TextStyle(
                    fontSize: 18,
                    color: HexColor(buttonTextColor),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButtonSocial extends StatelessWidget {
  final String text;
  final pageRoute;
  final String buttonColor;
  final String buttonTextColor;
  final String buttonIcon;

  const CustomElevatedButtonSocial(
      {required this.text,
      required this.pageRoute,
      required this.buttonColor,
      required this.buttonTextColor,
      required this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: TextButton.styleFrom(
            primary: Colors.white, //글자색
            onSurface: Colors.white, //onpressed가 null일때 색상
            backgroundColor: HexColor(buttonColor),
            shadowColor: Colors.white, //그림자 색상
            elevation: 1, // 버튼 입체감
            textStyle: TextStyle(fontSize: 18),
            //padding: EdgeInsets.all(16.0),
            minimumSize: Size(double.infinity, 44),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: pageRoute,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(buttonIcon, height: 18, width: 18, scale: 1.0),
              SizedBox(
                width: 10,
              ),
              Text("$text",
                  style: TextStyle(
                    fontSize: 18,
                    color: HexColor(buttonTextColor),
                  )),
            ],
          ),
        ));
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
