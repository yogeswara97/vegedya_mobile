import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/pages/home/fragment/cart/bottom_cart.dart';
import 'package:vegedya_firebase/pages/home/fragment/category_list_horzontal.dart';
import 'package:vegedya_firebase/pages/home/fragment/image_slideshow/image_slideshow.dart';
import 'package:vegedya_firebase/pages/home/fragment/nav_bottom.dart';
import 'package:vegedya_firebase/pages/home/fragment/product/popular_products.dart';
import 'package:vegedya_firebase/pages/home/fragment/search_dalagate.dart';
import 'package:vegedya_firebase/pages/point/point_widget.dart';
import 'package:vegedya_firebase/services/customer_services.dart';
import 'package:vegedya_firebase/widgets/loading_widgets.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';

class HomeFragment extends StatefulWidget {
  final FirebaseFirestore db;
  final String? customerId;
  const HomeFragment({super.key, required this.db, this.customerId});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  String customerName = '';
  int customerPoints = 0;
  bool isLoading = true;
  final CustomerService _customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    customerName = 'Guest';
    String? customerId = widget.customerId;

    // Tunggu hingga semua data diambil
    await Future.wait([
      _fetchCustomerName(customerId),
    ]);

    // Setelah semua Future selesai, update state untuk menampilkan UI
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCustomerName(String? customerId) async {
    // Jika customerId tersedia, ambil data pelanggan
    if (customerId != null) {
      try {
        var customerData = await _customerService.getCustomerData(customerId);
        if (customerData != null) {
          customerName = customerData['name'] ?? 'Guest';
          customerPoints = customerData['points'] ?? 0;
        }
      } catch (e) {
        print('Error fetching customer data: $e');
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 8.0,
        backgroundColor: Color.fromARGB(255, 111, 78, 55),
        shape: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 111, 78, 55),
            width: 0.3,
          ),
        ),
      ),
      body: isLoading
          ? MainLoading()
          : RefreshIndicatorWidget(
              onRefresh: _refreshData,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      NavTop(customerName: customerName, db: widget.db),
                      PointWidget(db: widget.db, points: customerPoints, customerId: widget.customerId),
                      CategoryListHorizontal(db: widget.db),
                      ImageSlide(db: widget.db,),
                      PopularProducts(db: widget.db),
                      NavBottom(),
                      SizedBox(height: 35,)
                    ],
                  ),
                  BottomCartPage(widget: widget),
                ],
              ),
            ),
    );
  }
}


class NavTop extends StatelessWidget {
  final FirebaseFirestore db;

  const NavTop({
    super.key,
    required this.customerName,
    required this.db,
  });

  final String customerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: Color.fromARGB(255, 111, 78, 55),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome,",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                customerName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(db: db),
              );
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}






