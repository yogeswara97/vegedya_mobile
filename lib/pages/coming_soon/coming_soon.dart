import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              width: 500,
              child: Image.asset(
                "assets/images/coming_soon/coming-soon.jpg",
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}