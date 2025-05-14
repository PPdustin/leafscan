import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Inter extends StatelessWidget {
  const Inter({
    super.key,
    required this.content,
    this.size = 14,
    this.fontWeight = FontWeight.bold,
    this.txtColor = Colors.white,
  });
  final String content;
  final double size;
  final FontWeight fontWeight;
  final Color txtColor;
  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: GoogleFonts.inter(fontSize: size, fontWeight: fontWeight, color: txtColor),
    );
  }
}
