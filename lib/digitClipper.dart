import 'package:flutter/material.dart';

class DigitClipper extends CustomClipper<Path> {
  const DigitClipper(this.path);

  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(DigitClipper oldClipper) => oldClipper.path != path;
}