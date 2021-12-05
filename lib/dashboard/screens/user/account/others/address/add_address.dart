import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/account/address/add_address_bloc.dart';
import 'package:narrid/dashboard/bloc/user/account/address/lga_bloc.dart';
import 'package:narrid/dashboard/bloc/user/account/address/locals_bloc.dart';
import 'package:narrid/dashboard/models/store/account/addresses_modal.dart';
import 'package:narrid/dashboard/repositories/user/account/addresses_repost.dart';

String currentCity = '';
String currentRegion = '';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _line1Controller = TextEditingController();

  final _line2Controller = TextEditingController();

  final _addressController = TextEditingController();

  final GlobalKey<FormFieldState> _keyRegion = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Add Address",
          style: TextStyle(color: Colors.grey[800]),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<LocalsBloc>(
              create: (context) => LocalsBloc(addressRepos: AddressesRepos())
                ..add(LocalsStarted())),
          BlocProvider<LgaBloc>(
              create: (context) => LgaBloc(addressRepos: AddressesRepos())),
          BlocProvider<AddAddressBloc>(
              create: (context) =>
                  AddAddressBloc(addressRepos: AddressesRepos())),
        ],
        child: Container(
          margin: const EdgeInsets.all(9),
          child: SingleChildScrollView(child: _buildFormBody()),
        ),
      ),
    );
  }

  Widget _buildFormBody() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        buildFirstName(),
        SizedBox(
          height: 15,
        ),
        buildLastName(),
        SizedBox(
          height: 15,
        ),
        buildLine1(),
        SizedBox(
          height: 15,
        ),
        buildLine2(),
        SizedBox(
          height: 15,
        ),
        buildAddress(),
        SizedBox(
          height: 15,
        ),
        buildCity(),
        SizedBox(
          height: 15,
        ),
        buildRegion(),
        SizedBox(
          height: 15,
        ),
        buildSubmitButton(),
      ],
    );
  }

  TextFormField buildFirstName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'First Name',
        labelStyle: TextStyle(
          color: Colors.grey[800],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
      ),
      controller: _firstNameController,
    );
  }

  TextFormField buildLastName() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Last Name',
        labelStyle: TextStyle(
          color: Colors.grey[800],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
      ),
      controller: _lastNameController,
    );
  }

  TextFormField buildLine1() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Line 1',
        labelStyle: TextStyle(
          color: Colors.grey[800],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
      ),
      controller: _line1Controller,
    );
  }

  TextFormField buildLine2() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Line 2',
        labelStyle: TextStyle(
          color: Colors.grey[800],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
      ),
      controller: _line2Controller,
    );
  }

  TextFormField buildAddress() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Address',
        labelStyle: TextStyle(
          color: Colors.grey[800],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
      ),
      controller: _addressController,
    );
  }

  Widget buildCity() {
    return BlocBuilder<LocalsBloc, LocalsState>(
      builder: (context, state) {
        if (state is LocalsLoading) {
          return DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Select City',
              labelStyle: TextStyle(
                color: Colors.grey[800],
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
            ),
            items: [],
          );
        } else if (state is LocalsLoaded) {
          List<AddressModal> cities = state.getCities;

          return DropdownButtonFormField<String>(
            items: cities.map((dropdownStringItem) {
              return DropdownMenuItem<String>(
                value: dropdownStringItem.alias,
                child: Text(dropdownStringItem.state.toString()),
              );
            }).toList(),
            onChanged: (e) {
              currentCity = e.toString();
              BlocProvider.of<LgaBloc>(context).add(LgaFetch(currentCity));
              //reset the region value
              resetRegionValue();
            },
            decoration: InputDecoration(
              labelText: 'Select City',
              labelStyle: TextStyle(
                color: Colors.grey[800],
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
            ),
          );
        } else if (state is LocalsError) {
          return Text("Error");
        }
      },
    );
  }

  Widget buildRegion() {
    List currency = [];

    return BlocBuilder<LgaBloc, LgaState>(
      builder: (context, state) {
        if (state is LgaError) {
          return Center(
            child: Text("error"),
          );
        } else if (state is LgaLoaded) {
          List<dynamic> lga = state.getLga;

          return DropdownButtonFormField<String>(
            key: _keyRegion,
            items: lga.map((dropdownStringItem) {
              return DropdownMenuItem<String>(
                value: dropdownStringItem,
                child: Text(dropdownStringItem.toString()),
              );
            }).toList(),
            onChanged: (e) {
              currentRegion = e.toString();
            },
            decoration: InputDecoration(
              labelText: 'Select Region',
              labelStyle: TextStyle(
                color: Colors.grey[800],
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
            ),
          );
        } else {
          return DropdownButtonFormField(
            key: _keyRegion,
            decoration: InputDecoration(
              labelText: 'Select Region',
              labelStyle: TextStyle(
                color: Colors.grey[800],
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[900],
                ),
              ),
            ),
            items: [],
          );
        }
      },
    );
  }

  Widget buildSubmitButton() {
    return BlocBuilder<AddAddressBloc, AddAddressState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.black,
                  ),
                ),
                onPressed: () {
                  if (state is! AddAddressLoading) {
                    return BlocProvider.of<AddAddressBloc>(context)
                      ..add(
                        AddAddressPress(
                            first_name: _firstNameController.text,
                            last_name: _lastNameController.text,
                            line1: _line1Controller.text,
                            line2: _line2Controller.text,
                            address: _addressController.text,
                            city: currentCity,
                            region: currentRegion),
                      );
                  } else {
                    return null;
                  }
                },
                child: state is AddAddressLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
            Container(
              child: state is AddAddressError
                  ? _onWidgetDidBuild(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Oops, there was an error, try again"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    })
                  : null,
            ),
            Container(
              child: state is AddAddressSuccess ? _redirect(context) : null,
            )
          ],
        );
      },
    );
  }

  _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _redirect(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  resetRegionValue() {
    _keyRegion.currentState.reset();
  }
}
