import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vegedya_firebase/Model/Order.dart';
import 'package:vegedya_firebase/pages/order/order_item.dart';
import 'package:vegedya_firebase/utils/notification_helper.dart';

class WaitingPoint extends StatefulWidget {
  final FirebaseFirestore db;
  final String? customerId;
  // final String orderId;

  WaitingPoint({
    super.key,
    required this.db,
    required this.customerId,
    // required this.orderId,
  });

  @override
  _WaitingPointState createState() => _WaitingPointState();
}

class _WaitingPointState extends State<WaitingPoint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final NotificationHelper _notificationHelper = NotificationHelper();

  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCancelConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cancel Payment'),
            content: Text('Are you sure you want to cancel the payment?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Color.fromARGB(255, 111, 78, 55),
                    ),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 111, 78, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Menggunakan StreamBuilder untuk mendengarkan perubahan pada dokumen order
    return WillPopScope(
      onWillPop: () async {
        _showCancelConfirmationDialog();
        return false; // Prevent the default back button action
      },
      child: Scaffold(
        body: Center(
          child: Column(
                children: [
                  Expanded(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset('assets/images/waiting/waiting.jpg'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Waiting For Point",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "Pembayaran Anda sedang diproses. Mohon tunggu sebentar hingga kami memverifikasi transaksi Anda.",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                        ElevatedButton(
                          onPressed: () {
                            _showCancelConfirmationDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 111, 78, 55),
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.size.width * 0.32,
                                vertical: mediaQuery.size.height * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: mediaQuery.size.width * 0.05),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ],
              )
          
          ),
        ),
      );
  }
}
