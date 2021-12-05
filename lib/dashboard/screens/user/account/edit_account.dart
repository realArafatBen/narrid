import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/account/edit_account_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class EditAccount extends StatelessWidget {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
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
          "Edit Account",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider(
          create: (context) =>
              EditAccountBloc(userRepository: UserRepository())..add(Started()),
          child: Container(
            margin: const EdgeInsets.all(9),
            child: __buildState(),
          )),
    );
  }

  Widget __buildState() {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      builder: (context, state) {
        if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Success) {
          return _buildForm(state, context);
        } else if (state is Error) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildForm(state, context) {
    Map<String, dynamic> data = state.getDetails;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          buildFirstName(data['first_name']),
          SizedBox(
            height: 15,
          ),
          buildLastName(data['last_name']),
          SizedBox(
            height: 15,
          ),
          buildEmail(data['email']),
          SizedBox(
            height: 15,
          ),
          buildMobile(data['mobile']),
          SizedBox(
            height: 15,
          ),
          buildSubmitButton(state, context),
        ],
      ),
    );
  }

  _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  TextFormField buildFirstName(first_name) {
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
      controller: _firstNameController..text = first_name.toString(),
    );
  }

  TextFormField buildLastName(last_name) {
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
      controller: _lastNameController..text = last_name.toString(),
    );
  }

  TextFormField buildEmail(email) {
    return TextFormField(
      keyboardType: TextInputType.text,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Email',
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
      controller: _emailController..text = email.toString(),
    );
  }

  TextFormField buildMobile(mobile) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Mobile Number',
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
      controller: _mobileController..text = mobile.toString(),
    );
  }

  Widget buildSubmitButton(state, context) {
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
              if (state is! Loading) {
                return BlocProvider.of<EditAccountBloc>(context)
                  ..add(
                    Edit(
                        first_name: _firstNameController.text,
                        last_name: _lastNameController.text,
                        mobile: _mobileController.text),
                  );
              } else {
                return null;
              }
            },
            child: state is Loading
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
          child: state is Error
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
          child: state is Success
              ? _onWidgetDidBuild(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Account Updated"),
                      backgroundColor: Colors.red,
                    ),
                  );
                })
              : null,
        )
      ],
    );
  }
}
