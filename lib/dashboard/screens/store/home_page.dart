import 'package:flutter/material.dart';
import 'package:narrid/core/global.dart';
import 'package:narrid/dashboard/screens/food/home_page.dart';
import 'package:narrid/dashboard/screens/grocery/home_page.dart';
import 'package:narrid/dashboard/screens/logistices/home_page.dart';
import 'package:narrid/utils/widgets/store/banner.dart';
import 'package:narrid/utils/widgets/store/banners/single-banner.dart';
import 'package:narrid/utils/widgets/store/custom_appbar.dart';
import 'package:narrid/utils/widgets/store/products/electronics.dart';
import 'package:narrid/utils/widgets/store/products/fashion-men.dart';
import 'package:narrid/utils/widgets/store/products/fashion-women.dart';
import 'package:narrid/utils/widgets/store/products/groceries.dart';
import 'package:narrid/utils/widgets/store/products/laptops.dart';
import 'package:narrid/utils/widgets/store/products/mobiles.dart';
import 'package:narrid/utils/widgets/store/products/recommendation.dart';
import 'package:narrid/utils/widgets/store/top_categories.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(),
            //top banner
            SingleBanners(myContext: context).topBanner(),
            //Banners
            Banners(),
            //App Action
            AppActions(),
            //Popular Categories
            PopularCategories(),
            //Banners
            SingleBanners(myContext: context).banner1(),
            //Recommended for you
            Recommended(),
            //Banners
            SingleBanners(myContext: context).banner2(),
            //Top Pick Electronics
            ProductsElectronics(),
            //Banners
            SingleBanners(myContext: context).banner3(),
            //Groceries
            ProductsGroceries(),
            //Banners
            SingleBanners(myContext: context).banner4(),
            SingleBanners(myContext: context).bannerBrands(),
            //Top Pick Mobiles
            ProductsMobile(),
            //Banners
            SingleBanners(myContext: context).banner5(),
            //Top pick Laptop
            ProductsLaptop(),
            //Banners
            SingleBanners(myContext: context).banner6(),
            //Men Fashion
            ProductsMen(),
            //Banners
            SingleBanners(myContext: context).banner7(),
            //Women fashion
            ProductsWomen(),
            //Banners
            SingleBanners(myContext: context).banner8(),
          ],
        ),
      ),
    );
  }
}

class AppActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Logistics()));
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/logistics.png",
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Delivery",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "Services",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Food()));
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/food.png",
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Narrid",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "Food",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Grocery()));
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/grocery.png",
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Grocery/",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "supermarket",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Global().lunchURL('www.sellershub.narrid.com/');
                },
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/vendors.png",
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Vendors/",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "Sellers",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Popular Categories"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 200, // constrain height
            child: BuildTopCategories(),
          )
        ]),
      ),
    );
  }
}

class Recommended extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Recommended for you"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350, // constrain height
            child: BuildRecommendation(),
          )
        ]),
      ),
    );
  }
}

class ProductsElectronics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Top picks in electronics"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350, // constrain height
            child: BuildElectronics(),
          )
        ]),
      ),
    );
  }
}

class ProductsGroceries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Groceries"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350, // constrain height
            child: BuildGroceries(),
          )
        ]),
      ),
    );
  }
}

class ProductsMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Top picks in mobile phones"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350, // constrain height
            child: BuildMobile(),
          )
        ]),
      ),
    );
  }
}

class ProductsLaptop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Top picks laptops"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350, // constrain height
            child: BuildLaptop(),
          )
        ]),
      ),
    );
  }
}

class ProductsMen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Fashion for men"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350, // constrain height
            child: BuildFashionMen(),
          )
        ]),
      ),
    );
  }
}

class ProductsWomen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Fashion for women"),
          SizedBox(height: 5),
          const Divider(
            height: 2,
            thickness: 1,
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 350, // constrain height
            child: BuildFashionWomen(),
          )
        ]),
      ),
    );
  }
}
