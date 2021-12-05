import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/food/products/cart_product_bloc.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';
import 'package:narrid/dashboard/screens/food/menus.dart';

var is_in = false;

class Product extends StatelessWidget {
  final image, id, name, price, shipping_cost, storeId, lat, lng, city;
  Product({
    Key key,
    @required this.image,
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.shipping_cost,
    @required this.storeId,
    @required this.lat,
    @required this.lng,
    @required this.city,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCartBloc>(
            create: (BuildContext context) =>
                ProductCartBloc(FoodProductRep())..add(CartStarted(id: id))),
      ],
      child: Scaffold(
        appBar: buildAppBar(),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImage(),
                SizedBox(
                  height: 10,
                ),
                _buildName(),
                SizedBox(
                  height: 10,
                ),
                _buildPrice(),
                SizedBox(
                  height: 10,
                ),
                _buildAddToCart(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CartButton(
          image,
          id,
          name,
          price,
          shipping_cost,
          storeId,
          lat,
          lng,
          city,
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: AutoSizeText(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: false,
      iconTheme: IconThemeData(
        color: Colors.yellow[800], //change your color here
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildImage() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildName() {
    return Container(
      child: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      child: Text(
        "NGN" + price,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddToCart() {
    return BlocBuilder<ProductCartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CartLoaded) {
          List<Map<String, dynamic>> carts = state.getCarts;
          if (carts.length == 0) {
            is_in = false;
          } else {
            is_in = true;
            return _buildCartNotEmpty(carts, context);
          }
        } else if (state is CartError) {
          return Text("Error");
        }
        return Container();
      },
    );
  }

  Widget _buildCartNotEmpty(carts, context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 9,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                bottom: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<ProductCartBloc>(context)
                          ..add(CartMinus(
                              id: carts[0]['productId'].toString(),
                              qty: carts[0]['quantity'].toString()));
                      },
                      child: Icon(
                        Icons.remove,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(carts[0]['quantity'].toString()),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<ProductCartBloc>(context)
                          ..add(AddToCart(
                              id: carts[0]['productId'].toString(),
                              qty: carts[0]['quantity'].toString()));
                      },
                      child: Icon(
                        Icons.add,
                      ),
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
}

class CartButton extends StatelessWidget {
  final image, id, name, price, shipping_cost, storeId, lat, lng, city;

  CartButton(
    this.image,
    this.id,
    this.name,
    this.price,
    this.shipping_cost,
    this.storeId,
    this.lat,
    this.lng,
    this.city,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.red,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: () {
          if (is_in == false) {
            BlocProvider.of<ProductCartBloc>(context)
              ..add(CartInsertCart(
                id: id,
                product_name: name,
                price: price,
                image: image,
                qty: '1',
                shipping_cost: shipping_cost,
              ));
          } else {
            //do nothing, just replace the screen
          }

          Route route = MaterialPageRoute(
              builder: (context) => Menus(
                    image: image,
                    storeId: storeId,
                    lat: lat,
                    name: name,
                    lng: lng,
                    city: city,
                  ));
          Navigator.pushReplacement(context, route);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NGN ${price.toString()}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Add to Basket',
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
}
