import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/utils/widgets.dart';
import '../../Authentication/auth.dart';

class DeliveryProfile extends StatefulWidget {
  final Size size;
  const DeliveryProfile({Key? key, required this.size}) : super(key: key);

  @override
  State<DeliveryProfile> createState() => _DeliveryProfileState();
}

class _DeliveryProfileState extends State<DeliveryProfile> {
  String email = '';

  String name = '';

  bool isloading = false;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  User user = FirebaseAuth.instance.currentUser!;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "User Profile",
          ),
          backgroundColor: Theme.of(context).primaryColor),
      body: FutureBuilder(
        future: getCurrentUID(),
        builder: (context, AsyncSnapshot snapshot) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(snapshot.data)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                Center(child: CircularProgressIndicator());
              else if (snapshot.connectionState == ConnectionState.active)
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(75.0)),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 50,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return ProfilePhotoPopUp();
                                  },
                                ),
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: SizedBox(
                                        width: 180.0,
                                        height: 180.0,
                                        child: Image(
                                          image: NetworkImage(
                                            "${snapshot.data!['imgUrl']}",
                                          ),
                                          loadingBuilder:
                                              (context, child, progress) {
                                            return progress == null
                                                ? child
                                                : CircularProgressIndicator();
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                                "images/blankprofile.png");
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: new ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    new Text(
                                      "Name",
                                      style: TextStyle(
                                        fontFamily: 'PlayfairDisplay-Regular',
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Icon(Icons.edit),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: InkWell(
                                onTap: () async {
                                  await nameModalBottomSheet(context, snapshot);
                                },
                                child: new ListTile(
                                  title: new Text(
                                    snapshot.data!['FullName'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlayfairDisplay',
                                    ),
                                  ),
                                  leading: new Icon(
                                    Icons.account_circle,
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              indent: 50.0,
                              endIndent: 50.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: new ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    new Text(
                                      "Email",
                                      style: TextStyle(
                                        fontFamily: 'PlayfairDisplay-Regular',
                                      ),
                                    ),
                                    SizedBox(width: 150),
                                    Icon(Icons.edit),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: InkWell(
                                onTap: () async {
                                  await openDialog(context, snapshot);
                                },
                                child: new ListTile(
                                  title: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              100,
                                    ),
                                    child: new Text(
                                      snapshot.data!['email'],
                                      style: TextStyle(
                                          fontFamily: 'PlayfairDisplay',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  leading: new Icon(Icons.alternate_email),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Divider(
                                color: Colors.grey,
                                indent: 50.0,
                                endIndent: 50.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }

  nameModalBottomSheet(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    "Enter your name",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enabled: !isloading,
                        decoration:
                            textFieldInputDecoration(context, "Enter Name"),
                        initialValue: "${snapshot.data['FullName']}",
                        validator: (value) => value!.isEmpty || value.length < 3
                            ? "Enter a valid name"
                            : null,
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp('[0-9.,]+-*/!@#\$%^&*()=-_'),
                          )
                        ],
                        onSaved: (value) => name = value!.trim(),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey1.currentState!.validate()) {
                          try {
                            _formKey1.currentState!.save();
                            print("name: " + name);

                            var date = DateTime.now();
                            var uid = await getCurrentUID();

                            User user = FirebaseAuth.instance.currentUser!;

                            user.updateDisplayName(name).then((value) {
                              user.reload();

                              print("Current User: ${user.displayName}");

                              print("Name Updated Successfully");
                            }).catchError(
                              (onError) {
                                print("Error occured while trying"
                                    " to updated name");
                              },
                            );

                            var updatedDetails = {
                              "FullName": name,
                              "Date edited": date,
                              "uid": uid,
                            };

                            FirebaseFirestore.instance
                                .collection("User_Updated_Credentials")
                                .doc(uid)
                                .collection("User_Changes")
                                .add(updatedDetails);

                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(user.uid)
                                .update({
                              "FullName": name,
                            }).then((value) {
                              Fluttertoast.showToast(msg: "Name Updated");
                              Navigator.of(context).pop();
                            }).catchError(
                              (onError) {
                                print(onError);
                                Fluttertoast.showToast(msg: "Profile Updated");
                                Navigator.of(context).pop();
                              },
                            );
                          } catch (e) {
                            print(e.toString());
                            Fluttertoast.showToast(
                                msg: "Error occured while"
                                    " trying to perform task");
                          }
                        }
                      },
                      child: Text("Ok"),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  openDialog(BuildContext context, AsyncSnapshot<dynamic> snapshot) async {
    showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text("Password Required"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: textFieldInputDecorationForLoginPagePassword(
                      context,
                      "Enter Password",
                      IconButton(
                        iconSize: 28,
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icon(_obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () => _toggle(),
                          );
                        },
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Check Password' : null,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    controller: passwordController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  DBCrypt dBCrypt = DBCrypt();
                  var encrpytedPassword = prefs.get("password");

                  if (dBCrypt.checkpw(passwordController.text.trim(),
                      encrpytedPassword.toString().trim())) {
                    Navigator.pop(context);
                    _changeEmail(context, snapshot);
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());

                    var snackBar = snackBarWidget(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.80,
                              ),
                              child: Text(
                                "Password Incorrect",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Icon(
                              Icons.error_outline_sharp,
                              color: Colors.white,
                            )
                          ],
                        ),
                        Colors.red);

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text("Ok"),
              ),
            ],
          ),
        );
      },
    );
  }

  _changeEmail(BuildContext context, AsyncSnapshot<dynamic> snapshot) async {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    "Enter your email",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35.0, 25.0, 35.0, 0),
                  child: Form(
                    key: _formKey2,
                    child: TextFormField(
                      enabled: !isloading,
                      decoration:
                          textFieldInputDecoration(context, "Enter Email"),
                      initialValue: "${snapshot.data['email']}",
                      validator: (value) =>
                          value!.isEmpty ? "Enter Valid Email Address" : null,
                      onSaved: (value) => email = value!.trim(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              title: Text("Change Account Email?"),
                              content: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text:
                                            "After changing your account email,"),
                                    new TextSpan(
                                      text: " ${snapshot.data!['email']} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    new TextSpan(
                                        text:
                                            "will no longer be the required email to be used."),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (_formKey2.currentState!.validate()) {
                                      try {
                                        _formKey2.currentState!.save();
                                        print("Email" + email);

                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        var date = DateTime.now();
                                        var uid = await getCurrentUID();

                                        User user =
                                            FirebaseAuth.instance.currentUser!;

                                        user
                                            .updateEmail(email)
                                            .then((value) => () {
                                                  user.reload();

                                                  print(
                                                      "Current User: ${user.email}");

                                                  print("Email Updated"
                                                      " Successfully");
                                                })
                                            .catchError(
                                          (onError) {
                                            print("Error occured While"
                                                " trying to update email");
                                          },
                                        );

                                        var updatedDetails = {
                                          "email": email,
                                          "date": date,
                                          "uid": uid
                                        };

                                        FirebaseFirestore.instance
                                            .collection(
                                                "User_Updated_Credentials")
                                            .doc(uid)
                                            .collection("User_Changes")
                                            .add(updatedDetails);

                                        prefs.setString('email', email);

                                        FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(user.uid)
                                            .update(
                                          {
                                            "email": email,
                                          },
                                        ).then(
                                          (value) {
                                            Fluttertoast.showToast(
                                                msg: "Email Updated");
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        ).catchError(
                                          (onError) {
                                            print(onError);
                                            Fluttertoast.showToast(
                                                msg: "Email Updated");
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Error occured While trying to complete task ");
                                        print(
                                          e.toString(),
                                        );
                                      }
                                    }
                                  },
                                  child: Text("Ok"),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Ok"),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfilePhotoPopUp extends StatefulWidget {
  final DocumentSnapshot? document;
  const ProfilePhotoPopUp({Key? key, this.document}) : super(key: key);

  @override
  State<ProfilePhotoPopUp> createState() => _ProfilePhotoPopUpState();
}

class _ProfilePhotoPopUpState extends State<ProfilePhotoPopUp> {
  User user = FirebaseAuth.instance.currentUser!;
  late File _image;

  File? cropped;

  File? uploadThisImage;

  final picker = ImagePicker();

  var pickedFile;
  var path;
  dynamic url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentUID(),
      builder: (context, AsyncSnapshot snapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(snapshot.data)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null)
              return Center(child: CircularProgressIndicator());

            var userDocument = snapshot.data;

            var netImage = userDocument['imgUrl'];

            var defaultImage =
                "https://firebasestorage.googleapis.com/v0/b/jmarket-9aa0f.appspot.com/o/profile.png?alt=media&token=43d9378c-3f32-4cf8-b726-1a35f8e18f46";

            uploadPic(File uploadThisImage) async {
              try {
                var uid = await getCurrentUser();

                FirebaseStorage storage = FirebaseStorage.instance;

                if (path != null) {
                  print('file path no equal to null');
                  try {
                    print("uploaded started");
                    FirebaseStorage.instance
                        .ref()
                        .child(userDocument['path'])
                        .delete();
                    Reference ref = storage.ref().child(
                        "Profile_Photos/$uid" + DateTime.now().toString());
                    UploadTask uploadTask = ref.putFile(uploadThisImage);

                    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                      print('Snapshot state: ${snapshot.state}');
                      print(
                          'Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
                    }, onError: (Object e) {
                      print('error: $e');
                    });

                    await uploadTask.whenComplete(() async {
                      url = await ref.getDownloadURL();

                      path = ref.fullPath;

                      var imageObject = {
                        "imgUrl": url,
                        "path": path,
                      };
                      widget.document == null
                          ? FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user.uid)
                              .update({"imgUrl": url, "path": path}).then(
                                  (value) async {
                              Fluttertoast.showToast(
                                  msg: 'Profile Picture Saved');
                              Navigator.pop(context);

                              await user.updatePhotoURL(url);
                              await user.reload();
                            })
                          : FirebaseFirestore.instance
                              .runTransaction((transaction) async {
                              DocumentSnapshot snapshot = await transaction
                                  .get(widget.document!.reference);
                              transaction.update(
                                  snapshot.reference, imageObject);
                              Fluttertoast.showToast(
                                  msg: 'Your profile image has been updated');

                              await user.updatePhotoURL(url);
                              await user.reload();
                            });
                      print("Upload Completed");
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                } else {
                  Reference ref = storage
                      .ref()
                      .child("Profile_Photos/$uid" + DateTime.now().toString());
                  UploadTask uploadTask = ref.putFile(uploadThisImage);

                  uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                    print('Snapshot state: ${snapshot.state}');
                    print(
                        'Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
                  }, onError: (Object e) {
                    print(e);
                  });

                  await uploadTask.whenComplete(() async {
                    url = await ref.getDownloadURL();

                    path = ref.fullPath;

                    var imageObject = {
                      "imgUrl": url,
                      "path": path,
                    };
                    widget.document == null
                        ? FirebaseFirestore.instance
                            .collection("Users")
                            .doc(user.uid)
                            .update({"imgUrl": url, "path": path}).then(
                                (value) async {
                            Fluttertoast.showToast(
                                msg: 'Profile Picture Saved');
                            Navigator.pop(context);

                            await user.updatePhotoURL(url);
                            await user.reload();
                          })
                        : FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                            DocumentSnapshot snapshot = await transaction
                                .get(widget.document!.reference);
                            transaction.update(snapshot.reference, imageObject);
                            Fluttertoast.showToast(
                                msg: 'Your profile image has been updated');

                            await user.updatePhotoURL(url);
                            await user.reload();
                          });
                    print("Upload Completed");
                  });
                  // await user.updatePhotoURL(url);
                  // await user.reload();
                }
              } catch (e) {
                print(e.toString());
              }
              return url;
            }

            _cropImage(File _image) async {
              ImageCropper cropper = ImageCropper();
              var cropped = await cropper.cropImage(
                sourcePath: _image.path,
                maxHeight: 700,
                maxWidth: 700,
                compressFormat: ImageCompressFormat.jpg,
                aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                androidUiSettings: AndroidUiSettings(
                    toolbarTitle: 'Image Cropper',
                    toolbarColor: Theme.of(context).primaryColor,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false),
                iosUiSettings: IOSUiSettings(
                  title: 'Image Cropper',
                ),
              );

              setState(() {
                if (cropped != null) {
                  uploadThisImage = cropped;
                }
              });
              uploadPic(uploadThisImage!);
            }

            void _openGallery(BuildContext context) async {
              pickedFile = await picker.pickImage(source: ImageSource.gallery);

              setState(() {
                if (pickedFile != null) {
                  _image = File(pickedFile.path);
                  _cropImage(_image);
                } else {
                  print('No image selected.');
                }
              });
              Navigator.of(context).pop();
            }

            void _openCamera(BuildContext context) async {
              pickedFile = await picker.pickImage(source: ImageSource.camera);

              setState(() {
                if (pickedFile != null) {
                  _image = File(pickedFile.path);
                  _cropImage(_image);
                } else {
                  print('No image selected.');
                }
              });
              Navigator.of(context).pop();
            }

            Widget cancelButton(BuildContext context) {
              return TextButton(
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            }

            Widget okButton(BuildContext context) {
              return TextButton(
                child: Text(
                  "Ok",
                ),
                onPressed: () async {
                  try {
                    var userDocument = snapshot.data;

                    FirebaseStorage.instance
                        .ref()
                        .child(userDocument['path'])
                        .delete();

                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user.uid)
                        .update({"imgUrl": defaultImage, "path": null});

                    await user.updatePhotoURL(defaultImage);
                    await user.reload();

                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: 'Profile picture removed',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  } catch (e) {
                    print(e.toString());
                    Fluttertoast.showToast(
                        msg: "${e.toString()}",
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey[700],
                        textColor: Colors.grey[50],
                        gravity: ToastGravity.CENTER);
                    Navigator.of(context).pop();
                  }
                },
              );
            }

            void _showDialog() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text(
                      "Remove Profile Photo",
                    ),
                    content: Text(
                      "Are you sure you want to " +
                          "permanently remove profile photo?",
                    ),
                    actions: <Widget>[
                      cancelButton(context),
                      okButton(context),
                    ],
                  );
                },
              );
            }

            _removePhoto(BuildContext context) {
              _showDialog();
            }

            Widget _buildOptions() {
              return netImage == defaultImage
                  ? Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo_album_rounded),
                          onTap: () => _openGallery(context),
                          title: Text(
                            "Choose From Gallery",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_alt_rounded),
                          onTap: () => _openCamera(context),
                          title: Text("Open Camera"),
                        ),
                      ],
                    )
                  : Wrap(
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo_album_rounded),
                          onTap: () => _openGallery(context),
                          title: Text(
                            "Choose From Gallery",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_alt_rounded),
                          onTap: () => _openCamera(context),
                          title: Text("Open Camera"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          onTap: () => _removePhoto(context),
                          title: Text("Remove Photo"),
                        ),
                      ],
                    );
            }

            Future<void> _showSelectionDialog(BuildContext context) {
              return showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return _buildOptions();
                },
              );
            }

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  "Profile Photo",
                  style: TextStyle(
                      fontFamily: "PlayfairDisplay",
                      fontSize: 20,
                      color: Colors.white),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showSelectionDialog(context),
                  ),
                ],
              ),
              backgroundColor: Colors.black,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      width: double.infinity,
                      child: Image(
                        image: NetworkImage(
                          "${snapshot.data['imgUrl']}",
                        ),
                        loadingBuilder: (context, child, progress) {
                          return progress == null
                              ? child
                              : CircularProgressIndicator();
                        },
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset("images/blankprofile.png");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
