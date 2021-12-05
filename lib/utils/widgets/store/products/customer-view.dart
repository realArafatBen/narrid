import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:narrid/dashboard/bloc/store/products/customer_view_bloc.dart';
import 'package:narrid/utils/ui/shimmer.dart';
import 'package:narrid/utils/widgets/store/products/product-widget-x.dart';

class BuildCustomerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerViewBloc, CustomerViewState>(
      builder: (context, state) {
        if (state is CustomerLoading) {
          return ShimmerSlideProduct();
        } else if (state is CustomerLoaded) {
          return ProductWidgetX(state: state, context: context);
        } else if (state is CustomerErrorLoading) {
          return ShimmerSlideProduct();
        } else {
          return null;
        }
      },
    );
  }
}
