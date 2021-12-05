import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:narrid/core/amount_format.dart';
import 'package:narrid/dashboard/bloc/store/banner/ads_bloc.dart';
import 'package:narrid/dashboard/bloc/store/cart/cart_page_bloc.dart';
import 'package:narrid/dashboard/bloc/store/cart/cart_product_details.dart';
import 'package:narrid/dashboard/bloc/store/cart/checkout_cart_bloc.dart';
import 'package:narrid/dashboard/bloc/store/cart/checkout_cart_handler_bloc.dart';
import 'package:narrid/dashboard/bloc/user/auth/authentication_bloc.dart';
import 'package:narrid/dashboard/models/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/banner.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/store/checkout.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/banners/single-banner.dart';
import 'package:narrid/utils/widgets/store/custom_appbar.dart';

var myCartLength = 0;
var selectCart = 0;

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartPageBloc>(
          create: (BuildContext context) =>
              CartPageBloc(cartRepository: CartRepository())
                ..add(CartPageStarted()),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(authenticationRepository: UserRepository())
                ..add(AuthStarted()),
        ),
        BlocProvider<CheckoutCartBloc>(
          create: (context) =>
              CheckoutCartBloc(cartRepository: CheckoutCartRepository())
                ..add(CheckoutCartClearAll()),
        ),
        BlocProvider<CheckoutCartHandlerBloc>(
          create: (context) =>
              CheckoutCartHandlerBloc(cartRepository: CartRepository()),
        ),
        BlocProvider(
          create: (context) => AdsBannerBloc(BannersRep())..add(AdsStarted()),
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(),
              buildAdsBanner(context),
              BuildCartState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAdsBanner(BuildContext context) {
    return BlocBuilder<AdsBannerBloc, AdsBannerState>(
      builder: (context, state) {
        if (state is AdsLoading) {
          return ShimmerProductDescription();
        } else if (state is AdsLoaded) {
          List<BannersModel> banners = state.getBanners;
          return SingleBanners(myContext: context).paidAds(
            banners[0].url,
            banners[0].image,
          );
        } else if (state is AdsError) {
          return ShimmerProductDescription();
        } else {
          return Container();
        }
      },
    );
  }
}

class BuildCartState extends StatefulWidget {
  const BuildCartState({
    Key key,
  }) : super(key: key);

  @override
  _BuildCartStateState createState() => _BuildCartStateState();
}

class _BuildCartStateState extends State<BuildCartState> {
  bool _checkAll = false;
  List<bool> _checkboxes = new List<bool>.filled(myCartLength + 1, false);
  @override
  void initState() {
    selectCart = 0;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CheckoutCartBloc>(context)..add(CheckoutCartClearAll());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartPageBloc, CartPageState>(
      builder: (context, state) {
        if (state is CartPageEmpty) {
          return _loadEmptyState();
        } else if (state is CartPageError) {
          return _loadErrorState();
        } else if (state is CartPageLoaded) {
          //load the total Amount
          BlocProvider.of<CheckoutCartHandlerBloc>(context)
            ..add(CartHandlerStarted());
          return _loadPageCart(state, context);
        } else if (state is CartPageLoading) {
          return _loadPageLoading();
        } else {
          return Container();
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
    List<CartHelper> carts = state.getCartList;
    var _lenght = carts.length;

    var _cartTitle = "Cart($_lenght)";
    myCartLength = _lenght;

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
                InkWell(
                  onTap: () {
                    BlocProvider.of<CartPageBloc>(context)
                      ..add(CartRemoveSelected());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.delete,
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < carts.length; i++)
            Card(
              child: separateMethod(i, context, carts),
            ),
          SizedBox(
            height: 20,
          ),
          _buildContineButton(context, _checkboxes),
        ],
      ),
    );
  }

  Widget separateMethod(int i, context, List<CartHelper> carts) {
    return BlocProvider(
      create: (context) =>
          CartProductDetailsBloc(cartRepository: CartRepository())
            ..add(DStarted(id: carts[i].id)),
      child: Container(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          children: [
            Container(
              child: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                value: _checkboxes[i],
                onChanged: (v) {
                  setState(() {
                    _checkboxes[i] = v;
                    if (v == true) {
                      //add to checkoutCart
                      BlocProvider.of<CheckoutCartBloc>(context)
                        ..add(AddSingleToCheckoutChart(
                          id: carts[i].id,
                          product_name: carts[i].product_name,
                          qty: carts[i].quantity,
                          variant: carts[i].variant,
                          variantName: carts[i].variantName,
                          variantPrice: carts[i].price,
                          image: carts[i].image,
                        ));

                      //get the total amount
                      BlocProvider.of<CheckoutCartHandlerBloc>(context)
                        ..add(CartHandlerStarted());
                      selectCart += 1;
                    } else {
                      //remove from checkoutcart
                      BlocProvider.of<CheckoutCartBloc>(context)
                        ..add(RemoveSingleToCheckoutChart(id: carts[i].id));

                      //get the total amount
                      BlocProvider.of<CheckoutCartHandlerBloc>(context)
                        ..add(CartHandlerStarted());
                      selectCart -= 1;
                    }
                  });
                },
              ),
            ),
            cartProductDetails(carts, i),
            Column(
              children: [
                Image.network(
                  carts[i].image,
                  width: 70,
                ),
                buildQtyChange(carts[i].id, context, carts[i].quantity),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cartProductDetails(List<CartHelper> carts, int i) {
    return Container(
      margin: EdgeInsets.only(
        left: 4,
      ),
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<CartProductDetailsBloc, CartProductDState>(
            builder: (context, state) {
              if (state is DLoading) {
                return Text("");
              } else if (state is DError) {
                return Text("");
              } else if (state is DLoaded) {
                Map<String, dynamic> data = state.getData;
                return Text(
                  "${data['category']}",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                );
              } else {
                return Text("");
              }
            },
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            carts[i].product_name,
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AmountFormat().am(carts[i].price.toString()),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(carts[i].variantName),
                        SizedBox(
                          width: 5,
                        ),
                        (carts[i].color == null || carts[i].color == "")
                            ? Text("")
                            : Text("Red"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
    );
  }

  Widget _buildContineButton(context, _checkboxes) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(""),
              ],
            ),
            Row(
              children: [
                BlocBuilder<CheckoutCartHandlerBloc, CheckoutCartHandlerState>(
                  builder: (context, state) {
                    if (state is CheckoutCartHandlerLoading) {
                      return Text(
                        "N0.00",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (state is CheckoutCartHandlerLoaded) {
                      List<CartHelper> carts = state.getCart;
                      var amount = 0;
                      for (var i = 0; i < carts.length; i++) {
                        var _price = carts[i].price;
                        var _qty = carts[i].quantity;
                        var price = int.parse(_price.replaceAll(".00", ""));
                        amount += price * int.parse(_qty);
                      }
                      return Text(
                        '${AmountFormat().am(amount.toString())}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (state is CartHandlerError) {
                      return Text(
                        "NGN0.00",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 50,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        )),
                    onPressed: () async {
                      if (state is AuthenticationUninitialized) {
                      } else if (state is AuthenticationAuthenticated) {
                        //make sure the user have selected item to purchase
                        if (selectCart != 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckOut()));
                        } else {
                          //add everthing to checkout cart
                          await moveToCheckOutCart(context);
                        }
                      } else if (state is AuthenticationUnauthenticated) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login(
                                      userRepository: UserRepository(),
                                      route: 'cart_store',
                                    )));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Continue (${selectCart.toString()})",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //move to checkout cart
  Future<void> moveToCheckOutCart(context) async {
    CheckoutCartRepository checkoutCartRepository = CheckoutCartRepository();
    await checkoutCartRepository.insertAll();
    //naviagate to checkout page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CheckOut()));
  }

  Widget buildQtyChange(id, context, qty) {
    return Card(
      child: Container(
        margin: const EdgeInsets.only(top: 9),
        // padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<CartPageBloc>(context)
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
                    BlocProvider.of<CartPageBloc>(context)
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
