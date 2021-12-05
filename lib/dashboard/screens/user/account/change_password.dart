import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/account/change_password_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class ChangePassword extends StatelessWidget {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _previousController = TextEditingController();
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
            "Change Password",
            style: TextStyle(color: Colors.grey[800]),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocProvider(
          create: (context) =>
              ChangePasswordBloc(userRepository: UserRepository()),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: _buildBody(),
            ),
          ),
        ));
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          buildPreviousPassword(),
          SizedBox(
            height: 10,
          ),
          buildNewPassword(),
          SizedBox(
            height: 10,
          ),
          buildConfirmPassword(),
          SizedBox(
            height: 10,
          ),
          buildSubmitButton(),
        ],
      ),
    );
  }

  Widget buildPreviousPassword() {
    return TextFormField(
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Previous Password',
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
        controller: _previousController);
  }

  Widget buildNewPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'New Password',
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
      controller: _passwordController,
    );
  }

  Widget buildConfirmPassword() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
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
      controller: _confirmController,
    );
  }

  Widget buildSubmitButton() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
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
                  if (state is! Loading) {
                    return BlocProvider.of<ChangePasswordBloc>(context)
                      ..add(
                        ChangePass(
                            password: _passwordController.text,
                            prev_password: _previousController.text),
                      );
                  } else {
                    return null;
                  }
                },
                child: state is Loading
                    ? CircularProgressIndicator()
                    : Text(
                        'Change Password',
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
                          content: Text("Oops, there was an error"),
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
                          content: Text(state.getMessage['msg']),
                          backgroundColor: Colors.red,
                        ),
                      );
                    })
                  : null,
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
}
