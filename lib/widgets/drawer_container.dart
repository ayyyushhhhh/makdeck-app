import 'package:flutter/material.dart';
import 'package:makdeck/services/authentication/user_authentication.dart';
import 'package:makdeck/utils/ui/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerContainer extends StatelessWidget {
  const DrawerContainer({Key? key}) : super(key: key);

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
                      padding: EdgeInsets.all(20),
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                    ),
                                  ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  user.photoURL!,
                                  fit: BoxFit.contain,
                                ),
                              )),
                          SizedBox(height: 10),
                          Text(
                            user.displayName!,
                            style: TextStyle(
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
                    padding: EdgeInsets.only(left: 20, right: 20),
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 0),
                                ),
                              ]),
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
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
                    onTap: () {
                      try {
                        FirebaseAuthentication.signInWithGoogle();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.6,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Sign In With Google",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.contact_mail,
                  color: kPrimaryColor,
                ),
                title: Text('Contact Us'),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.privacy_tip,
                  color: kPrimaryColor,
                ),
                title: Text(
                  'Privacy Policy',
                ),
              ),
              Divider(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                try {
                  FirebaseAuthentication.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: kPrimaryColor,
                ),
                title: Text('Logout'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
