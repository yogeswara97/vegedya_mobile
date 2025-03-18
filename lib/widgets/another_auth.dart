import 'package:flutter/material.dart';

class AnotherAuth extends StatelessWidget {
  const AnotherAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 25,
                endIndent: 10,
              ),
            ),
            Text(
              "or",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 25,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnotherLogo(
              logo: "assets/icon/google.png",
            ),
            AnotherLogo(
              logo: "assets/icon/facebook.png",
            ),
            AnotherLogo(
              logo: "assets/icon/apple.png",
            ),
          ],
        ),
      ],
    );
  }
}

class AnotherLogo extends StatelessWidget {
  final String logo;

  const AnotherLogo({super.key, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Image.asset(
        logo,
        height: 60,
        width: 60,
      ),
    );
  }
}