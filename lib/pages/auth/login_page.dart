import 'package:flutter/material.dart';
import 'package:vegedya_firebase/pages/auth/register_page.dart';
import 'package:vegedya_firebase/pages/navigation/bottom_navigation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vegedya_firebase/services/auth.dart';
import 'package:vegedya_firebase/services/session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vegedya_firebase/widgets/another_auth.dart';
import 'package:vegedya_firebase/widgets/input_field.dart';

// auth
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();


  bool _isLoading = false;
  final Session _saveSession = Session();

  void loginApi(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await authService.checkCustomer(email, password);

      User? user = userCredential.user;
      if (user != null) {
        // Cetak data customer
        await _saveSession.saveSession(user.email, user.uid, user.displayName ?? "User");

        // Navigasi ke halaman berikutnya
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationPage(customerId: user.uid,),
          ),
        );
      } else {
        _showErrorDialog("Login Failed", "Invalid username or password");
      }
    } catch (e) {
      _showErrorDialog("Login Failed", "An error occurred while logging in. Please try again. $e");
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.brown,
                size: 80,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Let's Sign In",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 38, 13, 1)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Welcome back",
                        style: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "You've been missed!",
                        style: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 30),
                    InputField(labelText: "email", controller: emailController),
                    SizedBox(height: 25),
                    InputField(labelText: "password", controller: passwordController, obscureText: true,),
                    SizedBox(height: 25),
                    // AnotherAuth(),
                    Expanded(child: Container()),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account | ",
                                style: TextStyle(fontSize: 18),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              loginApi(emailController.text,
                                  passwordController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 111, 78, 55),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 135, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

