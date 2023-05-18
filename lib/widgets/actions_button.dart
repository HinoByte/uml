import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double containerWidth;
  final double containerHeight;
  final String buttonText;
  final Color colorBox;

  const ActionsButton({
    Key? key,
    required this.onPressed,
    required this.containerWidth,
    required this.containerHeight,
    required this.buttonText,
    required this.colorBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: colorBox,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
