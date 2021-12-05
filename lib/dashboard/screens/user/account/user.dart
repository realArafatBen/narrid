import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:narrid/dashboard/bloc/user/acct_bloc.dart';
import 'package:narrid/dashboard/bloc/user/wallet_badge_bloc.dart';
import 'package:narrid/dashboard/screens/user/account/change_password.dart';
import 'package:narrid/dashboard/screens/user/account/coupons/coupon.dart';
import 'package:narrid/dashboard/screens/user/account/edit_account.dart';
import 'package:narrid/dashboard/screens/user/account/memberships/membership.dart';
import 'package:narrid/dashboard/screens/user/account/orders/orders.dart';
import 'package:narrid/dashboard/screens/user/account/others/address/address_book.dart';
import 'package:narrid/dashboard/screens/user/account/recently-viewed/viewed.dart';
import 'package:narrid/dashboard/screens/user/account/returns/return.dart';
import 'package:narrid/dashboard/screens/user/account/wallet/wallet.dart';
import 'package:narrid/dashboard/screens/user/account/wishlist/wishlist_items.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';
import 'package:narrid/utils/widgets/store/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:narrid/core/string_extension.dart";
import '../../../repositories/user/auth/userRepository.dart';

class UserAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xfff7f7f7f7),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AcctBloc>(
              create: (BuildContext context) =>
                  AcctBloc(authenticationRepository: UserRepository())
                    ..add(AcctStarted()),
            ),
            BlocProvider<WalletBadgeBloc>(
              create: (BuildContext context) =>
                  WalletBadgeBloc(userRepos: UserRepository())
                    ..add(
                      WalletBadgeStarted(),
                    ),
            ),
          ],
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(),
                //Header Section
                HeaderSection(),
                NarridAccount(),
                AccountSettings(),
                SignOut(),
                ContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcctBloc, AcctState>(builder: (context, state) {
      if (state is AcctLoading) {
        return CircularProgressIndicator();
      } else if (state is FetchToken) {
        Map<String, dynamic> token = state.getToken;
        String _first_name = token['first_name'].toString();
        String _last_name = token['last_name'].toString();
        String _email = token['email'].toString();
        return _userAcct(_first_name, _last_name, _email);
      } else {
        return CircularProgressIndicator();
      }
    });
  }

  _userAcct(_first_name, _last_name, _email) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffffc700),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                        "Welcome, $_first_name $_last_name",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _email,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: BlocBuilder<WalletBadgeBloc, WalletBadgeState>(
                builder: (context, state) {
                  if (state is WalletBadgeLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WalletBadgeError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WalletBadgeLoaded) {
                    Map<String, dynamic> data = state.getData;

                    return Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${data['member']['type']}".capitalize(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${data['point']}/${data['member']['max']}",
                                ),
                              ],
                            ),
                            Text(
                              "N ${data['balance']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.network(
                          data['member']["image"],
                          width: 40,
                          height: 40,
                        ),
                      ],
                    );
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NarridAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "NARIID ACCOUNT",
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
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Orders()));
                },
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.shoppingBasket),
                          SizedBox(width: 10.0),
                          Text("Orders"),
                        ],
                      ),
                      trailing: SvgPicture.asset(
                          "assets/images/icons/right-chevron.svg"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WishList()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.star),
                            SizedBox(width: 10.0),
                            Text("Saved Items"),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                            "assets/images/icons/right-chevron.svg"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Wallet()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.wallet),
                            SizedBox(width: 10.0),
                            Text("Wallet"),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                            "assets/images/icons/right-chevron.svg"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Return()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.reply),
                            SizedBox(width: 10.0),
                            Text("Returns"),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                            "assets/images/icons/right-chevron.svg"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Coupon()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.gift),
                            SizedBox(width: 10.0),
                            Text("Coupon"),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                            "assets/images/icons/right-chevron.svg"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Viewed()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.eye),
                            SizedBox(width: 10.0),
                            Text("Recently viewed"),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                            "assets/images/icons/right-chevron.svg"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Membership()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.trophy,
                            ),
                            SizedBox(width: 10.0),
                            Text("Membership"),
                          ],
                        ),
                        trailing: SvgPicture.asset(
                            "assets/images/icons/right-chevron.svg"),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class AccountSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "ACCOUNT SETTINGS",
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
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditAccount()));
                },
                child: ListTile(
                  title: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.user),
                      SizedBox(width: 10.0),
                      Text("Details"),
                    ],
                  ),
                  trailing:
                      SvgPicture.asset("assets/images/icons/right-chevron.svg"),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddressBook()));
                },
                child: ListTile(
                  title: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.bookmark),
                      SizedBox(width: 10.0),
                      Text("Address Book"),
                    ],
                  ),
                  trailing:
                      SvgPicture.asset("assets/images/icons/right-chevron.svg"),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                },
                child: ListTile(
                  title: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.userLock),
                      SizedBox(width: 10.0),
                      Text("Change Password"),
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
}

class SignOut extends StatelessWidget {
  final UserRepository authenticationRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              authenticationRepository.deleteToken();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Login(
                        userRepository: UserRepository(),
                        route: 'home',
                      )));
            },
            child: Text(
              "LOGOUT",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.yellow,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 50),
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
                      _lunchURL('www.narrid.com/?route=help');
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
                      trailing: SvgPicture.asset(
                          "assets/images/icons/right-chevron.svg"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _lunchURL('www.narrid.com/?route=help');
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          SvgPicture.asset(
                              "assets/images/icons/account-help.svg"),
                          SizedBox(width: 10.0),
                          Text("Help Center"),
                        ],
                      ),
                      trailing: SvgPicture.asset(
                          "assets/images/icons/right-chevron.svg"),
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
