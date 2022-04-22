import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/pages/homepage/homePage.dart';
import 'package:shop_app/utils/widgets.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final HomeContent widget;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: structurePageHomePage(
        Container(
          height: widget.size.height * 0.15,
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              customContainers(
                  context,
                  " A Summer Suprise",
                  "Cash Back 20%",
                  "Order any food from the app and get discount",
                  Color(0xFF40BF73),
                  'assets/images/price-tag.svg'),
              SizedBox(width: widget.size.width * 0.030),
              customContainers(
                  context,
                  " A Summer Suprise",
                  "Deal of the Day",
                  "Wanna know what special deal is here for you today?",
                  Color.fromARGB(255, 115, 201, 150),
                  'assets/images/deal.svg'),
            ],
          ),
        ),
      ),
    );
  }

  Container customContainers(BuildContext context, String title,
      String subTitle, String content, Color color, String image) {
    return Container(
      height: widget.size.height * 0.20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: widget.size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  image,
                  height: 80,
                  width: 80,
                ),
                SizedBox(width: widget.size.width * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(fontSize: 26.0, color: Colors.white),
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: widget.size.width * 0.50),
                      child: Text(
                        content,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
