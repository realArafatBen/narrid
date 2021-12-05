import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:narrid/core/app_theme.dart';
import 'package:narrid/core/global.dart';
import 'package:narrid/dashboard/bloc/store/bottomnavigation_bloc.dart';
import 'package:narrid/dashboard/bloc/store/walk_through_bloc.dart';
import 'package:narrid/dashboard/repositories/store/walkthrough_repositories.dart';
import 'package:narrid/dashboard/screens/store/account_page.dart';
import 'package:narrid/dashboard/screens/store/cart_page.dart';
import 'package:narrid/dashboard/screens/store/categories_page.dart';
import 'package:narrid/dashboard/screens/store/home_page.dart';
import 'package:narrid/dashboard/screens/store/trending_page.dart';
import 'package:narrid/utils/widgets/store/bottom_navigation/nav_widgets.dart';

class NarridApp extends StatefulWidget {
  @override
  _NarridAppState createState() => _NarridAppState();
}

class _NarridAppState extends State<NarridApp> {
  @override
  void initState() {
    super.initState();
    _permitNotifications();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = appThemeData[AppTheme.LightTheme];
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomnavigationBloc>(
          create: (BuildContext context) =>
              BottomnavigationBloc()..add(AppStarted()),
        ),
        BlocProvider<WalkThroughBloc>(
          create: (BuildContext context) => WalkThroughBloc(
              walkThroughRepositories: WalkThroughRepositories())
            ..add(WalkThroughStarted()),
        ),
      ],
      child: MaterialApp(
        theme: theme,
        home: AppLunchEvent(),
      ),
    );
  }

  void _permitNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Allow Notifications"),
            content: Text("Our app wonld like to send you notifications "),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Dont't Allow",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then((_) => Navigator.of(context).pop());
                  },
                  child: Text(
                    "Allow",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                    ),
                  ))
            ],
          ),
        );
      }
    });
  }
}

class AppLunchEvent extends StatelessWidget {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset("assets/images/walkthrough_1.jpg"),
        title: "WELCOME TO THE WORLD OF E-COMMERCE",
        body:
            "We are your all In one E-commerce platform, with Narrid you can get everything you need deliver to your right away. be it online shopping, food, Grocery shopping and your daily delivery needs and more.",
      ),
      PageViewModel(
          image: Image.asset("assets/images/walkthrough_2.jpg"),
          title: "SIT BACK AND ENJOY THE SHOPPING EXPERIENCE",
          body:
              "Order on Narrid from the comfort of your home and we will deliver to your doorstep nationwide."),
      PageViewModel(
        image: Image.asset("assets/images/walkthrough_3.jpg"),
        title: "WORRY LESS ABOUT GOING OUT FOR YOUR GROCERIES/ SUPERMARKET",
        body:
            "Are you Worried about cancelling your schedules to go for your groceries? Worry less with Narrid, you can order from your favorite grocery stores at your location and get your items deliver directly to you instantly.",
      ),
      PageViewModel(
        image: Image.asset("assets/images/walkthrough_4.jpg"),
        title: "IN NEED OF DELIVERY SERVICES?",
        body:
            "Request for your delivery needs like Pick up and drop off, interstate delivery and more on Narrid and worry less about it.",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkThroughBloc, WalkThroughState>(
      builder: (context, state) {
        if (state is WalkThroughLoading) {
          return Container();
        } else if (state is WalkThroughError) {
          return HomePageContent();
        } else if (state is WalkThroughSet) {
          return HomePageContent();
        } else if (state is WalkThroughNotSet) {
          //show the Walkthrough here
          return IntroductionScreen(
            onDone: () {
              BlocProvider.of<WalkThroughBloc>(context)..add(WalkThroughDone());
            },
            pages: getPages(),
            globalBackgroundColor: Colors.white,
            showSkipButton: true,
            onSkip: () {
              // You can also override onSkip callback
              BlocProvider.of<WalkThroughBloc>(context)..add(WalkThroughDone());
            },
            skip: Text("Skip"),
            next: Text("Next"),
            done: const Text("Done",
                style: TextStyle(fontWeight: FontWeight.w600)),
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
          );
        } else {
          return HomePageContent();
        }
      },
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.yellow,
          // For Android.
          // Use [light] for white status bar and [dark] for black status bar.
          statusBarIconBrightness: Brightness.light,
          // For iOS.
          // Use [dark] for white status bar and [light] for black status bar.
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: BlocBuilder<BottomnavigationBloc, BottomnavigationState>(
              builder: (context, state) {
            if (state is PageLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FirstPageLoaded) {
              return Home();
            } else if (state is SecondPageLoaded) {
              return Account();
            } else if (state is ThirdPageLoaded) {
              return Categories();
            } else if (state is ForthPageLoaded) {
              return Trending();
            } else if (state is FifthPageLoaded) {
              return Cart();
            } else if (state is SixthPageLoaded) {
              Global().lunchURL('www.narrid.com/?route=help');
              return Container();
            } else {
              return Container();
            }
          }),
          bottomNavigationBar: BottomNavigationBuilder(),
        ),
      ),
    );
  }
}
