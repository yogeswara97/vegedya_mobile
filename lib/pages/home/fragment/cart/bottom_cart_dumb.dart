import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // untuk Timer dan durasi
import 'package:vegedya_firebase/pages/home/fragment/cart/cart_page.dart';
import 'package:vegedya_firebase/pages/home/home_fragment.dart';

class BottomCartPage extends StatefulWidget {
  const BottomCartPage({
    super.key,
    required this.widget,
  });

  final HomeFragment widget;

  @override
  State<BottomCartPage> createState() => _BottomCartPageState();
}

class _BottomCartPageState extends State<BottomCartPage> {
  Timer? _timer;
  Duration _countdownDuration = const Duration(minutes: 1); // Set waktu 60 menit

  @override
  void initState() {
    super.initState();
    startTimer();
    checkAndRemoveExpiredItems();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownDuration.inSeconds > 0) {
          _countdownDuration = _countdownDuration - const Duration(seconds: 1);
        } else {
          // Jika waktu habis, hapus item
          checkAndRemoveExpiredItems();
        }
      });
    });
  }

  // Fungsi untuk menghitung waktu yang telah berlalu
  bool isExpired(Timestamp addedAt, int expiryMinutes) {
    final expiryTime = addedAt.toDate().add(Duration(minutes: expiryMinutes));
    return DateTime.now().isAfter(expiryTime);
  }

  Future<void> checkAndRemoveExpiredItems() async {
    final cartItemsSnapshot = await widget.widget.db
        .collection('carts')
        .doc(widget.widget.customerId)
        .collection('items')
        .get();

    for (var doc in cartItemsSnapshot.docs) {
      var data = doc.data();
      Timestamp addedAt = data['addedAt'];

      // Misalnya, item dihapus jika lebih dari 60 menit (1 jam)
      if (isExpired(addedAt, 60)) {
        await doc.reference.delete();
      }
    }

    setState(() {});
  }

  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.widget.db
          .collection('carts')
          .doc(widget.widget.customerId)
          .collection('items')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // loading state
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Container(); // Jika tidak ada data
        } else {
          int itemCount = snapshot.data!.docs.length;
          return itemCount == 0
              ? Container()
              : Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 252, 252),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 15,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartPage(
                                  db: widget.widget.db,
                                  customerId: widget.widget.customerId,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 111, 78, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Checkout ($itemCount item)",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                formatDuration(_countdownDuration), // Menampilkan countdown timer
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        }
      },
    );
  }
}
