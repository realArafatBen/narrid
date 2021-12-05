import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/core/app_theme.dart';
import 'package:narrid/dashboard/app_initializer.dart';
import 'package:narrid/dashboard/repositories/activities/notification_activities.dart';
import 'package:narrid/dashboard/screens/app_splash_screen.dart';
import 'package:narrid/dashboard/screens/error/app_error.dart';
import 'package:narrid/dashboard/screens/error/connectivity_error.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';
import 'package:narrid/utils/services/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

const simplePeriodicTask = "simplePeriodicTask";
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    //get notifications from servers
    NotificationActivities notificationActivities = NotificationActivities();
    List<dynamic> notifications =
        await notificationActivities.getPushNotifications();
    //loop through
    if (notifications.isNotEmpty) {
      for (var i = 0; i < notifications.length; i++) {
        String title = notifications[i]['title'];
        String body = notifications[i]['body'];
        String hash = notifications[i]['hash'];

        log(hash);

        //check if hash is already stored; if stored then then this user have already recevied this notification
        // on he/her device
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool checkHash = prefs.containsKey(hash);
        if (!checkHash) {
          createAppNotification(title, body);
          prefs.setBool(hash, true);
        }
      }
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
  );
  Workmanager().registerPeriodicTask("3", simplePeriodicTask,
      initialDelay: Duration(seconds: 10),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));
  AwesomeNotifications()
    ..initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/res_notification_app_icon',
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Narrid',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: HexColor("FFE459"),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            channelShowBadge: true,
          ),
        ]);

  runApp(
    FutureBuilder(
      future: AppInitializer().appInitializer(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            theme: appThemeData[AppTheme.LightTheme],
            debugShowCheckedModeBanner: false,
            home: AppSplashScreen(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> appInitData = snapshot.data;

            ///
            /// check if the connectivity status is === false
            ///
            bool connectiviityStatus = appInitData['connectivity_status'];
            if (connectiviityStatus) {
              return NarridApp();
            } else {
              ///
              /// show the connectivity error page
              ///
              return ConnectivityError();
            }
          } else {
            ///
            /// show the error page
            ///
            return AppError();
          }
        } else if (snapshot.hasError) {
          return AppError();
        } else {
          return AppError();
        }
      },
    ),
  );
}
