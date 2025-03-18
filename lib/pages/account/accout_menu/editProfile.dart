import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vegedya_firebase/services/customer_services.dart';
import 'package:vegedya_firebase/widgets/input_field.dart';

class EditProfilePage extends StatefulWidget {
  String? customerId;
  final FirebaseFirestore db;

  EditProfilePage({
    super.key,
    this.customerId,
    required this.db,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String customerName = '';
  String email = '';
  String phone = '';
  String address = '';
  bool _isLoading = false;

  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  final CustomerService _customerService = CustomerService();

  @override
  void initState() {
    super.initState();
    _fetchCustomerName();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomerName() async {
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
          customerName = customerData['name'] ?? 'Guest';
          email = customerData['email'] ?? 'Guest';
          phone = customerData['phone'] ?? '';
          address = customerData['address'] ?? '';
          _nameController.text = customerName;
          _emailController.text = email;
          _phoneController.text = phone;
          _addressController.text = address;
        }
      } catch (e) {
        print('Error fetching customer data: $e');
      }
    }
  }

  Future<void> _updateCustomerData() async {
    setState(() {
      _isLoading = true; // Menandakan bahwa proses sedang berlangsung
    });
    print('Update button pressed');
    customerName = 'Customer';
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
        await _customerService.updateCustomerData(customerId, {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
        });

        print('Customer data updated successfully');
        // Informasikan pengguna bahwa data telah diperbarui
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Berhasil"),
              content: Text("Data berhasil di update"),
              actions: <Widget>[
                TextButton(
                  child: Text("Tutup"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Menutup pop-up
                  },
                ),
              ],
            );
          },
        ).then((_) {
          Navigator.of(context).pop();
        });
      } catch (e) {
        print('Error fetching customer data: $e');
      } finally {
        setState(() {
          _isLoading = false; // Hentikan loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Edit Profile'),
    );

    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: true,
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
                    SizedBox(height: 25),
                    InputField(
                      labelText: "Name",
                      controller: _nameController,
                    ),
                    SizedBox(height: 25),
                    InputField(
                      labelText: "Email",
                      controller: _emailController,
                      readOnly: true,
                    ),
                    SizedBox(height: 25),
                    InputField(
                      labelText: "Phone",
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 25),
                    InputField(
                      labelText: "Address",
                      controller: _addressController,
                    ),
                    SizedBox(height: 25),
                    Expanded(child: Container()),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: _updateCustomerData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 111, 78, 55),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 130, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Update",
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


