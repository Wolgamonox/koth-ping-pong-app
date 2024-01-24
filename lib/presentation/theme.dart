import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@riverpod
class ThemeHandler extends _$ThemeHandler{
  @override
  ThemeData build() {
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.green,
    );
  }

  void setBrightness(Brightness newBrightness) {
    state = state.copyWith(brightness: newBrightness);
  }
}
