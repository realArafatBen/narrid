import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/cart/cart_handler_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/products/cart_product_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/products/products_bloc.dart';
import 'package:narrid/dashboard/models/db/grocery_cart_model.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/grocery/products/products_repos.dart';
import 'package:narrid/dashboard/screens/grocery/cart.dart';
import 'package:narrid/dashboard/screens/grocery/grocery_search_view.dart';
import 'package:narrid/dashboard/screens/grocery/product.dart';

class Products extends StatelessWidget {
  final catName, catImage, catId, storeId, storeName, shipping_cost;

  Products({
    Key key,
    @required this.catName,
    @required this.catImage,
    @required this.catId,
    @required this.storeId,
    @required this.storeName,
    @required this.shipping_cost,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroceryProductsBloc>(
          create: (BuildContext context) =>
              GroceryProductsBloc(GroceryProductRep())
                ..add(ProductStarted(id: catId, storeId: storeId)),
        ),
        BlocProvider<CartHandlerBloc>(
          create: (BuildContext context) =>
              CartHandlerBloc(groceryProductRep: GroceryProductRep())
                ..add(CartHandlerStarted()),
        ),
      ],
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildProducts(),
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

  Widget buildAppBar(context) {
    return AppBar(
      title: Text(
        storeName,
        style: TextStyle(
          color: Colors.grey[900],
        ),
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

  Widget buildProducts() {
    return BlocBuilder<GroceryProductsBloc, ProductsState>(
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
          return __getProducts(state, context);
        }
      },
    );
  }

  Widget __getProducts(state, context) {
    List<ProductsModel> products = state.getProducts;

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.all(2),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(3),
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        children: [
          for (var i = 0; i < products.length; i++)
            InkWell(
              onTap: () {
                Route route = MaterialPageRoute(
                    builder: (context) => Product(
                          image: products[i].image,
                          id: products[i].id,
                          name: products[i].name,
                          price: products[i].price,
                          shipping_cost: shipping_cost,
                        ));
                Navigator.push(context, route);
              },
              child: BlocProvider(
                create: (context) => ProductCartBloc(GroceryProductRep())
                  ..add(CartStarted(id: products[i].id)),
                child: Container(
                  child: BlocBuilder<ProductCartBloc, CartState>(
                    builder: (context, cartState) {
                      if (cartState is CartLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (cartState is CartLoaded) {
                        List<Map<String, dynamic>> carts = cartState.getCarts;
                        return Container(
                          color: Colors.white,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.only(
                            top: 2,
                            left: 8,
                            right: 8,
                            bottom: 0,
                          ),
                          child: Column(
                            children: [
                              Image.network(
                                products[i].image,
                                width: 70,
                              ),
                              /**
                              * if the cart is empty
                              *
                              * */
                              if (carts.length == 0)
                                buildCartEmpty(
                                  context,
                                  products[i].id,
                                  products[i].name,
                                  products[i].price,
                                  products[i].image,
                                ),
                              /**
                              * If the cart is not empty
                              **/
                              if (carts.length == 1)
                                _buildCartNotEmpty(carts, context),
                              AutoSizeText(
                                products[i].name,
                                style: TextStyle(
                                  color: Colors.grey[900],
                                ),
                              ),
                              AutoSizeText(
                                "NGN" + products[i].price,
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (cartState is CartError) {
                        return Text("Error");
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildCartEmpty(context, id, name, price, image) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: () {
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
          BlocProvider.of<CartHandlerBloc>(context)..add(CartHandlerStarted());
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.add,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartNotEmpty(carts, context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 9,
        bottom: 10,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(9),
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
