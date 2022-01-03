import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shop_app/Authentication/auth.dart';
import 'package:shop_app/utils/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  ]);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  TextEditingController _email = TextEditingController();
  TextEditingController _fullname = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _address = TextEditingController();
  bool isloading = false;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          BackgroundImage(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              // reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50.0,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          iconSize: 40.0,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Text(
                      "Fill out Registration Form",
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay-Regular',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    endIndent: 50,
                    indent: 50,
                  ),
                  new Form(
                    key: _formKey,
                    child: new Container(
                      padding: const EdgeInsets.all(40.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new TextFormField(
                                decoration: textFieldInputDecoration(
                                    context, "Enter Your Full Name"),
                                validator: (value) => value.isEmpty
                                    ? 'Name Cannot be empty'
                                    : null,
                                controller: _fullname,
                                // onSaved: (value) => _fullname = value!.trim(),
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 15.0),
                              new TextFormField(
                                decoration: textFieldInputDecoration(
                                    context, "Enter Your Email Address:"),
                                validator: (value) =>
                                    value.isEmpty || !value.contains("@")
                                        ? 'Enter a valid email address'
                                        : null,
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 15.0),
                              new TextFormField(
                                decoration: textFieldInputDecoration(
                                    context, "Enter Your Address:"),
                                validator: (value) => value.isEmpty
                                    ? 'Enter a valid address'
                                    : null,
                                controller: _address,
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(height: 15.0),
                              new TextFormField(
                                decoration:
                                    textFieldInputDecorationForLoginPagePassword(
                                  context,
                                  "Enter Password",
                                  IconButton(
                                    iconSize: 28,
                                    color: Theme.of(context).primaryColor,
                                    icon: Icon(_obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility),
                                    onPressed: () {
                                      _toggle();
                                    },
                                  ),
                                ),
                                validator: passwordValidator,
                                controller: _password,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText,
                              ),
                              SizedBox(height: 15.0),
                              new TextFormField(
                                decoration:
                                    textFieldInputDecorationForLoginPagePassword(
                                  context,
                                  "Confirm Password",
                                  IconButton(
                                    iconSize: 28,
                                    color: Theme.of(context).primaryColor,
                                    icon: Icon(_obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility),
                                    onPressed: () {
                                      _toggle();
                                    },
                                  ),
                                ),
                                validator: (value) => MatchValidator(
                                        errorText: 'Passwords do not match')
                                    .validateMatch(value, _password.text),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText,
                              ),
                              new Padding(
                                  padding: const EdgeInsets.only(top: 30.0)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 90.0),
                                child: isloading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: MaterialButton(
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              if (mounted) {
                                                setState(
                                                    () => isloading = true);
                                              }
                                              void callBack() {
                                                setState(() {
                                                  isloading = false;
                                                });
                                              }

                                              dynamic result = Authentication()
                                                  .signUp(
                                                      context,
                                                      _email.text.trim(),
                                                      _fullname.text.trim(),
                                                      _password.text.trim(),
                                                      _address.text,
                                                      callBack);

                                              if (result == null) {
                                                setState(
                                                    () => isloading = false);
                                              }
                                            }
                                          },
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          child: new Text("Sign Up",
                                              style: TextStyle(
                                                  color: Colors.white)),
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
        ],
      ),
    );
  }
}
