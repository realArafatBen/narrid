import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/cart/cart_handler_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/products/cart_product_bloc.dart';
import 'package:narrid/dashboard/models/db/grocery_cart_model.dart';
import 'package:narrid/dashboard/repositories/grocery/products/products_repos.dart';
import 'package:narrid/dashboard/screens/grocery/cart.dart';

class Product extends StatelessWidget {
  final image, id, name, price, shipping_cost;
  Product({
    Key key,
    @required this.image,
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.shipping_cost,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCartBloc>(
          create: (BuildContext context) =>
              ProductCartBloc(GroceryProductRep())..add(CartStarted(id: id)),
        ),
        BlocProvider<CartHandlerBloc>(
          create: (BuildContext context) =>
              CartHandlerBloc(groceryProductRep: GroceryProductRep())
                ..add(CartHandlerStarted()),
        ),
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
        }
      },
    );
  }

  Widget buildCartAction(BuildContext context, state) {
    List<GroceryCartHelper> carts = state.getCart;
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
            Route route =
                MaterialPageRoute(builder: (context) => CartGrocery());
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
          return Text("-----");
        } else if (state is CartLoaded) {
          List<Map<String, dynamic>> carts = state.getCarts;
          if (carts.length == 0) {
            return buildCartEmpty(context);
          } else {
            return _buildCartNotEmpty(carts, context);
          }
        } else if (state is CartError) {
          return Text("-----");
        }
        return Container();
      },
    );
  }

  Widget buildCartEmpty(context) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              onPressed: () {
                BlocProvider.of<ProductCartBloc>(context)
                  ..add(CartInsertCart(
                    id: id,
                    product_name: name,
                    price: price,
                    image: image,
                    qty: '1',
                    shipping_cost: shipping_cost,
                  ));
                //cart handler
                BlocProvider.of<CartHandlerBloc>(context)
                  ..add(CartHandlerStarted());
              },
              icon: Icon(
                Icons.add,
              ),
              label: Text("Add to Cart"),
            )),
      ),
    );
  }

  Widget _buildCartNotEmpty(carts, context) {
    return Container(
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
                    //cart handler
                    BlocProvider.of<CartHandlerBloc>(context)
                      ..add(CartHandlerStarted());
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
                    //cart handler
                    BlocProvider.of<CartHandlerBloc>(context)
                      ..add(CartHandlerStarted());
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
    );
  }
}
