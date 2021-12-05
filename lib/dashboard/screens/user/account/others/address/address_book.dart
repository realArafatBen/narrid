import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/account/address/adresses_bloc.dart';
import 'package:narrid/dashboard/models/store/account/addresses_modal.dart';
import 'package:narrid/dashboard/repositories/user/account/addresses_repost.dart';
import 'package:narrid/dashboard/screens/user/account/others/address/add_address.dart';
import 'package:narrid/dashboard/screens/user/account/others/address/edit_address.dart';

class AddressBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Address Book",
          style: TextStyle(color: Colors.grey[800]),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => AddressesBloc(addressRepos: AddressesRepos())
          ..add(AddressStarted()),
        child: Container(
          margin: const EdgeInsets.all(8),
          child: _buildAddress(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddAddress()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildAddress() {
    return BlocBuilder<AddressesBloc, AddressesState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AddressError) {
          return Center(
            child: Text("Error"),
          );
        } else if (state is AddressLoaded) {
          List<AddressModal> addresses = state.getAddresses;
          return SingleChildScrollView(
            child: Column(
              children: [
                for (var address in addresses)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          address.first_name + " " + address.last_name,
                          style: __textStyle(),
                        ),
                        Text(
                          address.address,
                          style: __textStyle(),
                        ),
                        Text(
                          address.region,
                          style: __textStyle(),
                        ),
                        Text(
                          address.city,
                          style: __textStyle(),
                        ),
                        Text(
                          address.line1,
                          style: __textStyle(),
                        ),
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
                        Row(
                          children: [
                            // Container(
                            //   child: TextButton.icon(
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   EditAddress(id: address.id)));
                            //     },
                            //     icon: Icon(Icons.edit),
                            //     label: Text("Edit"),
                            //   ),
                            // ),
                            address.default_ == '1'
                                ? Container(
                                    child: Center(
                                      child: TextButton.icon(
                                        onPressed: () {},
                                        icon:
                                            Icon(Icons.mark_chat_read_rounded),
                                        label: Text("Default"),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: Center(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          BlocProvider.of<AddressesBloc>(
                                                  context)
                                              .add(AddressMakeDefault(
                                                  address.id));
                                        },
                                        icon: Icon(
                                            Icons.mark_email_unread_outlined),
                                        label: Text("Make Default"),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          );
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
}
