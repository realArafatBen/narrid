import 'package:auto_size_text/auto_size_text.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:narrid/dashboard/bloc/food/cart/cart_handler_bloc.dart';
import 'package:narrid/dashboard/bloc/food/products/products_bloc.dart';
import 'package:narrid/dashboard/bloc/food/store/categories_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/location/delivery_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/location/location_auth_bloc.dart';
import 'package:narrid/dashboard/models/db/food_cart_model.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';
import 'package:narrid/dashboard/repositories/food/store/categories_repos.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/repositories/grocery/store/extimate_delivery_repos.dart';
import 'package:narrid/dashboard/screens/food/cart.dart';
import 'package:narrid/dashboard/screens/food/product.dart';
import 'package:narrid/dashboard/screens/grocery/grocery_search_view.dart';

var shipping_cost = "";

class Menus extends StatelessWidget {
  final storeId, name, image, city, lat, lng;
  Menus({
    Key key,
    @required this.storeId,
    @required this.name,
    @required this.image,
    @required this.city,
    @required this.lat,
    @required this.lng,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationAuthBloc>(
          create: (BuildContext context) =>
              LocationAuthBloc(locationRespos: LocationRespos())
                ..add(Started()),
        ),
        BlocProvider<StoreCategoriesBloc>(
          create: (BuildContext context) =>
              StoreCategoriesBloc(CategoryRepos())..add(CatStarted()),
        ),
        BlocProvider<DeliveryExBloc>(
          create: (BuildContext context) =>
              DeliveryExBloc(extimateDeliveryRepos: ExtimateDeliveryRepos())
                ..add(DeliveryExStarted(
                  lat: lat,
                  lng: lng,
                )),
        ),
        BlocProvider<CartHandlerBloc>(
          create: (BuildContext context) =>
              CartHandlerBloc(foodProductRep: FoodProductRep())
                ..add(CartHandlerStarted()),
        ),
      ],
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildContainerImage(),
              buildStoreDetails(),
              SizedBox(
                height: 10,
              ),
              Container(
                child: buildDefaultTabController(),
              )
            ],
          ),
        ),
        bottomNavigationBar: buildCartbutton(context),
      ),
    );
  }

  Widget buildCartbutton(BuildContext context) {
    return BlocBuilder<CartHandlerBloc, CartHandlerState>(
      builder: (context, state) {
        if (state is CartHandlerLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CartHandlerLoaded) {
          return buildCartAction(context, state);
        } else if (state is CartHandlerError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildCartAction(BuildContext context, state) {
    List<FoodCartHelper> carts = state.getCart;
    var buttonColor;
    var amount = 0;
    if (carts.length == 0) {
      buttonColor = Colors.red[200];
    } else {
      buttonColor = Colors.red;

      for (var i = 0; i < carts.length; i++) {
        var _price = carts[i].price;
        var _qty = carts[i].quantity;
        var price = int.parse(_price.replaceAll(".00", ""));
        amount += price * int.parse(_qty);
      }
    }

    return Padding(
      padding: EdgeInsets.all(18.0),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              buttonColor,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: () {
          if (carts.length == 0) {
            //don nothing
          } else {
            Route route = MaterialPageRoute(builder: (context) => CartFood());
            Navigator.push(context, route);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      7,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        100.0,
                      ),
                    ),
                    child: Text(
                      carts.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'NGN ${amount.toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'View Basket',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDefaultTabController() {
    return BlocBuilder<StoreCategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CatLoading) {
          return Align(
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(),
          );
        } else if (state is CatError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CatLoaded) {
          List<CategoriesModel> categories = state.getCategories;

          return DefaultTabController(
            length: categories.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ButtonsTabBar(
                  backgroundColor: Colors.red,
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  tabs: [
                    for (var cat in categories)
                      Tab(
                        text: cat.name,
                      ),
                  ],
                ),
                buildStoreProducts(categories),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildStoreProducts(categories) {
    return SizedBox(
      height: 1000,
      child: TabBarView(
        children: <Widget>[
          for (var item in categories)
            BlocProvider(
              create: (context) => FoodProductsBloc(FoodProductRep())
                ..add(ProductStarted(id: item.id, storeId: storeId)),
              child: BlocBuilder<FoodProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ProductError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ProductLoaded) {
                    List<ProductsModel> products = state.getProducts;

                    return Column(
                      children: [
                        for (var product in products)
                          menuProduct(product, context)
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget menuProduct(product, context) {
    return InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (context) => Product(
            image: product.image,
            id: product.id,
            name: product.name,
            price: product.price,
            shipping_cost: shipping_cost,
            lat: lat,
            lng: lng,
            storeId: storeId,
            city: city,
          ),
        );
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        padding: EdgeInsets.all(9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Html(
                      data: product.details,
                      defaultTextStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    AutoSizeText(
                      "NGN" + product.price,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 70,
                width: 70,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStoreDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
          ),
          child: BlocBuilder<DeliveryExBloc, DeliveryExState>(
            builder: (context, state) {
              if (state is DeliveryExSuccess) {
                Map<String, dynamic> data = state.getData;
                shipping_cost = data['distance_value'];
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 5,
                        ),
                        child: Text(city),
                      ),
                      state is DeliveryExLoading ? Text(".......") : Text(""),
                      state is DeliveryExError ? Text(".......") : Text(""),
                      state is DeliveryExSuccess
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delivery_dining,
                                ),
                                Text(
                                  "NGN " + state.getData['distance_value'],
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(""),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey[600],
                          ),
                          Text(
                            "Very good",
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      state is DeliveryExSuccess
                          ? Text("Within ${state.getData['duration_text']}")
                          : Text("....")
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildContainerImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            image,
          ),
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
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.yellow[800], //change your color here
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildStore() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            image,
            width: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  city,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                BlocBuilder<DeliveryExBloc, DeliveryExState>(
                  builder: (context, state) {
                    if (state is DeliveryExLoading) {
                      return Text(".......");
                    } else if (state is DeliveryExError) {
                      return Text(".......");
                    } else if (state is DeliveryExSuccess) {
                      Map<String, dynamic> data = state.getData;
                      shipping_cost = data['distance_value'];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delivery_dining,
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
      ),
    );
  }
}
