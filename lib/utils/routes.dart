import 'package:flutter/material.dart';
import 'package:shop_app/admin/AdminDeliveryList/adminDelivery.dart';
import 'package:shop_app/admin/adminClientView/adminViewClient.dart';
import 'package:shop_app/admin/adminDeliveryMen/adminDeliveryMen.dart';
import 'package:shop_app/admin/adminFeedBack/adminFeedBack.dart';
import 'package:shop_app/admin/adminFoodFilter/adminFoodFilter.dart';
import 'package:shop_app/admin/adminHomePage/adminHomePage.dart';
import 'package:shop_app/admin/adminInventoryPage/inventoryPage.dart';
import 'package:shop_app/admin/adminSupermarket/adminSupermarket.dart';
import 'package:shop_app/deliverPanel/delivery.dart';
import 'package:shop_app/deliverPanel/deliveryPanelProfilePage/deliveryProfilePage.dart';
import 'package:shop_app/pages/Popular_items.dart';
import 'package:shop_app/pages/delivery%20workers/createReview.dart';
import 'package:shop_app/pages/delivery%20workers/deliveryWorkerRatings.dart';
import 'package:shop_app/pages/delivery%20workers/deliveryWorkers.dart';
import 'package:shop_app/pages/delivery%20workers/editReview.dart';
import 'package:shop_app/pages/deliveryCheckOut.dart';
import 'package:shop_app/pages/editRating/editRatings.dart';
import 'package:shop_app/pages/feedBack/feedBack.dart';
import 'package:shop_app/pages/food%20filter/foodFilter.dart';
import 'package:shop_app/pages/homepage/homePage.dart';
import 'package:shop_app/pages/iconWidgetPages/All.dart';
import 'package:shop_app/pages/iconWidgetPages/Diary.dart';
import 'package:shop_app/pages/iconWidgetPages/FruitsVeg.dart';
import 'package:shop_app/pages/iconWidgetPages/protein.dart';
import 'package:shop_app/pages/iconWidgetPages/starch.dart';
import 'package:shop_app/pages/passwordReset.dart';
import 'package:shop_app/pages/product%20ratings/productRatings.dart';
import 'package:shop_app/pages/productDetails.dart';
import 'package:shop_app/pages/productPage.dart';
import 'package:shop_app/pages/profile/profile.dart';
import 'package:shop_app/pages/registerAddress/registerAddress.dart';
import 'package:shop_app/pages/sign%20up/signUp.dart';
import 'package:shop_app/pages/sign%20in/signIn.dart';
import 'package:shop_app/pages/special_items.dart';
import 'package:shop_app/pages/view%20ratings/viewRatings.dart';
import 'package:shop_app/utils/ShippingPolicy.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/editDeliveryReview':
        EditReview? args = settings.arguments as EditReview?;
        return MaterialPageRoute(
            builder: ((context) => EditReview(
                  reviewDeliveryPersonnel: args!.reviewDeliveryPersonnel,
                  heroTag: args.heroTag,
                )));
      case '/createDeliveryReview':
        CreateDeliveryReview? args =
            settings.arguments as CreateDeliveryReview?;
        return MaterialPageRoute(
          builder: ((context) => CreateDeliveryReview(
                imgUrl: args!.imgUrl,
                name: args.name,
              )),
        );

      case '/deliveryWorkerRatings':
        DeliveryWorkerRatings? args =
            settings.arguments as DeliveryWorkerRatings?;
        return MaterialPageRoute(
          builder: ((context) => DeliveryWorkerRatings(
                address: args!.address,
                email: args.email,
                imgUrl: args.imgUrl,
                name: args.name,
              )),
        );

      case '/adminAddSupermarket':
        return MaterialPageRoute(builder: (context) => AdminSupermarket());

      case '/editRating':
        EditRatings? args = settings.arguments as EditRatings?;
        return MaterialPageRoute(
          builder: ((context) => EditRatings(
                review: args!.review,
                heroTag: args.heroTag,
              )),
        );

      case '/viewProductRatings':
        ViewProductRatings? args = settings.arguments as ViewProductRatings?;
        return MaterialPageRoute(
            builder: ((context) => ViewProductRatings(
                  productName: args!.productName,
                  heroTag: args.heroTag,
                )));
      case '/productRatings':
        ProductRatings? args = settings.arguments as ProductRatings?;
        return MaterialPageRoute(
            builder: ((context) => ProductRatings(
                  productName: args!.productName,
                  rating: args.rating,
                  heroTag: args.heroTag,
                )));
      case '/viewClients':
        return MaterialPageRoute(builder: ((context) => ViewClients()));
      case '/adminFeedBack':
        return MaterialPageRoute(builder: ((context) => AdminFeedBack()));
      case '/feedBack':
        return MaterialPageRoute(builder: ((context) => FeedBackHelp()));
      case '/shippingPolicy':
        return MaterialPageRoute(builder: ((context) => ShippingPolicy()));

      case '/adminFoodFilter':
        return MaterialPageRoute(builder: (((context) => AdminFoodFiler())));
      case '/diary':
        return MaterialPageRoute(builder: ((context) => Diary()));

      case '/starch':
        return MaterialPageRoute(builder: ((context) => Starch()));

      case '/protein':
        return MaterialPageRoute(builder: ((context) => Protein()));

      case '/fruits&Veg':
        return MaterialPageRoute(builder: ((context) => FruitsAndVeg()));

      case '/allFoods':
        return MaterialPageRoute(builder: ((context) => AllFoods()));

      case '/deliveryOrders':
        return MaterialPageRoute(builder: (context) => AdminDeliveryList());

      case '/profile':
        return MaterialPageRoute(builder: (((context) => Profile())));

      case '/deliveryProfilePage':
        DeliveryProfile? args = settings.arguments as DeliveryProfile?;
        return MaterialPageRoute(
          builder: ((context) => DeliveryProfile(size: args!.size)),
        );

      case '/adminInvertory':
        return MaterialPageRoute(builder: (((context) => Inventory())));

      case '/adminPanelDeliveryView':
        return MaterialPageRoute(builder: ((context) => AdminDeliveryMen()));

      case '/deliveryWorkers':
        return MaterialPageRoute(builder: ((context) => DeliveryWorkers()));

      case '/foodFilterData':
        return MaterialPageRoute(
          builder: (((context) => FilterFoodData())),
        );

      case '/foodFilter':
        return MaterialPageRoute(builder: (((context) => FoodFilter())));

      case '/registerAddress':
        return MaterialPageRoute(builder: (((context) => RegisterAddress())));

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
            rating: args.rating,
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

class RouteNames {
  static const String editDeliveryReview = 'editDeliveryReview';
}
