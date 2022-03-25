// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:makdeck/screens/in_app_webview.dart';
import 'package:makdeck/screens/user_order_screen.dart';
import 'package:makdeck/screens/wishlist_screen.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makdeck/utils/utils.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class DrawerContainer extends StatelessWidget {
  const DrawerContainer({Key? key}) : super(key: key);

  void openMail() {
    const String email = "makdeckcare@gmail.com";
    Utils.openEmail(
      to: email,
      subject: "Query for Makdeck",
    );
  }

  showModalSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              color: kPrimaryColor,
              child: Center(
                child: Text(
                  "Connect with Makdeck",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.mail,
                color: kPrimaryColor,
              ),
              title: Text("Write to Us"),
              onTap: () {
                openMail();
                Navigator.pop(context);
              },
            ),
            Divider(),
            // ListTile(
            //   leading: Icon(
            //     Icons.phone,
            //     color: kPrimaryColor,
            //   ),
            //   title: Text("Call Us"),
            //   onTap: () async {
            //     final String phoneNumber =
            //         await CloudDatabase().getContactNumber();

            //     final url = "tel:$phoneNumber";
            //     if (await canLaunch(url)) {
            //       await launch(url);
            //     } else {
            //       throw 'Could not launch $url';
            //     }
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        );
      },
    );
  }

  void openPlayStore() {
    const String url =
        'https://play.google.com/store/apps/details?id=com.scarecrowhouse.makdeck';
    Utils.openLinks(url: Uri.encodeFull(url));
  }

  void _showToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      child: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<User?>(
                stream: FirebaseAuthentication.getUserStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    User user = snapshot.data;
                    return Container(
                      height: 130,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                    ),
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: user.photoURL!,
                                  fit: BoxFit.cover,
                                ),
                              )),
                          const SizedBox(height: 10),
                          Text(
                            user.displayName!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    height: 130,
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 0),
                                ),
                              ]),
                          child: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              StreamBuilder<User?>(
                stream: FirebaseAuthentication.getUserStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Container();
                  }
                  return GestureDetector(
                    onTap: () async {
                      try {
                        SimpleFontelicoProgressDialog _dialog =
                            SimpleFontelicoProgressDialog(
                                context: context, barrierDimisable: false);
                        _dialog.show(message: 'Loging In...');
                        await FirebaseAuthentication.signInWithGoogle();
                        _dialog.hide();
                        if (FirebaseAuthentication.isLoggedIn()) {
                          _showToast(context, "User Logged In!");
                        }
                      } on PlatformException {
                        _showToast(context, "User Log In Failed!");
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.6,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Sign In With Google",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Divider(),
              StreamBuilder<User?>(
                stream: FirebaseAuthentication.getUserStream,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return UserOrderScreen();
                        }));
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.inventory_2,
                          color: kPrimaryColor,
                        ),
                        title: const Text('My Orders'),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const WishListScreen();
                  }));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.favorite_border_outlined,
                    color: kPrimaryColor,
                  ),
                  title: const Text('Wishlist'),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  showModalSheet(context);
                  // openMail();
                },
                child: ListTile(
                  leading: Icon(
                    Icons.contact_mail,
                    color: kPrimaryColor,
                  ),
                  title: const Text('Contact Us'),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => InAppwebView(
                        url:
                            "https://makdeck.blogspot.com/p/privacy-policy.html",
                        urlType: 'Privacy Policy',
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.privacy_tip,
                    color: kPrimaryColor,
                  ),
                  title: const Text(
                    'Privacy Policy',
                  ),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  openPlayStore();
                },
                child: ListTile(
                  leading: Icon(
                    Icons.star,
                    color: kPrimaryColor,
                  ),
                  title: const Text(
                    'Rate us',
                  ),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => InAppwebView(
                        url:
                            "https://makdeck.blogspot.com/p/terms-conditions.html",
                        urlType: 'Terms & Conditions ',
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.description,
                    color: kPrimaryColor,
                  ),
                  title: const Text(
                    'Terms & Conditions',
                  ),
                ),
              ),
              const Divider(),
              // GestureDetector(
              //   onTap: () {},
              //   child: ListTile(
              //     leading: Icon(
              //       Icons.info,
              //       color: kPrimaryColor,
              //     ),
              //     title: const Text(
              //       'About Us',
              //     ),
              //   ),
              // ),
            ],
          ),
          StreamBuilder<User?>(
            stream: FirebaseAuthentication.getUserStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                User? user = snapshot.data;
                if (user != null) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        try {
                          FirebaseAuthentication.signOut();
                        } catch (e) {
                          rethrow;
                        }
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: kPrimaryColor,
                        ),
                        title: const Text('Logout'),
                      ),
                    ),
                  );
                }
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
