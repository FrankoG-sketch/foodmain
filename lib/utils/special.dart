class Special {
  String imgPath;

  Special({
    this.imgPath,
  });
}

final special1 = Special(imgPath: "assets/images/special_1.jpg");
final special2 = Special(imgPath: "assets/images/special_2.jpg");
final special3 = Special(imgPath: "assets/images/special_3.png");

List specialImagePaths = [special1, special2, special3];
