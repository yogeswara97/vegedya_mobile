import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegedya_firebase/pages/auth/welcome_page.dart';
import 'package:vegedya_firebase/pages/home/fragment/cart/waiting_payment.dart';
import 'package:vegedya_firebase/pages/navigation/bottom_navigation.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  String? customerId;
  final db = FirebaseFirestore.instance;

  SplashScreen({super.key, this.customerId});

  Future<void> checkOrderStatus(BuildContext context) async {
    if (customerId != null) {
      // Cek apakah ada status order yang waiting
      final ordersSnapshot = await db.collection('orders')
          .where('customerId', isEqualTo: customerId)
          .where('status', isEqualTo: 'waiting')
          .get();

      if (ordersSnapshot.docs.isNotEmpty) {
        // Ambil orderId dari dokumen yang ditemukan
        String orderId = ordersSnapshot.docs.first.id;

        // Jika ada status waiting, arahkan ke halaman pembayaran
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WaitingPayment(db: db, customerId: customerId, orderId: orderId, point: 0,)), // Halaman pembayaran
          (route) => false,
        );
      } else {
        // Jika tidak ada status waiting, arahkan ke halaman yang sesuai
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => BottomNavigationPage(
              initialIndex: 0,
              customerId: customerId,
            ),
          ),
          (route) => false,
        );
      }
    } else {
      // Jika tidak ada customerId, arahkan ke halaman welcome
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    Future.delayed(const Duration(seconds: 3)).then((value) {
      checkOrderStatus(context); // Panggil fungsi untuk cek status order
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 120,
              child: Image.asset(
                "assets/images/welcome/spalsh-logo.png",
              ),
            ),
            // SizedBox(height: 5,),
            // Text(
            //   "Vegedya Coffee",
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 111, 78, 55),),
            // )
          ],
        ),
      ),
    );
  }
}
