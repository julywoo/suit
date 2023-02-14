import 'package:flutter/material.dart';

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

// const primaryColor = Color(0xFF685BFF);
// const canvasColor = Color(0xFF2E2E48);
// const scaffoldBackgroundColor = Color(0xFF464667);
// const accentCanvasColor = Color(0xFF3E3E61);

// final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
// 172543 navy
// 0e6654 geeen

const white = Colors.white;
const mainColor = Color(0xFF172543);
const subColor = Color(0xFF003399);
const accentMainColor = Color(0xFF172543);

final divider = Divider(color: white.withOpacity(0.3), height: 1);
