import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/order/order_bloc.dart';
import 'package:narrid/dashboard/bloc/grocery/order/product_image_bloc.dart';
import 'package:narrid/dashboard/models/store/order/order_product_modal.dart';
import 'package:narrid/dashboard/repositories/grocery/orders_repos.dart';

class Order extends StatelessWidget {
  final payment_status,
      delivery_status,
      sale_status,
      ref,
      grand_total,
      total,
      delivery,
      id;

  Order({
    @required this.delivery,
    @required this.delivery_status,
    @required this.grand_total,
    @required this.payment_status,
    @required this.ref,
    @required this.sale_status,
    @required this.total,
    @required this.id,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 15.0,
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        title: Text(
          "#$ref",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            GroceryOrderBloc(ordersRepository: GroceryOrdersRepository())
              ..add(Started(id: id)),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _buildSaleDetails(),
                SizedBox(
                  height: 10,
                ),
                _buildSaleProducts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaleDetails() {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      padding: EdgeInsets.all(9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order No: ${ref}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            "Delivery Status: ${delivery_status}",
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.green),
          ),
          SizedBox(
            height: 9,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text("Delivery Cost:"),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("NGN${delivery}"),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 9,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text("Sub Total:"),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("NGN${total}"),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 9,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text("Total:"),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("NGN${grand_total}"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaleProducts() {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      padding: EdgeInsets.all(9),
      child: BlocBuilder<GroceryOrderBloc, OrdersState>(
        builder: (context, state) {
          if (state is Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Loaded) {
            List<OrderProductModel> products = state.getOrders;
            for (var item in products) {
              print(item.id);
            }
            return Column(
              children: [
                for (var product in products)
                  Container(
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Row(children: [
                      BlocProvider(
                        create: (context) => GroceryProductImageBloc(
                            ordersRepository: GroceryOrdersRepository())
                          ..add(ImageStarted(id: product.id)),
                        child: BlocBuilder<GroceryProductImageBloc, OrderState>(
                          builder: (context, imagestate) {
                            if (imagestate is ImageLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (imagestate is ImageError) {
                              return Container(
                                padding: const EdgeInsets.all(5),
                                child: Image.network(
                                  "https://narrid.com/dev/template/assets/img/logo/logo.png",
                                  width: 70,
                                ),
                              );
                            } else if (imagestate is ImageLoaded) {
                              String img = imagestate.getImage;
                              return Container(
                                padding: const EdgeInsets.all(5),
                                child: Image.network(
                                  img,
                                  width: 70,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                product.name,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Amount: ${product.price}",
                                  style: TextStyle(
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "Quantity: ${product.qty}",
                                style: TextStyle(
                                  color: Colors.green[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
              ],
            );
          } else if (state is Error) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Text("err");
          }
        },
      ),
    );
  }
}
