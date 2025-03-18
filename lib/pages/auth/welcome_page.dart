import 'package:flutter/material.dart';
import 'package:vegedya_firebase/pages/auth/login_page.dart';
import 'package:vegedya_firebase/pages/auth/register_page.dart';
import 'package:vegedya_firebase/pages/navigation/bottom_navigation.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: mediaQuery.size.height * (isLandscape ? 0.4 : 0.3),
              width: double.infinity,
              child: Image.asset(
                "assets/images/welcome/bg-coffee.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.03),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
              child: Text(
                "Welcome to Vegedya Coffee",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: mediaQuery.size.width * 0.08,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "Explore a world of luck and prosperity with our latest deals and trends.",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: mediaQuery.size.width * 0.045,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.13),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavigationPage()));
                  },
                  child: Text(
                    "Login as a guest",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: mediaQuery.size.width * 0.05,
                      color: Colors.black, // Sama dengan di LoginPage
                    ),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.03),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 111, 78, 55),
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.35,
                        vertical: mediaQuery.size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: mediaQuery.size.width * 0.05),
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.01),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 242, 215),
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.32,
                        vertical: mediaQuery.size.height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Sama dengan di LoginPage
                        fontSize: mediaQuery.size.width * 0.05),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
