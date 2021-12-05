import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/location/delivery_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/location/location_auth_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/store/categories_bloc.dart';
import 'package:narrid/dashboard/models/store/categories/categories.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/repositories/grocery/store/categories_repos.dart';
import 'package:narrid/dashboard/repositories/grocery/store/extimate_delivery_repos.dart';
import 'package:narrid/dashboard/screens/grocery/grocery_search_view.dart';
import 'package:narrid/dashboard/screens/grocery/products.dart';

var shipping_cost = "";

class StoreCategories extends StatelessWidget {
  final storeId, name, image, city, lat, lng;
  StoreCategories({
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
      ],
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _buildStore(),
                SizedBox(
                  height: 5,
                ),
                _buildCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(context) {
    return AppBar(
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

  Widget _buildCategories() {
    return BlocBuilder<StoreCategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CatLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CatError) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CatLoaded) {
          return _buildCateory(state, context);
        }
      },
    );
  }

  Widget _buildCateory(state, context) {
    List<CategoriesModel> categories = state.getCategories;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Categories",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(3),
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            crossAxisCount: 3,
            children: [
              for (var cat in categories)
                InkWell(
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => Products(
                              catId: cat.id,
                              catName: cat.name,
                              catImage: cat.image,
                              storeId: storeId,
                              storeName: name,
                              shipping_cost: shipping_cost,
                            ));
                    Navigator.push(context, route);
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      child: Column(
                        children: [
                          AutoSizeText(
                            cat.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 15,
                            ),
                          ),
                          Image.network(
                            cat.image,
                            width: 70,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
