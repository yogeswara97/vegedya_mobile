import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vegedya_firebase/Model/Order.dart';
import 'package:vegedya_firebase/pages/order/order_item.dart';
import 'package:vegedya_firebase/services/customer_services.dart';
import 'package:vegedya_firebase/utils/notification_helper.dart';

class WaitingPayment extends StatefulWidget {
  final FirebaseFirestore db;
  final String? customerId;
  final String orderId;
  final int point;

  WaitingPayment({
    super.key,
    required this.db,
    required this.customerId,
    required this.orderId, 
    required this.point,
  });

  @override
  _WaitingPaymentState createState() => _WaitingPaymentState();
}

class _WaitingPaymentState extends State<WaitingPayment>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Stream<DocumentSnapshot> _orderStream;

  final NotificationHelper _notificationHelper = NotificationHelper();
  final CustomerService _customerService = CustomerService();

  Timer? _timer;
  late int _start;

  void onTimerComplate() async {
    try {
      final orderRef = widget.db.collection('orders').doc(widget.orderId);

      await orderRef.update({
        'status': 'cancel',
      });

      _notificationHelper.showNotification(
        'order Cancelled',
        'Your order has been cancelled.',
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OrderItemPage(
                  orderId: widget.orderId,
                  db: widget.db,
                  orderStatus: 'Cancel')));

    } catch (e) {
      print('Error processing order: $e');
    }
  }

  void startTimerFromOrderDate(DateTime orderDate) {
    final now = DateTime.now();
    final timeDifference = now.difference(orderDate).inSeconds;
    final maxTime = 5 * 60; //15 menit dalam detik

    //menghiting waktu tersisa
    _start = maxTime - timeDifference;
    print(maxTime);

    if (_start > 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
              onTimerComplate();
            });
          } else {
            timer.cancel();
            onTimerComplate();
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      });
    } else {
      onTimerComplate(); // Jika sudah lewat dari 15 menit
    }
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    // Menggunakan NumberFormat dari intl untuk format angka 2 digit
    final minutesFormatted = NumberFormat("00").format(minutes);
    final secondsFormatted = NumberFormat("00").format(remainingSeconds);

    return '$minutesFormatted:$secondsFormatted';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.05).animate(_controller);

    // Inisialisasi stream untuk mendengarkan dokumen order
    _orderStream =
        widget.db.collection('orders').doc(widget.orderId).snapshots();

    // Mulai mendengarkan stream untuk mendapatkan orderDate
    _orderStream.listen((snapshot) {
      if (snapshot.exists) {
        final orderData = snapshot.data() as Map<String, dynamic>;
        final orderDate = (orderData['orderDate'] as Timestamp).toDate();
        startTimerFromOrderDate(
            orderDate); // Panggil fungsi untuk memulai timer
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
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
                    try {
                      final orderRef =
                          widget.db.collection('orders').doc(widget.orderId);

                      await orderRef.update({
                        'status': 'cancel',
                      });

                      _notificationHelper.showNotification(
                        'order Cancelled',
                        'Your order has been cancelled.',
                      );

                      Navigator.of(context).pop(); // Close dialog
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderItemPage(
                                  orderId: widget.orderId,
                                  db: widget.db,
                                  orderStatus: 'Cancel')));
                    } catch (e) {
                      print('Error processing order: $e');
                    }
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

  bool _hasUpdatedPoints = false; // Tambahkan flag ini untuk mengecek apakah poin sudah di-update

  void updatePointCustomer() async {
    if (_hasUpdatedPoints) return; // Cegah update jika sudah pernah di-update

    try {
      if (widget.customerId != null) {
        final customerRef = widget.db.collection('users').doc(widget.customerId);
        await customerRef.update({
          'points': FieldValue.increment(widget.point),
        });

        _hasUpdatedPoints = true; // Set flag menjadi true setelah update berhasil
      }
    } catch (e) {
      print('Error updating points: $e');
    }
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
          child: StreamBuilder<DocumentSnapshot>(
            stream: _orderStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Menampilkan loading indicator
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Text("No data found.");
              }

              // Memeriksa status pembayaran
              final orderData = snapshot.data!.data() as Map<String, dynamic>;
              final order = OrderModel.fromMap(orderData, snapshot.data!.id);

              if (order.status == 'Success' || order.status == 'Cancel') {
                
                if (order.status == 'Success') {
                  _notificationHelper.showNotification(
                    'order Success',
                    'Your order has been Success. You got ${widget.point} points',
                  );
                  
                  // update point disini
                  updatePointCustomer();
                } else {
                  _notificationHelper.showNotification(
                    'order Cancelled',
                    'Your order has been cancelled.',
                  );
                }

                // Jika status pembayaran berhasil atau sukses, tutup layar
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context); // Menutup layar
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderItemPage(
                              orderId: widget.orderId,
                              db: widget.db,
                              orderStatus: order.status)));
                });
              }

              Color textColor = _start <= 10 ? Colors.red : Colors.black;

              return Column(
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
                        Text(
                          formatTime(_start),
                          style: TextStyle(fontSize: 35, color: textColor),
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Waiting For Payment",
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
              );
            },
          ),
        ),
      ),
    );
  }
}
