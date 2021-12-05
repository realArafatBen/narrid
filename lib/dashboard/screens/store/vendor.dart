import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/products/vendor_product_bloc.dart';
import 'package:narrid/dashboard/repositories/store/categories/product-category.dart';
import 'package:narrid/utils/widgets/store/products/product-widget.dart';

class Vendor extends StatelessWidget {
  final vendorId;
  final vendorName;
  Vendor({@required this.vendorId, @required this.vendorName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        title: Text(
          vendorName,
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            VendorProductBloc(ProductCategoriesRepos())..add(Started(vendorId)),
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: BlocBuilder<VendorProductBloc, VendorProductState>(
            builder: (context, state) {
              if (state is Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is Loaded) {
                return ProductWidget(state: state, context: context);
              } else if (state is ErrorLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
