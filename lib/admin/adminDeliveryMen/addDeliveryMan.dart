import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/admin/Admin%20Authentication/adminAuthentication.dart';
import 'package:shop_app/admin/adminUtils.dart';
import 'package:shop_app/utils/widgets.dart';

class AddDeliveryMen extends StatefulWidget {
  const AddDeliveryMen({Key? key, this.tabController}) : super(key: key);

  final tabController;

  @override
  State<AddDeliveryMen> createState() => _AddDeliveryMenState();
}

class _AddDeliveryMenState extends State<AddDeliveryMen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController confirmDialog = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<FormState> _confirmPasswordDialogKey = GlobalKey<FormState>();
  bool isloading = false;
  bool _obscureText = true;
  var encrpytedPassword;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharePreferenceData;
  }

  get getSharePreferenceData async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() => encrpytedPassword = sharedPreferences.getString("password"));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 30.0),
        child: adminDeliveryManBody(context, size),
      ),
    );
  }

  Form adminDeliveryManBody(BuildContext context, Size size) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            decoration: adminTextField(context, "Enter Email"),
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value!.isEmpty || !value.contains("@")
                ? 'Enter a valid email address'
                : null,
          ),
          SizedBox(height: size.height * 0.05),
          TextFormField(
            decoration: adminTextField(context, "Enter Name"),
            controller: nameController,
            keyboardType: TextInputType.name,
            validator: (value) => value!.isEmpty || value.length < 5
                ? 'Enter a valid name'
                : null,
          ),
          SizedBox(height: size.height * 0.05),
          TextFormField(
            decoration: adminTextField(context, "Enter Address"),
            controller: addressController,
            keyboardType: TextInputType.streetAddress,
            validator: (value) => value!.isEmpty || value.length < 7
                ? 'Enter a valid address'
                : null,
          ),
          SizedBox(height: size.height * 0.05),
          TextFormField(
            decoration: adminTextField(context, "Enter Number"),
            controller: numberController,
            keyboardType: TextInputType.number,
            validator: (value) => value!.length != 11 || value.isEmpty
                ? "Enter a valid phone number"
                : null,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
          SizedBox(height: size.height * 0.05),
          TextFormField(
            decoration: adminTextFieldForPassword(
              context,
              "Enter Password",
              IconButton(
                iconSize: 28,
                color: Theme.of(context).colorScheme.primary,
                icon: Icon(_obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility),
                onPressed: () {
                  _toggle();
                },
              ),
            ),
            obscureText: _obscureText,
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height: size.height * 0.05),
          TextFormField(
            decoration: adminTextFieldForPassword(
              context,
              "Confirm Password",
              IconButton(
                iconSize: 28,
                color: Theme.of(context).colorScheme.primary,
                icon: Icon(_obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility),
                onPressed: () {
                  _toggle();
                },
              ),
            ),
            obscureText: _obscureText,
            controller: confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height: size.height * 0.05),
          isloading
              ? Center(child: CircularProgressIndicator())
              : completedTaskButton(
                  size,
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return StatefulBuilder(
                                builder: ((context, setState) => AlertDialog(
                                      title: SingleChildScrollView(
                                        child: Text("Enter Password"),
                                      ),
                                      content: Form(
                                        key: _confirmPasswordDialogKey,
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: adminTextFieldForPassword(
                                            context,
                                            "Enter Password",
                                            IconButton(
                                              iconSize: 28,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              icon: Icon(_obscureText
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility),
                                              onPressed: () {
                                                // _toggle();
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                            ),
                                          ),
                                          obscureText: _obscureText,
                                          controller: confirmDialog,
                                          validator: (value) => value!.isEmpty
                                              ? 'Enter password'
                                              : null,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("No"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_formkey.currentState!
                                                .validate()) {
                                              var isCorrect = new DBCrypt()
                                                  .checkpw(
                                                      confirmDialog.text.trim(),
                                                      encrpytedPassword);

                                              if (isCorrect == true) {
                                                try {
                                                  if (passwordController.text ==
                                                      confirmPasswordController
                                                          .text) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    setState(() {
                                                      isloading = true;
                                                    });
                                                    var deliverySignUpObject = {
                                                      "email":
                                                          emailController.text,
                                                      "name":
                                                          nameController.text,
                                                      "password":
                                                          passwordController
                                                              .text,
                                                      "number":
                                                          numberController.text,
                                                    };

                                                    void callBack() {
                                                      setState(() {
                                                        isloading = false;
                                                        Navigator.pop(context);
                                                      });
                                                    }

                                                    AdminAuthentication()
                                                        .signUp(
                                                            context,
                                                            emailController
                                                                .text,
                                                            nameController.text,
                                                            passwordController
                                                                .text,
                                                            addressController
                                                                .text, () {
                                                      callBack();
                                                    }).then((value) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "Delivery Workers")
                                                          .add(
                                                              deliverySignUpObject);
                                                      setState(() {
                                                        isloading = false;
                                                      });
                                                      Navigator.pop(context);
                                                      this
                                                          .widget
                                                          .tabController
                                                          .animateTo((this
                                                                      .widget
                                                                      .tabController
                                                                      .index +
                                                                  1) %
                                                              2);
                                                    });
                                                  } else {
                                                    var snackBar =
                                                        snackBarWidget(
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                ConstrainedBox(
                                                                    constraints:
                                                                        BoxConstraints(
                                                                      maxWidth: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.80,
                                                                    ),
                                                                    child: Text(
                                                                        "Passwords do not match",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white))),
                                                                Icon(
                                                                  Icons
                                                                      .error_outline_sharp,
                                                                  color: Colors
                                                                      .white,
                                                                )
                                                              ],
                                                            ),
                                                            Colors.red);

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                } catch (e) {
                                                  print(e);
                                                }
                                              } else {
                                                Navigator.pop(context);
                                                var snackBar = snackBarWidget(
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.80,
                                                          ),
                                                          child: Text(
                                                            "Incorrect Password",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .error_outline_sharp,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                    Colors.red);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            }
                                          },
                                          child: isloading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Text('Proceed'),
                                        ),
                                      ],
                                    )),
                              );
                            });
                      }
                    },
                    child: Text(
                      "Create Driver",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
