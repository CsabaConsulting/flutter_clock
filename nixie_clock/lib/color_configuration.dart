import 'package:flutter/material.dart';

enum ColorSelector {
  background,
  nixieOn,
  nixieGlow,
  nixieOff,
  nixieGrid,
  nixieBgGlow1,
  nixieBgGlow2,
  nixieBgGlow3,
  nixieGlass,
  vfdTextOn,
  vfdTextGlow,
  vfdTextOff,
  vfdBackground,
  vfdGrid,
}

final lightTheme = {
  ColorSelector.background: Color(0xFFEFEEEA),
  ColorSelector.nixieOn: Color(0xDDFFFF8C),
  ColorSelector.nixieGlow: Color(0xDDFEF06B),
  ColorSelector.nixieOff: Color(0xDDC58A68),
  ColorSelector.nixieGrid: Color(0xFF364852),
  ColorSelector.nixieBgGlow1: Color(0x99FFAA0F),
  ColorSelector.nixieBgGlow2: Color(0x99FA611B),
  ColorSelector.nixieBgGlow3: Color(0x00FFAA0F),
  ColorSelector.nixieGlass: Color(0xFF3D2021),
  ColorSelector.vfdTextOn: Color(0xFFBBFEFF),
  ColorSelector.vfdTextGlow: Color(0xFFCBFFFF),
  ColorSelector.vfdTextOff: Color(0xFF364852),
  ColorSelector.vfdBackground: Color(0xFF1A2E39),
  ColorSelector.vfdGrid: Color(0xBB1A2E39),
};

final darkTheme = {
  ColorSelector.background: Color(0xFF0F0000),
  ColorSelector.nixieOn: Color(0xDDFFFF8C),
  ColorSelector.nixieGlow: Color(0xDDFEF06B),
  ColorSelector.nixieOff: Color(0xDDC58A68),
  ColorSelector.nixieGrid: Color(0xFF364852),
  ColorSelector.nixieBgGlow1: Color(0x99FFAA0F),
  ColorSelector.nixieBgGlow2: Color(0x99FA611B),
  ColorSelector.nixieBgGlow3: Color(0x00FFAA0F),
  ColorSelector.nixieGlass: Color(0xFF3D2021),
  ColorSelector.vfdTextOn: Color(0xFFBBFEFF),
  ColorSelector.vfdTextGlow: Color(0xFFCBFFFF),
  ColorSelector.vfdTextOff: Color(0xFF364852),
  ColorSelector.vfdBackground: Color(0xFF1A2E39),
  ColorSelector.vfdGrid: Color(0xBB1A2E39),
};
