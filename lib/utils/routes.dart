import 'package:flutter/material.dart';
import 'package:shop_app/admin/adminHomePage.dart';
import 'package:shop_app/pages/homePage.dart';
import 'package:shop_app/pages/passwordReset.dart';
import 'package:shop_app/pages/productDetails.dart';
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

      case '/productDetails':
        ProductDetails args = settings.arguments as ProductDetails;
        return MaterialPageRoute(
          builder: (context) => ProductDetails(
            heroTag: args.heroTag,
            name: args.name,
            price: args.price,
          ),
        );

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
