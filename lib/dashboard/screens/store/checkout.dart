import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/core/amount_format.dart';
import 'package:narrid/dashboard/bloc/user/account/address/defauth_address_bloc.dart';
import 'package:narrid/dashboard/bloc/user/checkout_product_bloc.dart';
import 'package:narrid/dashboard/bloc/user/shipping_cost_bloc.dart';
import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';
import 'package:narrid/dashboard/repositories/user/account/address_repos.dart';
import 'package:narrid/dashboard/repositories/user/account/shipping_cost.dart';
import 'package:narrid/dashboard/screens/store/paystack_store.dart';
import 'package:narrid/dashboard/screens/user/account/others/address/add_address.dart';
import 'package:narrid/dashboard/screens/user/account/others/address/address_book.dart';
import 'package:narrid/utils/ui/shimmer.dart';

var cartSubTotal = 0;
var cartShippingTotal = 0;
var cartTotal = 0;
var setAddress = false;

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Checkout",
          style: TextStyle(color: Colors.grey[800]),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<DefauthAddressBloc>(
            create: (context) =>
                DefauthAddressBloc(addressRepos: AddressRepos())
                  ..add(DefauthAddressStarted()),
          ),
          BlocProvider<CheckoutProductBloc>(
            create: (create) =>
                CheckoutProductBloc(cartRepository: CheckoutCartRepository())
                  ..add(CheckoutProductStarted()),
          ),
          BlocProvider<ShippingCostBloc>(
            create: (create) =>
                ShippingCostBloc(shippingCostResp: ShippingCostResp())
                  ..add(ShippingCostStarted()),
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
                _buildAddress(),
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

  Widget _buildAddress() {
    return BlocBuilder<DefauthAddressBloc, DefauthAddressState>(
      builder: (context, state) {
        if (state is DefauthAddressLoading) {
          return ShimmerCheckoutAddress();
        } else if (state is DefauthAddressLoaded) {
          Map<String, dynamic> address = state.getAddress;

          if (address['status'] == 'empty') {
            setAddress = false;
            return _buildEmptyAddress(context);
          } else {
            setAddress = true;
            var first_name = address['first_name'];
            var last_name = address['last_name'];
            var myaddress = address['address'];
            var line1 = address['line1'];
            var city = address['city'];
            var region = address['region'];
            return Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    first_name + " " + last_name,
                    style: __textStyle(),
                  ),
                  Text(
                    myaddress,
                    style: __textStyle(),
                  ),
                  Text(
                    region,
                    style: __textStyle(),
                  ),
                  Text(
                    city,
                    style: __textStyle(),
                  ),
                  Text(
                    line1,
                    style: __textStyle(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 2,
                    thickness: 1,
                  ),
                  Container(
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddressBook()));
                        },
                        icon: Icon(Icons.edit_outlined),
                        label: Text("Edit Address"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        } else if (state is DefaultAddressError) {
          return ShimmerCheckoutAddress();
        } else {
          return ShimmerCheckoutAddress();
        }
      },
    );
  }

  Widget _buildEmptyAddress(context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: TextButton.icon(
          onPressed: () {
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => AddAddress()));

            Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddAddress()))
                .then((_) {
              // This block runs when you have come back to the 1st Page from 2nd.
              setState(() {
                // Call setState to refresh the page.
                BlocProvider.of<DefauthAddressBloc>(context)
                  ..add(DefauthAddressStarted());
              });
            });
          },
          icon: Icon(Icons.add),
          label: Text("Add Address"),
        ),
      ),
    );
  }

  Widget _buildProducts() {
    return BlocBuilder<CheckoutProductBloc, CheckoutProductState>(
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

  Widget _buildGetProduct(cart) {
    int qty = int.parse(cart.quantity);
    String __price = cart.price;
    int price = int.parse(__price.replaceAll(".00", ""));
    int total = qty * price;
    cartSubTotal = cartSubTotal + total;
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(cart.product_name),
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
                    AmountFormat().am(total.toString()),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ),
        __buildSpace(),
      ],
    );
  }

  Widget _buildCartProduct(state) {
    List<CartHelper> cart = state.getCart;
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

  Widget _buildTotalAmount() {
    return BlocBuilder<ShippingCostBloc, ShippingCostState>(
      builder: (context, state) {
        if (state is ShippingCostLoading) {
          return ShimmerCheckoutAddress();
        } else if (state is ShippingCostLoaded) {
          Map<String, dynamic> shippingCost = state.getCost;
          String _shippingCost = shippingCost['shipping_cost'];
          cartShippingTotal = int.parse(_shippingCost.replaceAll(".00", ''));
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
                        AmountFormat().am(cartSubTotal.toString()),
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
                        AmountFormat().am(cartShippingTotal.toString()),
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
                        AmountFormat().am(cartTotal.toString()),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is ShippingCostError) {
          return ShimmerCheckoutAddress();
        } else {
          return ShimmerCheckoutAddress();
        }
      },
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
            if (setAddress) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PaystackStore(
                      shipping: cartShippingTotal,
                      subTotal: cartSubTotal,
                      total: cartTotal)));
            } else {
              final snackBar = SnackBar(
                content: Text(
                    "You need to add your delivery address before checkout"),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
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
