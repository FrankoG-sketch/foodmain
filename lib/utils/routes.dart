// import 'package:flutter/widgets.dart';
// import 'package:shop_app/Users/Customers/screens/cart/cart_screen.dart';
// import 'package:shop_app/Authentication/complete_profile/complete_profile_screen.dart';
// import 'package:shop_app/Users/Customers/screens/details/details_screen.dart';
// import 'package:shop_app/Authentication/forgot_password/forgot_password_screen.dart';
// //import 'package:shop_app/Users/Customers/screens/home/Food_items/Popular.dart';
// import 'package:shop_app/Users/Customers/screens/home/home_screen.dart';
// import 'package:shop_app/Authentication/login_success/login_success_screen.dart';
// //import 'package:shop_app/Authentication/otp/otp_screen.dart';
// import 'package:shop_app/Authentication/profile/profile_screen.dart';
// import 'package:shop_app/Authentication/sign_in/sign_in_screen.dart';
// import 'package:shop_app/Authentication/splash/splash_screen.dart';
// import '../Users/Customers/screens/progress.dart';
// import 'Authentication/sign_up/sign_up_screen.dart';
// //import 'Users/Customers/screens/home/Food_items/List.dart';
// import 'Users/Customers/screens/home/Food_items/Popularitems.dart';

// // We use name route
// // All our routes will be available here
// final Map<String, WidgetBuilder> routes = {
//   SplashScreen.routeName: (context) => SplashScreen(),
//   SignInScreen.routeName: (context) => SignInScreen(),
//   ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
//   LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
//   SignUpScreen.routeName: (context) => SignUpScreen(),
//   CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
//   ShowProgress.routeName: (context) => ShowProgress(),
//   //OtpScreen.routeName: (context) => OtpScreen(),
//   HomeScreen.routeName: (context) => HomeScreen(),
//   DetailsScreen.routeName: (context) => DetailsScreen(),
//   CartScreen.routeName: (context) => CartScreen(),
//   ProfileScreen.routeName: (context) => ProfileScreen(),
//   Popitems.routeName: (context) => Popitems(),
//   //ListPage.routeName: (conext) => ListPage(),
// };

import 'package:flutter/material.dart';
import 'package:shop_app/admin/adminHomePage.dart';
import 'package:shop_app/pages/homePage.dart';
import 'package:shop_app/pages/passwordReset.dart';
import 'package:shop_app/pages/signUp.dart';
import 'package:shop_app/pages/signIn.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUp());

      case '/signIn':
        return MaterialPageRoute(builder: (context) => SignIn());

      case '/homePage':
        return MaterialPageRoute(builder: (context) => HomePage());

      case '/adminPanel':
        return MaterialPageRoute(builder: (context) => AdminPanel());

      case '/resetPassword':
        return MaterialPageRoute(builder: (context) => PasswordReset());

      // //PAGES UNIQUE TO ADMIN

      // case '/adminHomePage':
      //   return MaterialPageRoute(builder: (context) => AdminHomePage());

      // case '/adminProfilePage':
      //   return MaterialPageRoute(builder: (context) => UserProfile());

      // case '/adminSettings':
      //   return MaterialPageRoute(builder: (context) => AdminSettings());

      // case '/addUser':
      //   return MaterialPageRoute(builder: (context) => AddUser());

      // case '/viewAppointments':
      //   return MaterialPageRoute(builder: (context) => ViewAppointments());

      // case '/prescription':
      //   return MaterialPageRoute(builder: (context) => Prescription());

      // //PAGES UNIQUE TO USERS

      // case '/settings':
      //   return MaterialPageRoute(builder: (context) => Settings());

      // case '/signUp':
      //   return MaterialPageRoute(builder: (context) => SignUp());

      // case '/userHomePage':
      //   return MaterialPageRoute(builder: (context) => HomePage());

      // case '/about_fosterOffice':
      //   return MaterialPageRoute(builder: (context) => About());

      // case '/medication':
      //   return MaterialPageRoute(builder: (context) => Medication());

      // case '/finance':
      //   return MaterialPageRoute(builder: (context) => Finance());

      // case '/userProfile':
      //   return MaterialPageRoute(builder: (context) => Profile());

      // case '/appointment':
      //   return MaterialPageRoute(builder: (context) => Appointment());

      // case '/feedBack':
      //   return MaterialPageRoute(builder: (context) => FeedBackHelp());

      // case '/history':
      //   return MaterialPageRoute(builder: (context) => History());

      // case '/achievement':
      //   return MaterialPageRoute(builder: (context) => Achievement());

      // case '/cart':
      //   return MaterialPageRoute(builder: (context) => Cart());

      // case '/qr':
      //   return MaterialPageRoute(builder: (context) => Qr());

      // case '/doctorDetails':
      //   DoctorDetail args = settings.arguments as DoctorDetail;
      //   return MaterialPageRoute(
      //     builder: (context) => DoctorDetail(
      //         heroTag: args.heroTag,
      //         identification: args.identification,
      //         occupation: args.occupation,
      //         description: args.description,
      //         email: args.email),
      //   );

      // case '/medicationDetails':
      //   MedicationDetails args = settings.arguments as MedicationDetails;
      //   return MaterialPageRoute(
      //     builder: (context) => MedicationDetails(
      //       directions: args.directions,
      //       heroTag: args.heroTag,
      //       inactiveIngredients: args.inactiveIngredients,
      //       medicationName: args.medicationName,
      //       price: args.price,
      //       uses: args.uses,
      //       warnings: args.warnings,
      //     ),

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (BuildContext builder) {
        return Scaffold(
          //  appBar: appBar(builder, "Error 404"),
          body: Center(
            child: Text("Page not found....."),
          ),
        );
      },
    );
  }
}
