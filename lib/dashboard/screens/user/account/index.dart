import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';
import 'package:narrid/dashboard/screens/user/auth/register.dart';
import 'package:narrid/utils/widgets/store/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xfff7f7f7f7),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(),
              //Header Section
              HeaderSection(),
              SignUpSection(),
              ContactSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color(0xffffc700),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                "assets/images/logo-black.png",
                width: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello! Nice to meet you",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "You are not currently not signed in",
                      style: TextStyle(
                          color: Colors.grey[900], fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class SignUpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  userRepository: UserRepository(),
                                  route: 'home',
                                )));
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                          'assets/images/icons/account-profile.svg'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(
                                  userRepository: UserRepository(),
                                  route: 'home',
                                )));
                  },
                  child: Column(
                    children: [
                      SvgPicture.asset(
                          'assets/images/icons/account-signup.svg'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "REACH OUT TO US",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              InkWell(
                onTap: () {
                  _lunchURL('https//narrid.com/?route=help');
                },
                child: ListTile(
                  title: Row(
                    children: [
                      SvgPicture.asset(
                          "assets/images/icons/account-contact.svg"),
                      SizedBox(width: 10.0),
                      Text("Contact Us"),
                    ],
                  ),
                  trailing:
                      SvgPicture.asset("assets/images/icons/right-chevron.svg"),
                ),
              ),
              InkWell(
                onTap: () {
                  _lunchURL('https//narrid.com/?route=help');
                },
                child: ListTile(
                  title: Row(
                    children: [
                      SvgPicture.asset("assets/images/icons/account-help.svg"),
                      SizedBox(width: 10.0),
                      Text("Help Center"),
                    ],
                  ),
                  trailing:
                      SvgPicture.asset("assets/images/icons/right-chevron.svg"),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  _lunchURL(url) async {
    if (!url.contains('http')) url = 'https://$url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
