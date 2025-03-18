import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegedya_firebase/pages/account/accout_menu/editProfile.dart';
import 'package:vegedya_firebase/pages/account/accout_menu/privacyPolicy.dart';
import 'package:vegedya_firebase/pages/account/accout_menu/settings.dart';
import 'package:vegedya_firebase/pages/account/accout_menu/termsCondition.dart';
import 'package:vegedya_firebase/pages/auth/login_page.dart';
import 'package:vegedya_firebase/pages/auth/welcome_page.dart';
import 'package:vegedya_firebase/services/customer_services.dart';
import 'package:vegedya_firebase/services/session.dart';
import 'package:vegedya_firebase/utils/swipe_navigation.dart';
import 'package:vegedya_firebase/widgets/loading_widgets.dart';
import 'package:vegedya_firebase/widgets/refresh_indicator_widget.dart';

class AccountFragment extends StatefulWidget {
  final String? customerId;
  final FirebaseFirestore db;

  const AccountFragment({super.key, this.customerId, required this.db});

  @override
  State<AccountFragment> createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  String customerName = '';
  final CustomerService _customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    _fetchCustomerName();
  }

  Future<void> checkCustomerId() async {
    if (widget.customerId == null) {
      await Future.delayed(Duration.zero); // Ensure this is async
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  Future<String?> _fetchCustomerName() async {
    String? customerId = widget.customerId;

    // Jika widget.customerId null, coba ambil dari pengguna yang diautentikasi
    if (customerId == null) {
      try {
        customerId = await _customerService.getCurrentUserId();
      } catch (e) {
        print('Error getting current user ID: $e');
      }
    }

    // Jika customerId tersedia, ambil data pelanggan
    if (customerId != null) {
      try {
        var customerData = await _customerService.getCustomerData(customerId);
        print('Customer Data: $customerData');
        if (customerData != null) {
          return customerData['name'] ?? 'Guest';
        }
      } catch (e) {
        print('Error fetching customer data: $e');
      }
    }
    return 'Guest'; // Default fallback
  }

  void logout() async {
    Session session = Session();
    await session.clearSession();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WelcomePage()));
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
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
                  onPressed: logout,
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

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([checkCustomerId(), _fetchCustomerName()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: MainLoading()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Handle errors
        } else if (snapshot.hasData) {
          String customerName =
              snapshot.data?[1] ?? 'Guest'; // Retrieve customerName

          return Scaffold(
            appBar: AppBar(
              title: Text("Account"),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: _showLogoutConfirmationDialog,
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: RefreshIndicatorWidget(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 64,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      customerName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 32),
                    AccountFeatureBox(
                      title: 'Edit Profile',
                      icon: Icons.edit,
                      onTap: () {
                        swipeNavigation(context, EditProfilePage(customerId: widget.customerId, db: widget.db));
                      },
                    ),
                    AccountFeatureBox(
                      title: 'Privacy and Policy',
                      icon: Icons.settings,
                      onTap: () {
                        swipeNavigation(context, PrivacyPolicyPage());
                      },
                    ),
                    AccountFeatureBox(
                      title: 'Terms and Conditions',
                      icon: Icons.settings,
                      onTap: () {
                        swipeNavigation(context, TermsConditionsPage());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: Text('No Data')); // Handle no data case
        }
      },
    );
  }
}

// Widget untuk menampilkan fitur akun dalam kotak
class AccountFeatureBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const AccountFeatureBox({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 1),
              )
            ]),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.black,
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
