import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/pages/account/account_fragment.dart';
import 'package:vegedya_firebase/pages/favorite/favorite_fragment.dart';
import 'package:vegedya_firebase/pages/home/home_fragment.dart';
import 'package:vegedya_firebase/pages/order/order_fragment.dart';

// ignore: must_be_immutable
class BottomNavigationPage extends StatefulWidget {
  final int initialIndex;
  String? customerId;

  BottomNavigationPage({
    super.key,
    this.initialIndex = 0,
    this.customerId
  });

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late int _selectedIndex;
  late PageController _pageController;
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeFragment(db: db,customerId: widget.customerId,),
          FavoriteFragment(db: db, customerId: widget.customerId),
          OrderFragment(db: db, customerId: widget.customerId),
          AccountFragment(db: db,customerId: widget.customerId,),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 111, 78, 55),
          unselectedItemColor: Colors.grey[700],
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w900,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(height: 30, child: Icon(Icons.home_filled)),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 30, child: Icon(Icons.favorite)),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 30, child: Icon(Icons.shopping_bag_rounded)),
              label: "Order",
            ),
            BottomNavigationBarItem(
              icon: SizedBox(height: 30, child: Icon(Icons.person)),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
