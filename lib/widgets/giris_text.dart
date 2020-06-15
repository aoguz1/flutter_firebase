import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class GirisTextWidget extends StatelessWidget {

  String solText;
  String sagText;
 GirisTextWidget(
 
    this.solText,
    this.sagText,
  ); 

  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(solText,style: GoogleFonts.lato(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        )),
         Text(sagText),
      ],
    );
  }
}
