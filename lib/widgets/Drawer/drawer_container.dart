import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:makdeck/screens/all_products.dart';
import 'package:makdeck/screens/wishlist_screen.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makdeck/utils/utils.dart';

class DrawerContainer extends StatelessWidget {
  const DrawerContainer({Key? key}) : super(key: key);

  void openPrivacyPolicy() {
    const String url =
        'https://makdeck.blogspot.com/2022/01/privacy-policy.html';
    Utils.openLinks(url: Uri.encodeFull(url));
  }

  void openMail() {
    const String email = "makdeckcare@gmail.com";
    Utils.openEmail(
      to: email,
      subject: "Query for Makdeck",
    );
  }

  void _showToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height,
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
                        await FirebaseAuthentication.signInWithGoogle();
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
                  openMail();
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
                  openPrivacyPolicy();
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
