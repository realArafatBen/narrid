import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/store/bottomnavigation_bloc.dart';
import 'package:narrid/dashboard/bloc/store/cart/cart_count_bloc.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

int selectedIndex = 0;

class BottomNavigationBuilder extends StatefulWidget {
  @override
  _BottomNavigationBuilderState createState() =>
      _BottomNavigationBuilderState();
}

class _BottomNavigationBuilderState extends State<BottomNavigationBuilder> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomnavigationBloc, BottomnavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 2.0,
          unselectedItemColor: Colors.grey[900],
          selectedItemColor: HexColor("f1df00"),
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (int index) {
            selectedIndex = index;
            BlocProvider.of<BottomnavigationBloc>(context)
                .add(PageTapped(index: index));
          },
          items: bottomNavItems(context),
        );
      },
    );
  }

  List<BottomNavigationBarItem> bottomNavItems(context) {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: bottomIcons('assets/images/icons/home.svg'),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: bottomIcons('assets/images/icons/account.svg'),
        label: "Account",
      ),
      BottomNavigationBarItem(
        icon: bottomIcons('assets/images/icons/categories.svg'),
        label: "Categories",
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/icons/trending-inactive.png'),
        label: "Trending",
      ),
      BottomNavigationBarItem(
        icon: bottomIcons('assets/images/icons/cart.svg'),
        label: "Cart",
      ),
      BottomNavigationBarItem(
        icon: bottomIcons('assets/images/icons/headphones.svg'),
        label: "Help",
      ),
    ];
  }

  Container bottomIcons(src) {
    return Container(
      width: 25,
      height: 25,
      child: SvgPicture.asset(src),
    );
  }

  Widget _buildCartCount(context) {
    return BlocProvider(
      create: (context) => CartCountBloc(cartRepository: CartRepository())
        ..add(CartCountStarted()),
      child:
          BlocBuilder<CartCountBloc, CartCountState>(builder: (context, state) {
        if (state is CartCountLoading) {
          return Text("0");
        } else if (state is CartCountLoaded) {
          String count = state.getCount;
          return Text("$count");
        } else if (state is CartCountError) {
          return Text("0");
        }
      }),
    );
  }
}
