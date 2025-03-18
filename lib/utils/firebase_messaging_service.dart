import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async{
    //izin untuk notif
    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provsional permission');
    } else{
      print('User declined or has not accepted permission');
    }

    //ambil token
    String? token = await _firebaseMessaging.getToken();
    print("Firebase Messaging Token: $token");

    // Mengatur handler untuk menerima pesan ketika aplikasi berada di latar depan
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print('Received a message while in the foreground: ${message.notification?.title}, ${message.notification?.body}');
    });

    // Mengatur handler untuk menerima pesan ketika aplikasi berada di latar belakang
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! $message');
      // Navigasi ke halaman yang relevan
    });
  }
  
}