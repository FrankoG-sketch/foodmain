final String imageAssetsRoot = "assets/images/";
final String image1 = _getImagePath("bread.png");
final String image2 = _getImagePath("chesse.png");
final String image3 = _getImagePath("home-pride bread.jpg");
final String image4 = _getImagePath("rice.png");
final String image5 = _getImagePath("potatoes.jpg");
final String image6 = _getImagePath("chips.jpeg");
final String logo = _getImagePath("logo.png");

String _getImagePath(String fileName) {
  return imageAssetsRoot + fileName;
}
