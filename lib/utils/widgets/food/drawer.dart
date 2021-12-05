import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/acct_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/food/delivery_address.dart';
import 'package:narrid/dashboard/screens/food/home_page.dart';
import 'package:narrid/dashboard/screens/food/orders.dart';

class FoodDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.white,
        child: ListView(
          children: [
            buildHeader(),
            const SizedBox(
              height: 48,
            ),
            buildMenuItems(
              text: "Home",
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItems(
              text: "Orders",
              icon: Icons.shopping_basket,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItems(
              text: "Delivery Address",
              icon: Icons.location_pin,
              onClicked: () => selectedItem(context, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItems({
    @required String text,
    @required IconData icon,
    VoidCallback onClicked,
  }) {
    final color = Colors.grey[900];
    final hover = Colors.black;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      hoverColor: hover,
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

  Widget buildHeader() {
    return BlocProvider(
      create: (context) => AcctBloc(authenticationRepository: UserRepository())
        ..add(AcctStarted()),
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          top: 40,
        ),
        child: BlocBuilder<AcctBloc, AcctState>(
          builder: (context, state) {
            if (state is AcctLoading) {
              return CircularProgressIndicator();
            } else if (state is FetchToken) {
              Map<String, dynamic> token = state.getToken;
              String _first_name = token['first_name'].toString();
              String _last_name = token['last_name'].toString();
              String _email = token['email'].toString();
              return _userAcct(_first_name, _last_name, _email);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _userAcct(_first_name, _last_name, _email) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              "https://img.icons8.com/cotton/64/000000/user-male--v1.png"),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _first_name + " " + _last_name,
              style: TextStyle(fontSize: 20, color: Colors.grey[900]),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              _email,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[900],
              ),
            ),
          ],
        )
      ],
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Food()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Orders()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DeliveryAddress()));
        break;
      default:
    }
  }
}
