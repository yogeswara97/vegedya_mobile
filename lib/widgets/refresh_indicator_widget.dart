import 'package:flutter/material.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const RefreshIndicatorWidget(
      {super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child, 
      onRefresh: onRefresh,
      color: Color.fromARGB(255, 111, 78, 55),
      backgroundColor: Colors.white,
    );
  }
}
