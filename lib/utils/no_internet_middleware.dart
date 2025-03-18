// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// class NoInternetMiddleware extends StatefulWidget {
//   final Widget child;

//   NoInternetMiddleware({super.key, required this.child});

//   @override
//   State<NoInternetMiddleware> createState() => _NoInternetMiddlewareState();
// }

// class _NoInternetMiddlewareState extends State<NoInternetMiddleware> {
//   late Connectivity _connectivity;
//   bool _isOffline = false;

//   @override
//   void initState() {
//     super.initState();
//     _connectivity = Connectivity();
    
//     // Mendengarkan perubahan status koneksi
//     _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.none) {
//         _showNoInternetDialog();  // Menampilkan dialog ketika tidak ada koneksi
//         setState(() {
//           _isOffline = true;
//         });
//       } else {
//         if (_isOffline) {
//           Navigator.of(context, rootNavigator: true).pop(); // Tutup dialog jika sudah online
//           setState(() {
//             _isOffline = false;
//           });
//         }
//       }
//     });
//   }

//   // Menampilkan dialog no internet
//   void _showNoInternetDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Dialog tidak bisa ditutup dengan tap di luar
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("No Internet Connection"),
//           content: const Text("Please check your internet connection."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Menutup dialog
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
