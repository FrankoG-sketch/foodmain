import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

PersistentBottomSheetController<dynamic> shippingPolicy(
    BuildContext context, Size size) {
  return showBottomSheet(
    context: context,
    builder: (builder) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
            ),
            bulletins(
                "Standard Shipping: Standard shipping is typically the default checkout setting. Your item(s) are expected to be" +
                    "delivered within 3-5 business days after the items have been shipped and picked up by the delivery carrier." +
                    "Spend \$35 or more, or place your order using your REDcard and receive free standard shipping.",
                size),
            bulletins(
                "order may ship in multiple packages so we're able to deliver your order faster.",
                size),
            bulletins(
                "Some ship to home orders are eligible to have multiple packages consolidated. This may change your"
                "delivery dates. Packages that qualify will be eligible for a \$1 off discount off of merchandise subtotal."
                "Merchandise subtotal does not include Gift Cards, eGiftCards, MobileGiftCards, gift wrap, tax or shipping"
                "and handling charges. Discount will be displayed and applied at checkout. May not be applied to previous"
                "orders. Ineligible carts will not be shown an option to consolidate and will not receive the discount.",
                size),
            bulletins(
                "2-Day Shipping: Depending on the item origin and shipping destination, 2-day shipping may be available in"
                "select areas. Your item(s) are expected to be delivered within 2 business days after the items have been"
                "shipped and picked up by the delivery carrier. For eligible items, spend \$35 or more, or place your order using"
                "your REDcard and receive free 2-day shipping",
                size),
            bulletins(
                "Express Shipping: Your items) are expected to be delivered within 1 business day after the items have been"
                "shipped and picked up by the delivery carrier.",
                size),
            SizedBox(height: size.height * 0.02),
            Text(
              "PLEASE NOTE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.02),
            bulletins(
                "Business days don't typically include weekends, however Saturday deliveries may occur in select ZIP codes.",
                size),
            bulletins(
                "Some items may not be eligible for 2-day or express shipping due to size, weight, quantities, delivery address or"
                "vendor constraints.",
                size),
            bulletins(
                "Shipping charges for Express shipping are calculated on a 'per order' basis, including shipping, order"
                "processing, item selection and packaging costs, and will only apply to the items using these shipping speeds.",
                size),
            bulletins(
                "most items ship within 24 hours, some vendors and shipping locations may require additional processing"
                "time. This processing time is factored into the estimated delivery date shown at checkout.",
                size),
            SizedBox(height: size.height * 0.10),
          ],
        ),
      );
    },
  );
}

Widget bulletins(String text, size) {
  return Wrap(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text('')),
            Expanded(child: Text("•")),
            Expanded(flex: 10, child: Text(text)),
            Expanded(flex: 2, child: Text(''))
          ],
        ),
      )
    ],
  );
}

class DeleteOption extends StatefulWidget {
  final DocumentSnapshot? document;
  DeleteOption({this.document});
  @override
  _DeleteOptionState createState() => _DeleteOptionState();
}

class _DeleteOptionState extends State<DeleteOption>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontFamily: 'PlayfairDisplay'),
        ));
    Widget okButton = TextButton(
      onPressed: () {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot =
              await transaction.get(widget.document!.reference);
          transaction.delete(snapshot.reference);
          Fluttertoast.showToast(
              msg: 'Item removed', toastLength: Toast.LENGTH_SHORT);
          Navigator.pop(context);
        }).catchError(
          (onError) {
            print("Error");
            Fluttertoast.showToast(
                msg: "Item failed to remove from cart,"
                    " please check internet connection.",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.grey[700],
                textColor: Colors.grey[50],
                gravity: ToastGravity.CENTER);
            Navigator.pop(context);
          },
        );
      },
      child: Text("Ok", style: TextStyle(fontFamily: 'PlayfairDisplay')),
    );

    return AlertDialog(
      title: Text(
        "Remove Item from Cart?",
      ),
      content: Text(
        "Are you sure you want to remove this item from your cart?",
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );
  }
}
