import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppFontsType { openSans, roboto, robotoCondensed, lato }

final fontProvider = StateNotifierProvider<AppFont, AppFontsType>((ref) {
  return AppFont();
});

class AppFont extends StateNotifier<AppFontsType> {
  AppFont() : super(AppFontsType.openSans); // Default font is OpenSans

  void changeFont(AppFontsType appFont) {
    state = appFont; // Update state with the new font
  }
}
