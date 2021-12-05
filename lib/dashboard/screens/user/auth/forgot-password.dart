import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/auth/reset_password_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            ResetPasswordBloc(authenticationRepository: UserRepository()),
        child: RegisterBody(),
      ),
    );
  }
}

class TextAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Reset Password",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 30,
        ),
      ),
    );
  }
}

class RegisterBody extends StatelessWidget {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext contxt) {
    return SingleChildScrollView(
      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
            child: Column(
              children: <Widget>[
                TextAuth(),
                SizedBox(
                  height: 40,
                ),
                buildEmailAddress(state),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 5,
                          bottom: 5,
                        ),
                        child: Text(
                          "Login",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                buildButton(state, context),
                SizedBox(
                  height: 30,
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
                              content: Text(state.msg),
                              backgroundColor: Colors.red,
                            ),
                          );
                        })
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  SizedBox buildButton(state, context) {
    return SizedBox(
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
            return BlocProvider.of<ResetPasswordBloc>(context)
              ..add(
                Reset(
                  _emailController.text,
                ),
              );
          } else {
            return null;
          }
        },
        child: state is Loading
            ? CircularProgressIndicator()
            : Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
      ),
    );
  }

  TextFormField buildEmailAddress(state) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
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
      controller: _emailController,
    );
  }
}
