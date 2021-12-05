import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:narrid/dashboard/bloc/food/products/cart_page_bloc.dart';
import 'package:narrid/dashboard/bloc/store/cart/cart_product_details.dart';
import 'package:narrid/dashboard/bloc/user/auth/authentication_bloc.dart';
import 'package:narrid/dashboard/models/db/food_cart_model.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/food/checkout.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';

class CartFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartGroceryBloc>(
          create: (BuildContext context) =>
              CartGroceryBloc(foodProductRep: FoodProductRep())
                ..add(CartPageStarted()),
        ),
        BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc(authenticationRepository: UserRepository())
                  ..add(AuthStarted())),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Cart",
              style: TextStyle(
                color: Colors.grey[900],
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.yellow[800], //change your color here
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: buildCartState(),
          ),
        ),
      ),
    );
  }

  Widget buildCartState() {
    return BlocBuilder<CartGroceryBloc, CartState>(
      builder: (context, state) {
        if (state is CartPageEmpty) {
          return _loadEmptyState();
        } else if (state is CartPageError) {
          return _loadErrorState();
        } else if (state is CartPageLoaded) {
          return _loadPageCart(state, context);
        } else if (state is CartPageLoading) {
          return _loadPageLoading();
        } else {
          return Container(
            child: Text("error"),
          );
        }
      },
    );
  }

  Widget _loadEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset("assets/images/icons/empty-state-cart.svg"),
        SizedBox(height: 20),
        Text(
          "Cart is empty",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w200,
          ),
        )
      ],
    );
  }

  Widget _loadErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset("assets/images/icons/empty-state-cart.svg"),
        SizedBox(height: 20),
        Text(
          "Oops there was an error loading the cart",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w200,
          ),
        )
      ],
    );
  }

  Widget _loadPageCart(state, context) {
    List<FoodCartHelper> carts = state.getCartList;
    var _lenght = carts.length;
    var _cartTitle = "Cart($_lenght)";

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_cartTitle),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: null,
                ),
              ],
            ),
          ),
          for (var i = 0; i < carts.length; i++)
            separateMethod(context, carts, i),
          SizedBox(
            height: 20,
          ),
          _buildContineButton(context),
        ],
      ),
    );
  }

  Widget separateMethod(context, List<FoodCartHelper> carts, int i) {
    return BlocProvider(
      create: (context) =>
          CartProductDetailsBloc(cartRepository: CartRepository())
            ..add(DStarted(id: carts[i].id)),
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<CartGroceryBloc>(context)
                      ..add(CartPageRemove(id: carts[i].id));
                  },
                  child: Icon(
                    Icons.delete_forever_outlined,
                  ),
                ),
              ),
              productDetails(carts, i),
              Column(
                children: [
                  Image.network(
                    carts[i].image,
                    width: 100,
                  ),
                  buildQtyChange(carts[i].id, context, carts[i].quantity),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productDetails(List<FoodCartHelper> carts, int i) {
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            carts[i].product_name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "NGN " + carts[i].price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<CartProductDetailsBloc, CartProductDState>(
                      builder: (context, state) {
                        if (state is DLoading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("--"),
                              Text("---"),
                              Text("--"),
                            ],
                          );
                        } else if (state is DLoaded) {
                          Map<String, dynamic> data = state.getData;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order in ${data['orderIn']}"),
                              Text("Arrives within ${data['extimate']}"),
                              Text("sold by ${data['store']}"),
                            ],
                          );
                        } else if (state is DError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("--"),
                              Text("---"),
                              Text("--"),
                            ],
                          );
                        } else {
                          return Text("");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContineButton(context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.black,
              ),
            ),
            onPressed: () {
              if (state is AuthenticationUninitialized) {
              } else if (state is AuthenticationAuthenticated) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Checkout()));
              } else if (state is AuthenticationUnauthenticated) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login(
                              userRepository: UserRepository(),
                              route: "cart_food",
                            )));
              }
            },
            child: Text("Continue"),
          ),
        );
      },
    );
  }

  Widget buildQtyChange(id, context, qty) {
    return Card(
      child: Container(
        margin: const EdgeInsets.only(top: 9),
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<CartGroceryBloc>(context)
                      ..add(CartPageMinus(id: id, qty: qty));
                  },
                  child: Container(
                    child: Icon(Icons.remove),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Text(
                  qty,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<CartGroceryBloc>(context)
                      ..add(CartPageAdd(id: id, qty: qty));
                  },
                  child: Container(
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loadPageLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
