import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:narrid/dashboard/bloc/user/account/wishlist/wishList_bloc.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/wishlist_repostory.dart';
import 'package:narrid/dashboard/screens/store/products/product.dart';

class WishList extends StatelessWidget {
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
          "WishList",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            WishListPageBloc(wishListRespo: WishListRepository())
              ..add(Started()),
        child: SingleChildScrollView(
          child: buildWishList(),
        ),
      ),
    );
  }

  Widget buildWishList() {
    return BlocBuilder<WishListPageBloc, WishListState>(
        builder: (context, state) {
      if (state is Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is Error) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is Loaded) {
        final List<ProductsModel> list = state.getWishList;

        return Column(
          children: [
            if (list.isNotEmpty)
              for (var i = 0; i < list.length; i++)
                Card(
                  child: Container(
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          child: InkWell(
                            onTap: () {
                              BlocProvider.of<WishListPageBloc>(context)
                                ..add(Remove(list[i].id));
                            },
                            child: Icon(
                              Icons.delete_forever_outlined,
                            ),
                          ),
                        ),
                        Image.network(
                          list[i].image,
                          width: 100,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Product(
                                    id: list[i].id,
                                    product_name: list[i].name,
                                    image: list[i].image.toString(),
                                  ),
                                ));
                          },
                          child: Container(
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  list[i].name,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                                Html(
                                  data: list[i].price,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset("assets/images/icons/empty-state-cart.svg"),
        SizedBox(height: 20),
        Text(
          "Wishlist is empty",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w200,
          ),
        )
      ],
    );
  }
}
