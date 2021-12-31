import 'package:flutter/material.dart';

class IconWidget {
  IconData icon;
  String name;

  IconWidget({
    this.icon,
    this.name,
  });
}

final starchyFood =
    IconWidget(icon: Icons.card_giftcard_outlined, name: "Starchy Food");

final protein = IconWidget(icon: Icons.card_giftcard_outlined, name: "Protein");
final fruits =
    IconWidget(icon: Icons.card_giftcard_outlined, name: "Fruits and Veg");

final dairy = IconWidget(icon: Icons.card_giftcard_outlined, name: "Dairy");

final more = IconWidget(icon: Icons.card_giftcard_outlined, name: "More");

List iconItems = [
  starchyFood,
  protein,
  fruits,
  dairy,
  more,
];
