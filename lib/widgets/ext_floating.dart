

import 'package:flutter/material.dart';

class ExtendedFloatingBtn extends StatelessWidget {
  String text;
  Function onpress;
  String heroKey;


  ExtendedFloatingBtn( this.heroKey,this.onpress, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: FloatingActionButton.extended(
        onPressed: onpress,
        label: Text(text),
        heroTag: heroKey,
      
      ),
    );
  }
}




