import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MainLoading extends StatelessWidget {
  const MainLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.brown,
          size: 80,
        ),
      );
  }
}