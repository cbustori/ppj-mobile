import 'package:flutter/material.dart';

const headerStyle = TextStyle(fontSize: 35, fontWeight: FontWeight.w900);
const subHeaderStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);

const baseTextStyle = const TextStyle(fontFamily: 'Poppins');

final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);

final regularTextStyle = baseTextStyle.copyWith(
    color: const Color(0xffb6b2df),
    fontSize: 10.0,
    fontWeight: FontWeight.w400);

final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);
