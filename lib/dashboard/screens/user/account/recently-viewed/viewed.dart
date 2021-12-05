import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:narrid/dashboard/bloc/store/products/recently_viewed_bloc.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/store/products/product-repository.dart';
import 'package:narrid/utils/widgets/store/products/product-widget.dart';

class Viewed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecentlyViewedBloc(productRepository: ProductRepository())
            ..add(RecentlyViewStarted()),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [],
            title: Text(
              "Recently viewed products",
              style: TextStyle(color: Colors.grey[800]),
            ),
            iconTheme: IconThemeData(
              color: Colors.grey[800], //change your color here
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: BlocBuilder<RecentlyViewedBloc, RecentlyViewState>(
            builder: (context, state) {
              if (state is RecentlyViewLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RecentlyViewError) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is RecentlyViewLoaded) {
                List<ProductsModel> products = state.getProducts;
                if (products.isEmpty) {
                  return noViewContents();
                } else {
                  return viewContents(state, context);
                }
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget viewContents(state, context) {
    return ProductWidget(state: state, context: context);
  }

  Widget noViewContents() {
    return Center(
        child: Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/images/icons/view.svg",
            width: 50.0,
          ),
          Text(
            "No recently viewed products",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          )
        ],
      ),
    ));
  }
}
