import 'package:flutter/material.dart';
import 'package:shop_app/Model/CartModel.dart';
import 'package:shop_app/admin/AdminDeliveryList/adminDelivery.dart';
import 'package:shop_app/admin/adminActiveOrders/activeOrders.dart';
import 'package:shop_app/admin/adminClientView/adminViewClient.dart';
import 'package:shop_app/admin/adminDashBoard/adminDashBoard.dart';
import 'package:shop_app/admin/adminDeliveryMen/adminDeliveryMen.dart';
import 'package:shop_app/admin/adminFeedBack/adminFeedBack.dart';
import 'package:shop_app/admin/adminFoodFilter/adminFoodFilter.dart';
import 'package:shop_app/admin/adminHomePage/adminHomePage.dart';
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
import 'package:shop_app/utils/magic_strings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.adminDashBoard:
        return MaterialPageRoute(builder: ((context) => DashBoard()));
      case RouteNames.editDeliveryReview:
        EditReview? args = settings.arguments as EditReview?;
        return MaterialPageRoute(
            builder: ((context) => EditReview(
                  reviewDeliveryPersonnel: args!.reviewDeliveryPersonnel,
                  heroTag: args.heroTag,
                )));
      case RouteNames.createDeliveryReview:
        CreateDeliveryReview? args =
            settings.arguments as CreateDeliveryReview?;
        return MaterialPageRoute(
          builder: ((context) => CreateDeliveryReview(
                imgUrl: args!.imgUrl,
                name: args.name,
              )),
        );

      case RouteNames.deliveryWorkerRatings:
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

      case RouteNames.adminAddSupermarket:
        return MaterialPageRoute(builder: (context) => AdminSupermarket());

      case RouteNames.editRating:
        EditRatings? args = settings.arguments as EditRatings?;
        return MaterialPageRoute(
          builder: ((context) => EditRatings(
                review: args!.review,
                heroTag: args.heroTag,
              )),
        );

      case RouteNames.viewProductRatings:
        ViewProductRatings? args = settings.arguments as ViewProductRatings?;
        return MaterialPageRoute(
            builder: ((context) => ViewProductRatings(
                  productName: args!.productName,
                  heroTag: args.heroTag,
                )));
      case RouteNames.productRatings:
        ProductRatings? args = settings.arguments as ProductRatings?;
        return MaterialPageRoute(
            builder: ((context) => ProductRatings(
                  productName: args!.productName,
                  rating: args.rating,
                  heroTag: args.heroTag,
                )));
      case RouteNames.viewClients:
        return MaterialPageRoute(builder: ((context) => ViewClients()));
      case RouteNames.adminFeedBack:
        return MaterialPageRoute(builder: ((context) => AdminFeedBack()));
      case RouteNames.feedBack:
        return MaterialPageRoute(builder: ((context) => FeedBackHelp()));
      case RouteNames.shippingPolicy:
        return MaterialPageRoute(builder: ((context) => ShippingPolicy()));

      case RouteNames.adminFoodFilter:
        return MaterialPageRoute(builder: (((context) => AdminFoodFiler())));
      case RouteNames.dairy:
        return MaterialPageRoute(builder: ((context) => Diary()));

      case RouteNames.starch:
        return MaterialPageRoute(builder: ((context) => Starch()));

      case RouteNames.protein:
        return MaterialPageRoute(builder: ((context) => Protein()));

      case RouteNames.fruitsAndVeg:
        return MaterialPageRoute(builder: ((context) => FruitsAndVeg()));

      case RouteNames.allFoods:
        return MaterialPageRoute(builder: ((context) => AllFoods()));

      case RouteNames.deliveryOrders:
        return MaterialPageRoute(builder: (context) => AdminDeliveryList());

      case RouteNames.profile:
        return MaterialPageRoute(builder: (((context) => Profile())));

      case RouteNames.deliveryProfilePage:
        DeliveryProfile? args = settings.arguments as DeliveryProfile?;
        return MaterialPageRoute(
          builder: ((context) => DeliveryProfile(size: args!.size)),
        );

      case RouteNames.adminInvertory:
        return MaterialPageRoute(builder: (((context) => ActiveOrders())));

      case RouteNames.adminPanelDeliveryView:
        return MaterialPageRoute(builder: ((context) => AdminDeliveryMen()));

      case RouteNames.deliveryWorkers:
        return MaterialPageRoute(builder: ((context) => DeliveryWorkers()));

      case RouteNames.foodFilterData:
        return MaterialPageRoute(
          builder: (((context) => FilterFoodData())),
        );

      case RouteNames.foodFilter:
        return MaterialPageRoute(builder: (((context) => FoodFilter())));

      case RouteNames.registerAddress:
        return MaterialPageRoute(builder: (((context) => RegisterAddress())));

      case RouteNames.deliveryPanel:
        return MaterialPageRoute(builder: ((context) => DeliveryPanel()));

      case RouteNames.delieveryCheckOut:
        List<CartModel> args = settings.arguments as List<CartModel>;
        return MaterialPageRoute(
          builder: ((context) => DeliveryCheckOut(
                documents: args,
              )),
        );

      case RouteNames.signUp:
        return MaterialPageRoute(builder: (context) => SignUp());

      case RouteNames.signIn:
        return MaterialPageRoute(builder: (context) => SignIn());

      case RouteNames.homePage:
        return MaterialPageRoute(builder: (context) => HomePage());

      case RouteNames.adminPanel:
        return MaterialPageRoute(builder: (context) => AdminPanel());

      case RouteNames.popularitems:
        return MaterialPageRoute(builder: (context) => Popularitems());

      case RouteNames.specialItems:
        return MaterialPageRoute(builder: (context) => Specialitems());

      case RouteNames.resetPassword:
        return MaterialPageRoute(builder: (context) => PasswordReset());

      case RouteNames.productPage:
        return MaterialPageRoute(builder: (context) => ProductPage());

      case RouteNames.productDetails:
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
            backgroundColor: Colors.red,
          ),
          body: Center(
            child: Text("Page not found....."),
          ),
        );
      },
    );
  }
}
