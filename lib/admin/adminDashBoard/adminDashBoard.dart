import 'package:flutter/material.dart';
import 'package:shop_app/admin/adminDashBoard/OrdersChart.dart';
import 'package:shop_app/admin/adminDashBoard/salesThumnail.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dash Board"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                OrderThumbnail(),
                SalesThumbnail(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
