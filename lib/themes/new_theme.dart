import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// this is class to give textTheme
abstract class NewTheme {
  static NewTheme of(BuildContext context) => LightTheme();
  late Color primaryColor;

  Typograph get _typograph => ThemeTypograph(this);
  late String smallTextFamily = _typograph.smallTextFamily;
  late TextStyle smallText = _typograph.smallText;
}

class LightTheme extends NewTheme {
  late Color primaryColor = Colors.amber;
}

abstract class Typograph {
  String get smallTextFamily;
  TextStyle get smallText;
}

class ThemeTypograph extends Typograph {
  ThemeTypograph(this.theme);
  final NewTheme theme;
  @override
  TextStyle get smallText => GoogleFonts.getFont(smallTextFamily,
      fontSize: 15, color: theme.primaryColor);
  @override
  String get smallTextFamily => splitCamelCase(FontFamilies.Poppins.name);
}

//try to give same name of enum values as font family name. and instead of giving space, use capital letter without space
//please add all the font families which are in theme to access it
/// only this many font families we are using in our theme
enum FontFamilies { Poppins, Mooli, Fuggles, OpenSans }

String splitCamelCase(String input) {
  // Use regular expressions to split the string at each capital letter
  final words = input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
    return '${match.group(1)} ${match.group(2)}';
  });
  // Capitalize the first letter of the first word.
  return words.replaceFirstMapped(RegExp(r'^[a-z]'), (match) {
    return match.group(0)!.toUpperCase();
  });
}

extension xyz on TextStyle {
  ///by default font family we have set here as [FontFamilies.Poppins]
  TextStyle overridesWithNew({
    FontFamilies fontfamily = FontFamilies.Poppins,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextOverflow? overflow,
    FontStyle? fontStyle,
  }) =>
      (fontfamily.name.isNotEmpty
          ? GoogleFonts.getFont(
              splitCamelCase(fontfamily.name),
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
            )
          : copyWith(
              color: color ?? this.color,
              fontWeight: fontWeight ?? this.fontWeight,
              fontSize: fontSize ?? this.fontSize,
              overflow: overflow ?? this.overflow,
              fontStyle: fontStyle ?? this.fontStyle,
            ));
}
