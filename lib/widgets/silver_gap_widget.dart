import 'package:flutter/material.dart';

class SilverGapWidget extends StatelessWidget {
  const SilverGapWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.all(8),
        color: Colors.grey.withOpacity(0.2),
      )
    );
  }
}