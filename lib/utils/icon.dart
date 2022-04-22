import 'package:flutter/material.dart';

class IconWidget {
  IconData? icon;
  String? name;
  String? tag;

  IconWidget({
    this.icon,
    this.name,
    this.tag,
  });
}

final all = IconWidget(
  icon: Icons.card_giftcard_outlined,
  name: "All",
  tag: "All",
);

final starchyFood = IconWidget(
    icon: Icons.card_giftcard_outlined, name: "Starchy\n Food", tag: "Starch");

final protein = IconWidget(
    icon: Icons.card_giftcard_outlined, name: "Protein", tag: "Protein");
final fruits = IconWidget(
    icon: Icons.card_giftcard_outlined,
    name: "Fruits and\n Veg",
    tag: "FruitsAndVeg");

final dairy =
    IconWidget(icon: Icons.card_giftcard_outlined, name: "Dairy", tag: "Diary");

List iconItems = [
  all,
  starchyFood,
  protein,
  fruits,
  dairy,
];
