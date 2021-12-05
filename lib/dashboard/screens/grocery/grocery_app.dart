import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/grocery/banner_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/location/delivery_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/location/location_auth_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/products/feature_grocery_product_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/store/stores_bloc.dart';
import 'package:narrid/dashboard/models/food/food_feature_model.dart';
import 'package:narrid/dashboard/models/grocery/store_model.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/repositories/grocery/products/products_repos.dart';
import 'package:narrid/dashboard/repositories/grocery/store/extimate_delivery_repos.dart';
import 'package:narrid/dashboard/repositories/grocery/store/store_repos.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';
import 'package:narrid/dashboard/screens/food/home_page.dart';
import 'package:narrid/dashboard/screens/grocery/cart.dart';
import 'package:narrid/dashboard/screens/grocery/grocery_search_view.dart';
import 'package:narrid/dashboard/screens/grocery/home_page.dart';
import 'package:narrid/dashboard/screens/grocery/product.dart';
import 'package:narrid/dashboard/screens/grocery/store_categories.dart';
import 'package:narrid/dashboard/screens/logistices/home_page.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/grocery/custom_grocery_appbar.dart';
import 'package:narrid/utils/widgets/grocery/drawer.dart';

class GroceryApp extends StatelessWidget {
  final location;
  GroceryApp({Key key, @required this.location}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationAuthBloc>(
          create: (BuildContext context) =>
              LocationAuthBloc(locationRespos: LocationRespos())
                ..add(Started()),
        ),
        BlocProvider<StoreBloc>(
          create: (BuildContext context) =>
              StoreBloc(storeRepos: StoreRepos())..add(StoreStarted()),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              BannerStoreBloc(bannersRep: BannersRep())..add(BannerStarted()),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              FeatureGroceryProductBloc(groceryProductRep: GroceryProductRep())
                ..add(FeatureStarted()),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey[200],
          drawer: GroceryDrawer(),
          body: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            CustomGroceryAppBar(scaffoldKey: _scaffoldKey),
            SizedBox(
              height: 5,
            ),
            buildBanner(),
            SizedBox(
              height: 10,
            ),
            buildStores(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
      title: Column(
        children: [
          Text(
            "Delivering to",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 10,
            ),
          ),
          BlocBuilder<LocationAuthBloc, LocationAuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                Map<String, dynamic> data = state.getLocation;
                return Text(
                  data['address'],
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 14,
                  ),
                );
              } else if (state is Unauthenticated) {
                return Text(
                  "--------------------",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 14,
                  ),
                );
              } else if (state is Loading) {
                return Text(
                  "--------------------",
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 14,
                  ),
                );
              }
            },
          ),
        ],
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.yellow[800], //change your color here
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GrocerySearchView()));
          },
          child: Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }

  Widget buildBanner() {
    return BlocBuilder<BannerStoreBloc, BannerStoreState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShimmerSlider(),
          );
        } else if (state is BannerLoaded) {
          return Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCarousel(state, context),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    top: 10,
                    left: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Narrid Grocery",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Colors.grey[800],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AutoSizeText(
                              "Shop for all your home groceries on narrid.",
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) => CartGrocery());
                                  Navigator.push(context, route);
                                },
                                icon: Icon(
                                  Icons.shopping_basket,
                                ),
                                label: Flexible(
                                  child: AutoSizeText(
                                    "Basket",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is BannerError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShimmerSlider(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget getCarousel(state, context) {
    List<BannersModel> banners = state.getBanners;

    return SizedBox(
      height: 150,
      child: Carousel(
        boxFit: BoxFit.cover,
        autoplay: true,
        autoplayDuration: const Duration(seconds: 5),
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 6.0,
        dotIncreasedColor: Colors.yellow[100],
        dotBgColor: Colors.transparent,
        dotPosition: DotPosition.bottomCenter,
        dotVerticalPadding: 10.0,
        showIndicator: true,
        indicatorBgPadding: 7.0,
        borderRadius: true,
        moveIndicatorFromBottom: 180.0,
        noRadiusForIndicator: true,
        images: [
          for (var item in banners)
            Image.network(
              item.image.toString(),
              fit: BoxFit.cover,
            ),
        ],
      ),
    );
  }

  Widget buildStores() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "You'll love these",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          buildAllFeatureStores(),
          SizedBox(
            height: 15,
          ),
          Text(
            "All Stores",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          buildAllStores(),
        ],
      ),
    );
  }

  Widget buildAllStores() {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state is StoreLoading) {
          return ShimmerStores();
        } else if (state is StoreLoaded) {
          return _stores(state, context);
        } else if (state is StoreError) {
          return ShimmerStores();
        }
      },
    );
  }

  Widget _stores(state, context) {
    List<StoreModel> stores = state.getStores;
    return Column(
      children: [
        for (var i = 0; i < stores.length; i++)
          InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (context) => StoreCategories(
                        storeId: stores[i].id,
                        image: stores[i].image,
                        name: stores[i].name,
                        city: stores[i].city,
                        lat: stores[i].lat,
                        lng: stores[i].lng,
                      ));
              Navigator.push(context, route);
            },
            child: Container(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 5,
                top: 10,
                right: 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    stores[i].image,
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stores[i].name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        stores[i].city,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      BlocProvider(
                        create: (context) => DeliveryExBloc(
                            extimateDeliveryRepos: ExtimateDeliveryRepos())
                          ..add(DeliveryExStarted(
                            lat: stores[i].lat,
                            lng: stores[i].lng,
                          )),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.clock,
                              size: 18,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            BlocBuilder<DeliveryExBloc, DeliveryExState>(
                              builder: (context, state) {
                                if (state is DeliveryExLoading) {
                                  print("loading");
                                  return Text("....");
                                } else if (state is DeliveryExError) {
                                  print("error");
                                  return Text("....");
                                } else if (state is DeliveryExSuccess) {
                                  Map<String, dynamic> data = state.getData;

                                  return Row(
                                    children: [
                                      Text(
                                        data['duration_text'],
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.delivery_dining,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        data['distance_text'],
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "NGN " + data['distance_value'],
                                        style: TextStyle(
                                          color: Colors.grey[900],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget buildAllFeatureStores() {
    return SizedBox(
      height: 200,
      child: BlocBuilder<FeatureGroceryProductBloc, FeatureProductState>(
        builder: (context, state) {
          if (state is FeatureLoading) {
            return ShimmerFeatureProduct();
          } else if (state is FeatureError) {
            return Text("Error");
          } else if (state is FeatureLoaded) {
            return whatYouWillLove(state, context);
          }
        },
      ),
    );
  }

  Widget whatYouWillLove(state, context) {
    List<FeatureFoodModel> products = state.getProducts;
    return ListView(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        for (var product in products)
          InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (context) => Product(
                        image: product.image,
                        id: product.id,
                        name: product.name,
                        price: product.price,
                        shipping_cost: '200',
                      ));
              Navigator.push(context, route);
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 5,
                left: 5,
                right: 25,
                bottom: 5,
              ),
              constraints: BoxConstraints(minWidth: 250, maxWidth: 250),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 280,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            product.image,
                          ),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    BlocProvider(
                      create: (context) => DeliveryExBloc(
                          extimateDeliveryRepos: ExtimateDeliveryRepos())
                        ..add(DeliveryExStarted(
                          lat: product.lat,
                          lng: product.lng,
                        )),
                      child: BlocBuilder<DeliveryExBloc, DeliveryExState>(
                        builder: (context, exstate) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.delivery_dining,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: exstate is DeliveryExSuccess
                                            ? AutoSizeText(
                                                exstate
                                                    .getData['duration_text'],
                                                style: TextStyle(
                                                  fontSize: 9,
                                                ),
                                              )
                                            : Text("....")),
                                  ],
                                ),
                                AutoSizeText(
                                  product.store_name,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.emoji_emotions,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "Very good",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: exstate is DeliveryExSuccess
                                          ? Text(
                                              "NG ${exstate.getData['distance_value']}",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            )
                                          : Text("..."),
                                    ),
                                  ],
                                )
                              ]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buidTopSection(context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NarridApp()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('eaeaea'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "narrid",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Food()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('eaeaea'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Food",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Grocery()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('f1df00'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Grocery",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Logistics()));
            },
            child: Container(
              decoration: BoxDecoration(
                color: HexColor('eaeaea'),
                borderRadius: BorderRadius.all(
                  Radius.circular(6),
                ),
              ),
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                "Delivery Services",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
