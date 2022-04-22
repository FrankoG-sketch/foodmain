import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/utils/widgets.dart';

class Services extends StatelessWidget {
  const Services({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          InkWell(
            onTap: (() => Navigator.pushNamed(context, '/shippingPolicy')),
            child: sliverListElements(
              context,
              "assets/images/delivery.svg",
              "Delivery Services",
              "We will deliver your shopping list directly to you.",
              Theme.of(context).primaryColor.withAlpha(150),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/feedBack'),
            child: sliverListElements(
                context,
                "assets/images/warning.svg",
                "An Issue?",
                "Don't hesitate to get in touch with us.",
                Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  Padding sliverListElements(
      BuildContext context, image, title, subTitle, color) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: [
          Container(
            height: size.height * 0.10,
            width: size.width * 0.90,
            child: Container(
              width: size.height * 0.40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        image,
                        width: 60,
                        height: 60,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 200,
                            ),
                            child: Text(
                              subTitle,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceHeader extends StatelessWidget {
  const ServiceHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: structurePageHomePage(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Services",
              style: TextStyle(fontSize: 19.0),
            ),
          ],
        ),
      ),
    );
  }
}
