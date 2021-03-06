import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/admin/adminHomePage/adminHomePage.dart';
import 'package:shop_app/deliverPanel/delivery.dart';
import 'package:shop_app/pages/homepage/homePage.dart';
import 'package:shop_app/pages/sign%20in/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/utils/magic_strings.dart';
import 'package:shop_app/utils/routes.dart';

import 'Model/supermarketModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final title = "Food";
  await Firebase.initializeApp();
  // FirebaseFirestore.instance.settings =
  //     Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  // FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? login = sharedPreferences.getString(SharedPreferencesNames.email);
  String? role = sharedPreferences.getString(SharedPreferencesNames.role);

  try {
    var store = await FirebaseFirestore.instance
        .collection('Supermarket')
        .withConverter(
          fromFirestore: (snapshot, _) =>
              SuperMarketModel.fromJson(snapshot.data()!),
          toFirestore: (SuperMarketModel model, _) => model.toJson(),
        )
        .snapshots()
        .first;
    if (sharedPreferences.getString(SharedPreferencesNames.selectedStore) ==
        null) {
      await sharedPreferences.setString(SharedPreferencesNames.selectedStore,
          store.docs.first.data().storeId!);
    }
  } catch (e) {
    print('data error: $e');
  }
  print("login: " + login.toString());
  print("role: " + role.toString());
  runApp(
    ProviderScope(
        child: MyApp(
      title: title,
      login: login,
      role: role,
    )),
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
    required this.title,
    required this.login,
    required this.role,
  }) : super(key: key);

  final String title;
  final String? login;
  final String? role;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black87,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black,
      ),
    );
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
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 55,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  Widget getState(value) {
    if (login != null) {
      if (role == "User") {
        value = HomePage();
      } else if (role == "Admin") {
        value = AdminPanel();
      } else if (role == "Delivery") {
        value = DeliveryPanel();
      }
    } else {
      value = SignIn();
    }
    return value;
  }
}
