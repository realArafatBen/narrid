import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/food/products/cart_product_bloc.dart';
import 'package:narrid/dashboard/bloc/food/products/products_bloc.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/food/products/products_repos.dart';
import 'package:narrid/dashboard/screens/food/cart.dart';
import 'package:narrid/dashboard/screens/food/product.dart';

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
        BlocProvider<FoodProductsBloc>(
          create: (BuildContext context) => FoodProductsBloc(FoodProductRep())
            ..add(ProductStarted(id: catId, storeId: storeId)),
        ),
      ],
      child: Scaffold(
        appBar: buildAppBar(),
        body: buildProducts(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.0),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (context) => CartFood());
              Navigator.push(context, route);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Go to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            decoration: InputDecoration(
                hintText: "What are you looking for?",
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[900],
                  ),
                )),
          ),
        ),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.yellow[800], //change your color here
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget buildProducts() {
    return BlocBuilder<FoodProductsBloc, ProductsState>(
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
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(9),
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
                create: (context) => ProductCartBloc(FoodProductRep())
                  ..add(CartStarted(id: products[i].id)),
                child: Container(
                  child: BlocBuilder<ProductCartBloc, CartState>(
                    builder: (context, cartState) {
                      if (cartState is CartLoading) {
                        return Text("Loading");
                      } else if (cartState is CartLoaded) {
                        List<Map<String, dynamic>> carts = cartState.getCarts;
                        return Column(
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
    );
  }
}
