import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shop_app/admin/adminHomePage.dart';
import 'package:shop_app/pages/homePage.dart';
import 'package:shop_app/pages/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final title = "Food";
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? login = sharedPreferences.getString('email');
  String? role = sharedPreferences.getString('role');

  print("login: " + login.toString());
  print("role: " + role.toString());

  runApp(
    Phoenix(
      child: MyApp(
        title: title,
        login: login,
        role: role,
      ),
    ),
  );
}

Future<void> _firebaseMessaginBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  // 'This channel is used for important notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.title,
    this.login,
    this.role,
  }) : super(key: key);

  final String? title;
  final String? login;
  final String? role;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jam Food',
      home: getState(login),
      theme: ThemeData(
        primaryColor: Color(0xFF40BF73),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          elevation: 17.0,
          selectedItemColor: Color(0xFF40BF73),
          selectedIconTheme: IconThemeData(color: Color(0xFF40BF73)),
          selectedLabelStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  Widget? getState(value) {
    if (login != null) {
      if (role == "User") {
        value = HomePage();
      } else if (role == "Admin") {
        value = AdminPanel();
      }
    } else {
      value = SignIn();
    }
    return value;
  }
}
