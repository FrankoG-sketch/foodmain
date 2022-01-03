import 'package:flutter/material.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/utils/widgets.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _errorMessage = '';
  TextEditingController _email = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(alignment: Alignment.center, children: [
        BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(Icons.chevron_left),
                        color: Colors.white,
                        iconSize: 40.0,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Center(
                    child: Text(
                      "Enter the account email you want to reset",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'PlayfairDisplay-Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  indent: 50,
                  endIndent: 50,
                ),
                new Form(
                  key: _formkey,
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new TextFormField(
                              decoration: textFieldInputDecoration(
                                  context, "Enter Your Email Address: "),
                              validator: (value) => value.isEmpty ||
                                      !value.contains("@") ||
                                      !value.contains(".com")
                                  ? "Enter a valid email address"
                                  : null,
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            new Padding(
                                padding: const EdgeInsets.only(top: 40.0)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 90.0),
                              child: isloading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: new MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                        child: new Text(
                                          "Reset",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formkey.currentState
                                              .validate()) {
                                            setState(() => isloading = true);

                                            void callBack() {
                                              setState(() {
                                                isloading = false;
                                              });
                                            }

                                            dynamic result = Authentication()
                                                .reset(
                                                    context,
                                                    _email.text.trim(),
                                                    callBack);
                                            if (result == null) {
                                              setState(() => isloading = false);
                                            }
                                          }
                                        },
                                        splashColor: Colors.white,
                                      ),
                                    ),
                            ),
                            Text(
                              _errorMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
