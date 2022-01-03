import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/admin/adminHomePage.dart';
// import 'package:get/get.dart';
import 'package:shop_app/pages/homePage.dart';
import 'package:shop_app/pages/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:shop_app/Users/Supermarket/home.dart';
import 'package:shop_app/utils/routes.dart';
//import 'package:shop_app/screens/home/home_screen.dart';
//import 'package:shop_app/screens/profile/profile_screen.dart';
// import 'package:shop_app/Authentication/splash/splash_screen.dart';
//import 'package:firebase_core/firebase_core.dart';

// import 'constants/firebase.dart';
// import 'controllers/appController.dart';
// import 'controllers/authController.dart';
// import 'controllers/cart_controller.dart';
// import 'controllers/products_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final title = "Food";
  await Firebase.initializeApp();
  // await initialization.then((value) {
  //   Get.put(AppController());
  //   Get.put(UserController());
  //   Get.put(ProducsController());
  //   Get.put(CartController());
  //});
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String login = sharedPreferences.getString('email');
  String role = sharedPreferences.getString('role');

  print("login: " + login.toString());
  print("role: " + role.toString());

  runApp(MyApp(
    title: title,
    login: login,
    role: role,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
    this.title,
    this.login,
    this.role,
  }) : super(key: key);

  final String title;
  final String login;
  final String role;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jam Food',
      home: getState(login),
      theme: ThemeData(
        primaryColor: Color(0xFF40BF73),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          // backgroundColor: Color(0xFF0B58BB),
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

  Widget getState(value) {
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
