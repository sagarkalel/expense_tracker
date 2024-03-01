import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class CustomTheme {
  static CustomTheme of(BuildContext context) {
    return MyTheme();
  }

  late Color primaryColor;
  Typography get _typography => ThemeTypography(this);
  String get smallTextFamily => _typography.smallTextFamily;
  TextStyle get smallText => _typography.smallText;
}

class MyTheme extends CustomTheme {
  Color primaryColor = Colors.amber;
}

abstract class Typography {
  String get smallTextFamily;
  TextStyle get smallText;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);
  final CustomTheme theme;
  @override
  TextStyle get smallText => GoogleFonts.getFont(
        smallTextFamily,
        fontSize: 20,
        color: Colors.purple,
      );
  @override
  String get smallTextFamily => "Poppins";
}

extension abc on TextStyle {
  TextStyle abcd({
    double? size,
    Color? color,
  }) =>
      TextStyle(fontSize: size, color: color);
}
