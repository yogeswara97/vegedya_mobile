import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID from Firebase Authentication
  Future<String?> getCurrentUserId() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  // Get customer data from Firestore using customer ID
  Future<Map<String, dynamic>?> getCustomerData(String customerId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(customerId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting customer data: $e');
      return null;
    }
  }

  // Get customer data for the current authenticated user
  Future<Map<String, dynamic>?> getCurrentCustomerData() async {
    try {
      String? customerId = await getCurrentUserId();
      if (customerId != null) {
        return await getCustomerData(customerId);
      } else {
        print('No authenticated user found');
        return null;
      }
    } catch (e) {
      print('Error getting current customer data: $e');
      return null;
    }
  }

  //Update customer data
  Future<void> updateCustomerData(String customerId, Map<String,dynamic> data) async {
    try {
      await _db.collection('users').doc(customerId).update(data); 
    } catch (e) {
      print('Error updating customer data: $e');
      throw e;
    }
  }
}
