import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/pages/home/fragment/cart/cart_page.dart';
import 'package:vegedya_firebase/pages/home/home_fragment.dart';

class BottomCartPage extends StatefulWidget {
  final HomeFragment widget;

  const BottomCartPage({
    super.key,
    required this.widget,
  });

  @override
  State<BottomCartPage> createState() => _BottomCartPageState();
}

class _BottomCartPageState extends State<BottomCartPage> {


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
          // return Center(child: CircularProgressIndicator());
          return Container();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Container();
        } else {
          int itemCount = snapshot.data!.docs.length;
          return itemCount == 0
          ? Container()
          :Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 252, 252, 252),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: Offset(0, 1),
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
                          builder: (context) =>
                              CartPage(db: widget.widget.db, customerId: widget.widget.customerId,), 
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 111, 78, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Checkout ($itemCount item)",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 25,
                        )
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
