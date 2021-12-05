import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:narrid/dashboard/bloc/store/member_level_guide_bloc.dart';
import 'package:narrid/dashboard/bloc/user/acct_bloc.dart';
import 'package:narrid/dashboard/bloc/user/wallet_badge_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import "package:narrid/core/string_extension.dart";

class Membership extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          BlocProvider<MemberLevelGuideBloc>(
            create: (BuildContext context) =>
                MemberLevelGuideBloc(userRepository: UserRepository())
                  ..add(
                    MemberLevelStarted(),
                  ),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            actions: [],
            title: Text(
              "Membership Center",
              style: TextStyle(color: Colors.grey[800]),
            ),
            iconTheme: IconThemeData(
              color: Colors.grey[800], //change your color here
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: membershipBody(context),
        ),
      ),
    );
  }

  Widget membershipBody(context) {
    double x_width = MediaQuery.of(context).size.width / 4;
    double y_width = MediaQuery.of(context).size.width / 1.5;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.yellow[700],
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(9),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: [
                          buildUsernameAvatar(),
                          buildMembershipData(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Your rewards",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  buildReward(x_width),
                ],
              ),
            ),
            bonusNotice(y_width),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Member Level Guide",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Member Levels",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Points Required",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      buildLevels(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLevels() {
    return BlocBuilder<MemberLevelGuideBloc, MemberLevelGuideState>(
      builder: (context, state) {
        if (state is MemberLevelLoading) {
          return CircularProgressIndicator();
        } else if (state is MemberLevelError) {
          return CircularProgressIndicator();
        } else if (state is MemberLevelLoaded) {
          List<dynamic> data = state.getData;
          return buildEachLevel(data: data);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildEachLevel({@required data}) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        children: [
          for (var i = 0; i < data.length; i++)
            Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.network(
                        "${data[i]['image']}",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        "${data[i]['type']}".capitalize(),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${data[i]['min']}-${data[i]['max']}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget bonusNotice(double y_width) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/icons/m-trophy.svg",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Bonus Points",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidDotCircle,
                          size: 10,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Reward Points",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: y_width,
                              child: AutoSizeText(
                                  "Keep eyes on out for special promotions to earn extra points"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0.5, // thickness of the line
                indent: 20, // empty space to the leading edge of divider.
                endIndent:
                    20, // empty space to the trailing edge of the divider.
                color:
                    Colors.black26, // The color to use when painting the line.
                height: 20, // The divider's height extent.
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/icons/m-attention.svg",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Importance notice",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidDotCircle,
                          size: 10,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: y_width,
                          child: AutoSizeText(
                            "We reserve the right to downgrade your membership level due to security reasons. Any violations including but not limited to refund abuse, coupon fraud and spam registration will lead to the deduction of your membership score.",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReward(double x_width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: x_width,
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/icons/m-off.svg",
                width: 50,
              ),
              SizedBox(
                height: 5,
              ),
              AutoSizeText(
                "8% off",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: x_width,
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/icons/m-an.svg",
                width: 50,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Anniversary Coupon",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: x_width,
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/icons/m-weekly.svg",
                width: 50,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Top Weekly Brands",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMembershipData() {
    return BlocBuilder<WalletBadgeBloc, WalletBadgeState>(
      builder: (context, state) {
        if (state is WalletBadgeLoading) {
          Map<String, dynamic> data = {};
          return BuildMemberShip(
            data: data,
            state: state,
          );
        } else if (state is WalletBadgeError) {
          Map<String, dynamic> data = {};

          return BuildMemberShip(
            data: data,
            state: state,
          );
        } else if (state is WalletBadgeLoaded) {
          Map<String, dynamic> data = state.getData;

          return BuildMemberShip(
            data: data,
            state: state,
          );
        } else {
          Map<String, dynamic> data = {};

          return BuildMemberShip(
            data: data,
            state: state,
          );
        }
      },
    );
  }

  Widget buildUsernameAvatar() {
    return BlocBuilder<AcctBloc, AcctState>(
      builder: (context, state) {
        if (state is AcctLoading) {
          String _avatar = "assets/images/icons/user-default.svg";
          String _first_name = "-";
          String _last_name = "-";
          return userContent(
            _first_name,
            _last_name,
            _avatar,
          );
        } else if (state is FetchToken) {
          Map<String, dynamic> token = state.getToken;
          String _first_name = token['first_name'].toString();
          String _last_name = token['last_name'].toString();
          String _email = token['email'].toString();
          String _avatar = "assets/images/icons/user-default.svg";
          return userContent(
            _first_name,
            _last_name,
            _avatar,
          );
        } else {
          String _avatar = "assets/images/icons/user-default.svg";
          String _first_name = "-";
          String _last_name = "-";
          return userContent(
            _first_name,
            _last_name,
            _avatar,
          );
        }
      },
    );
  }

  Widget userContent(
    first_name,
    last_name,
    avatar,
  ) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              child: SvgPicture.asset(
                "${avatar}",
                width: 60,
                height: 60,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${first_name}  ${last_name}",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class BuildMemberShip extends StatelessWidget {
  final data;
  final state;
  const BuildMemberShip({
    Key key,
    @required this.data,
    @required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width / 2.5;
    double x_width = MediaQuery.of(context).size.width / 2;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              state is WalletBadgeLoaded
                  ? SvgPicture.network(
                      "${data['member']['image']}",
                      width: 30,
                      height: 30,
                    )
                  : Container(),
              Text(
                state is WalletBadgeLoaded
                    ? "${data['member']['type']} Member".capitalize()
                    : "XXXXXXXXX",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: c_width,
                child: FAProgressBar(
                  currentValue:
                      state is WalletBadgeLoaded ? int.parse(data['point']) : 0,
                  progressColor: Colors.blue,
                  backgroundColor: Colors.blue[100],
                  size: 5,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              state is WalletBadgeLoaded
                  ? Text("${data['point']}/${data['member']['max']}")
                  : Text("XX"),
            ],
          ),
          state is WalletBadgeLoaded
              ? Container(
                  width: x_width,
                  child: AutoSizeText(
                    "Get 356 points be become a Platinum Member",
                    softWrap: true,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(),
                  ),
                )
              : Text("XXXXXXXX"),
        ],
      ),
    );
  }
}
