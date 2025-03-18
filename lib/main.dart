// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:vegedya_firebase/pages/splash_screen.dart';
import 'package:vegedya_firebase/services/session.dart';
import 'package:vegedya_firebase/utils/firebase_messaging_service.dart';
import 'package:vegedya_firebase/utils/notification_helper.dart';
import 'services/firebase_options.dart';  
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  //settings notif

  final notificationHelper = NotificationHelper();
  await notificationHelper.initializeNotifications();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessagingService().initialize();

  Session session = Session();
  final String? customerId = await session.getCustomerId();
  final String? customerName = await session.getName();

  // print("CustomerId : $customerId");
  // print("CustomerName : $customerName");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp(customerId: customerId));
  });
}

class MyApp extends StatelessWidget {
  final String? customerId;

  const MyApp({Key? key, this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: [SystemUiOverlay.top],
    // );
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          color: Colors.white ,
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          shape: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.3),
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SplashScreen(customerId: customerId,),
    );
  }
}
