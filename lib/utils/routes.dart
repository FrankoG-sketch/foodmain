import 'package:flutter/material.dart';
import 'package:shop_app/admin/adminHomePage.dart';
import 'package:shop_app/deliverPanel/delivery.dart';
import 'package:shop_app/pages/Popular_items.dart';
import 'package:shop_app/pages/deliveryCheckOut.dart';
import 'package:shop_app/pages/homePage.dart';
import 'package:shop_app/pages/passwordReset.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/pages/productPage.dart';
import 'package:shop_app/pages/signUp.dart';
import 'package:shop_app/pages/signIn.dart';
import 'package:shop_app/pages/special_items.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/deliveryPanel':
        return MaterialPageRoute(builder: ((context) => DeliveryPanel()));

      case '/delieveryCheckOut':
        DeliveryCheckOut? args = settings.arguments as DeliveryCheckOut?;
        return MaterialPageRoute(
          builder: ((context) => DeliveryCheckOut(
                documents: args!.documents,
              )),
        );

      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUp());

      case '/signIn':
        return MaterialPageRoute(builder: (context) => SignIn());

      case '/homePage':
        return MaterialPageRoute(builder: (context) => HomePage());

      case '/adminPanel':
        return MaterialPageRoute(builder: (context) => AdminPanel());

      case '/popularitems':
        return MaterialPageRoute(builder: (context) => Popularitems());

      case '/specialItems':
        return MaterialPageRoute(builder: (context) => Specialitems());

      case '/resetPassword':
        return MaterialPageRoute(builder: (context) => PasswordReset());

      case '/productPage':
        return MaterialPageRoute(builder: (context) => ProductPage());

      case '/productDetails':
        ProductDetails? args = settings.arguments as ProductDetails?;
        return MaterialPageRoute(
          builder: (context) => ProductDetails(
            heroTag: args!.heroTag,
            name: args.name,
            price: args.price,
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (BuildContext builder) {
        return Scaffold(
          appBar: AppBar(
            title: Text("404 Error"),
          ),
          body: Center(
            child: Text("Page not found....."),
          ),
        );
      },
    );
  }
}
