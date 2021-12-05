//Logistics
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/screens/logistices/pick-up-drop-off.dart';
import 'package:narrid/dashboard/screens/webview_page.dart';
import 'package:narrid/utils/widgets/logistices/custom_log_appbar.dart';
import 'package:narrid/utils/widgets/logistices/drawer.dart';

class Logistics extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CustomLogisticsAppBar(scaffoldKey: _scaffoldKey),
                GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: <Widget>[
                    pickUpDropOff(context),
                    callForPickUp(context),
                    insterstate(context),
                    errands(context),
                    international(context),
                    callUs(),
                  ],
                )
              ],
            ),
          ),
        ),
        drawer: LogisticsDrawer(),
      ),
    );
  }

  Widget callUs() {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: HexColor("000000"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: SvgPicture.asset(
                "assets/images/logistics/phone.svg",
                width: 60,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 8,
              ),
              child: Text(
                "Call us @ +2347049695303",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 5,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget international(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              title: "International",
              url: "https://narrid.com/logistics/?route=international-shipping",
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: HexColor("FF2442"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: SvgPicture.asset(
                "assets/images/logistics/globe.svg",
                width: 60,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 8,
              ),
              child: Text(
                "International Shipping",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 5,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget insterstate(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                      title: "Interstate Delivery",
                      url:
                          "https://narrid.com/logistics/?route=inter-state-delivery",
                    )));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: HexColor("3DB2FF"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: SvgPicture.asset(
                "assets/images/logistics/highway.svg",
                width: 60,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 8,
              ),
              child: Text(
                "Insterstate",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 5,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget errands(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                      title: "Errands",
                      url: "https://narrid.com/logistics/?route=errands",
                    )));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: HexColor("FF00E4"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: SvgPicture.asset(
                "assets/images/logistics/food.svg",
                width: 60,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 8,
              ),
              child: Text(
                "Errands services",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 5,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget callForPickUp(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(
                title: "Call for Pick up",
                url: "https://narrid.com/logistics/?route=call-for-pickup",
              ),
            ));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: HexColor("FFB344"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: SvgPicture.asset(
                "assets/images/logistics/call-center.svg",
                width: 60,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 8,
              ),
              child: Text(
                "Call for pick up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 5,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pickUpDropOff(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PickUpDropOff()));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: HexColor("4B3869"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: SvgPicture.asset(
                "assets/images/logistics/pickup-truck.svg",
                width: 60,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 8,
              ),
              child: Text(
                "Pick up and Drop Off",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: 5,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_right_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
