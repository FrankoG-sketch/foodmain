class SharedPreferencesNames {
  static const String selectedStore = 'selectedStore',
      email = 'email',
      role = 'role',
      address = 'address',
      name = 'name',
      password = 'password';
}

class RouteNames {
  static const String adminDashBoard = 'adminDashBoard',
      editDeliveryReview = "editDeliveryReview",
      createDeliveryReview = "createDeliveryReview",
      deliveryWorkerRatings = "deliveryWorkerRatings",
      adminAddSupermarket = "adminAddSupermarket",
      editRating = "editRating",
      viewProductRatings = "viewProductRatings",
      productRatings = "productRatings",
      viewClients = "viewClients",
      adminFeedBack = "adminFeedBack",
      feedBack = "feedBack",
      shippingPolicy = "shippingPolicy",
      adminFoodFilter = "adminFoodFilter",
      dairy = "dairy",
      starch = "starch",
      protein = "protein",
      fruitsAndVeg = "fruits&Veg",
      allFoods = "allFoods",
      deliveryOrders = "deliveryOrders",
      profile = "profile",
      deliveryProfilePage = "deliveryProfilePage",
      adminInvertory = "adminInvertory",
      adminPanelDeliveryView = "adminPanelDeliveryView",
      deliveryWorkers = "deliveryWorkers",
      foodFilterData = "foodFilterData",
      foodFilter = "foodFilter",
      registerAddress = "registerAddress",
      deliveryPanel = "deliveryPanel",
      delieveryCheckOut = "delieveryCheckOut",
      signUp = "signUp",
      signIn = "signIn",
      homePage = "homePage",
      adminPanel = "adminPanel",
      popularitems = "popularitems",
      specialItems = "specialItems",
      resetPassword = "resetPassword",
      productPage = "productPage",
      productDetails = "productDetails";
}

class OrderStatus {
  static const String Arrived = 'Arrived',
      Shipped = 'Shipped',
      pending = 'pending';
  static const List<String> statusList = [Arrived, Shipped, pending];
}
