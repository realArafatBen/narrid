import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:narrid/dashboard/bloc/user/account/order/order_image_bloc.dart';
import 'package:narrid/dashboard/bloc/user/account/order/orders_bloc.dart';
import 'package:narrid/dashboard/models/store/order/order_modal.dart';
import 'package:narrid/dashboard/repositories/user/account/orders_repos.dart';
import 'package:narrid/dashboard/screens/user/account/orders/order.dart';

class Orders extends StatelessWidget {
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
          "Orders",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            OrdersBloc(ordersRepository: OrdersRepository())..add(Started()),
        child: SingleChildScrollView(
          child: buildOrderList(),
        ),
      ),
    );
  }

  Widget buildOrderList() {
    return BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
      if (state is Loading) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is Error) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is Loaded) {
        final List<OrderModel> list = state.getOrders;

        return Column(
          children: [
            if (list.isNotEmpty)
              for (var i = 0; i < list.length; i++)
                Card(
                  child: Container(
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Row(
                      children: [
                        BlocProvider(
                          create: (context) => OrderImageBloc(
                              ordersRepository: OrdersRepository())
                            ..add(ImageStarted(id: list[i].id)),
                          child: BlocBuilder<OrderImageBloc, OrderState>(
                            builder: (context, imagestate) {
                              if (imagestate is ImageLoading) {
                                return Center(
                                    child: CircularProgressIndicator());
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserOrder(
                                    ref: list[i].ref,
                                    sale_status: list[i].sale_status,
                                    payment_status: list[i].payment_status,
                                    delivery: list[i].delivery,
                                    delivery_status: list[i].delivery_status,
                                    grand_total: list[i].grand_total,
                                    total: list[i].total,
                                    id: list[i].id,
                                  ),
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  list[i].ref,
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
                                    "Amount: NGN${list[i].total}",
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Status: ${list[i].delivery_status}",
                                  style: TextStyle(
                                    color: Colors.green[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            SizedBox(
              height: 20,
            ),
            if (list.isEmpty) _loadEmptyState()
          ],
        );
      }
    });
  }

  Widget _loadEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset("assets/images/icons/empty-state-cart.svg"),
          SizedBox(height: 20),
          Text(
            "Order is empty",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }
}
