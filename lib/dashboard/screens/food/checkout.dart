import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/food/products/checkout_food_bloc.dart';
import 'package:narrid/dashboard/models/db/food_cart_model.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';
import 'package:narrid/dashboard/screens/food/paystack_food.dart';
import 'package:narrid/utils/ui/shimmer.dart';

var cartSubTotal = 0;
var cartShippingTotal = 0;
var cartTotal = 0;

class Checkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider<CheckoutFoodBloc>(
            create: (create) =>
                CheckoutFoodBloc(foodProductRep: FoodProductRep())
                  ..add(CheckoutProductStarted()),
          ),
        ],
        child: Container(
          color: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _buildProducts(),
                SizedBox(
                  height: 10,
                ),
                _buildTotalAmount(),
                SizedBox(
                  height: 10,
                ),
                _buildCheckoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalAmount() {
    return BlocBuilder<CheckoutFoodBloc, CheckoutProductState>(
      builder: (context, state) {
        if (state is CheckoutProductLoading) {
          return ShimmerCheckoutAddress();
        } else if (state is CheckoutProductLoaded) {
          cartTotal = cartSubTotal + cartShippingTotal;
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Sub Total"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "NGN " + cartSubTotal.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                __buildSpace(),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Shipping Cost"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "NGN " + cartShippingTotal.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                __buildSpace(),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Total"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "NGN " + cartTotal.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is CheckoutProductError) {
          return ShimmerCheckoutAddress();
        } else {
          return ShimmerCheckoutAddress();
        }
      },
    );
  }

  Widget _buildProducts() {
    return BlocBuilder<CheckoutFoodBloc, CheckoutProductState>(
      builder: (context, state) {
        if (state is CheckoutProductLoading) {
          return ShimmerCheckoutAddress();
        } else if (state is CheckoutProductLoaded) {
          return _buildCartProduct(state);
        } else if (state is CheckoutProductError) {
          return ShimmerCheckoutAddress();
        } else {
          return null;
        }
      },
    );
  }

  Widget _buildCartProduct(state) {
    List<FoodCartHelper> cart = state.getCart;
    //clear the cart sub total, shipping total and cart total
    cartSubTotal = 0;
    cartShippingTotal = 0;
    cartTotal = 0;
    //clear here
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          for (var i = 0; i < cart.length; i++) _buildGetProduct(cart[i]),
        ],
      ),
    );
  }

  Widget _buildGetProduct(cart) {
    int qty = int.parse(cart.quantity);
    String __price = cart.price;
    String __shipping = cart.shipping_cost;
    int price = int.parse(__price.replaceAll(".00", ""));
    int shipping = int.parse(__shipping.replaceAll(".00", ""));
    int total = qty * price;
    cartSubTotal = cartSubTotal + total;
    cartShippingTotal = cartShippingTotal + shipping;

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(cart.product_name),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "X " + cart.quantity,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "NGN " + total.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Delivery cost",
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "NGN " + shipping.toString(),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        __buildSpace(),
      ],
    );
  }

  TextStyle __textStyle() {
    return TextStyle(
      fontSize: 12,
      color: Colors.grey[800],
    );
  }

  Widget __buildSpace() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Divider(
          height: 2,
          thickness: 1,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(context) {
    return Container(
      margin: const EdgeInsets.all(9),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PaystackFood(
                    shipping: cartShippingTotal,
                    subTotal: cartSubTotal,
                    total: cartTotal)));
          },
          child: Text("Checkout"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
