import 'package:flutter/material.dart';

void swipeNavigation (BuildContext context, Widget page){
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offetAnimation = animation.drive(tween);

        return SlideTransition(position: offetAnimation, child: child,);
      }
    )
  );
}