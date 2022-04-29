import 'package:flutter/material.dart';
import 'package:shop_app/deliverPanel/deliveryHomePage.dart/deliveryHomePage.dart';
import 'package:shop_app/deliverPanel/deliveryPanelProfilePage/deliveryProfilePage.dart';
import 'package:shop_app/utils/jam_icons_icons.dart';

class DeliveryPanel extends StatefulWidget {
  const DeliveryPanel({Key? key}) : super(key: key);

  @override
  State<DeliveryPanel> createState() => _DeliveryPanelState();
}

class _DeliveryPanelState extends State<DeliveryPanel> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  void _onTap(int value) {
    setState(() {
      _currentIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "",
            icon: Icon(JamIcons.home),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(JamIcons.profile),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          DeliveryHomePage(size: size),
          DeliveryProfile(size: size),
        ],
      ),
    );
  }
}
