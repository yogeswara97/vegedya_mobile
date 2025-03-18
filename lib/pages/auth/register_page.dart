import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vegedya_firebase/pages/account/accout_menu/editProfile.dart';
import 'package:vegedya_firebase/pages/auth/login_page.dart';
import 'package:vegedya_firebase/services/auth.dart';
import 'package:vegedya_firebase/widgets/another_auth.dart';
import 'package:vegedya_firebase/widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPasswordController = TextEditingController();
  bool _isLoading = false;

  final AuthService authService = AuthService();

  void _register() async {
    if (_passwordController.text != _verifyPasswordController.text) {
      _showErrorDialog("Register Failed", "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      await authService.addCustomer(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginPage()));

    } catch (e) {
      _showErrorDialog("Register Failed", e.toString());
      print(e.toString());
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
                        "Register Now!",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Join With us!",
                        style: TextStyle(fontSize: 30, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 30),
                    InputField(
                      labelText: "Name",
                      controller: _nameController,
                    ),
                    SizedBox(height: 25),
                    InputField(
                      labelText: "Email",
                      controller: _emailController,
                    ),
                    SizedBox(height: 25),
                    InputField(
                      labelText: "Password",
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 25),
                    InputField(
                      labelText: "Verify Password",
                      controller: _verifyPasswordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 25),
                    // AnotherAuth(),
                    Expanded(child: Container()),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 111, 78, 55),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 130, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}




