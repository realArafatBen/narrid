import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/user/auth/authentication_bloc.dart';
import 'package:narrid/dashboard/bloc/user/login/login_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/food/cart.dart';
import 'package:narrid/dashboard/screens/grocery/cart.dart';
import 'package:narrid/dashboard/screens/logistices/pick-up-drop-off.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';
import 'package:narrid/dashboard/screens/store/cart_page.dart';
import 'package:narrid/dashboard/screens/user/auth/forgot-password.dart';
import 'package:narrid/dashboard/screens/user/auth/register.dart';

import '../../../repositories/user/auth/userRepository.dart';

class Login extends StatelessWidget {
  UserRepository userRepository;
  String route;
  Login({
    Key key,
    @required this.userRepository,
    @required this.route,
  })  : assert(userRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => LoginBloc(
            userRepository: userRepository,
            authenticationBloc:
                AuthenticationBloc(authenticationRepository: userRepository)),
        child: Scaffold(
          body: RegisterBody(route: route),
        ),
      ),
    );
  }
}

class TextAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 5.0,
                  color: HexColor("f1df00"),
                ),
              ),
            ),
            child: Text(
              "LOGIN",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Register(
                        userRepository: UserRepository(),
                        route: 'home',
                      )));
            },
            child: Container(
              child: Text(
                "REGISTER",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterBody extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final route;
  RegisterBody({@required this.route});
  @override
  Widget build(BuildContext contxt) {
    return SingleChildScrollView(
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
            child: Column(
              children: <Widget>[
                Logo(),
                TextAuth(),
                SizedBox(
                  height: 40,
                ),
                buildEmailAddress(state),
                SizedBox(
                  height: 10,
                ),
                buildPassword(state),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: Text(
                          "Forget Password?",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                buildLoginButton(state, context),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Or",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                buildContinueFacebook(state),
                Container(
                  child: state is LoginFailure
                      ? _onWidgetDidBuild(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        })
                      : null,
                ),
                Container(
                  child: state is LoginMessageAlert
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
                Container(
                  child: state is LoginSuccess ? _redirectLogin(contxt) : null,
                )
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

  _redirectLogin(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (route) {
        case 'home':
          Route loc = MaterialPageRoute(builder: (context) => NarridApp());
          Navigator.pushReplacement(context, loc);
          break;
        case 'cart_page':
          Route loc = MaterialPageRoute(builder: (context) => Cart());
          Navigator.pushReplacement(context, loc);
          break;
        case 'product':
          Route loc = MaterialPageRoute(builder: (context) => NarridApp());
          Navigator.pushReplacement(context, loc);
          break;
        case 'cart_grocery':
          Route loc = MaterialPageRoute(builder: (context) => CartGrocery());
          Navigator.pushReplacement(context, loc);
          break;
        case 'cart_food':
          Route loc = MaterialPageRoute(builder: (context) => CartFood());
          Navigator.pushReplacement(context, loc);
          break;
        case 'logistics':
          Route loc = MaterialPageRoute(builder: (context) => PickUpDropOff());
          Navigator.pushReplacement(context, loc);
          break;
        default:
          Route loc = MaterialPageRoute(builder: (context) => NarridApp());
          Navigator.pushReplacement(context, loc);
      }
    });
  }

  SizedBox buildLoginButton(state, context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            HexColor("f1df00"),
          ),
        ),
        onPressed: () {
          if (state is! LoginLoading) {
            return BlocProvider.of<LoginBloc>(context)
              ..add(
                LoginButtonPressed(
                  password: _passwordController.text,
                  email: _emailController.text,
                ),
              );
          } else {
            return null;
          }
        },
        child: state is LoginLoading
            ? CircularProgressIndicator()
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  SizedBox buildContinueFacebook(state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.blue,
          ),
        ),
        onPressed: () {
          // Respond to button press
          // _runFacebookOauth();
        },
        icon: FaIcon(
          FontAwesomeIcons.facebook,
        ),
        label: Text(
          "Continue with facebook",
        ),
      ),
    );
  }

  TextFormField buildPassword(state) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Colors.grey[800],
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("f1df00"),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("f1df00"),
          ),
        ),
      ),
      controller: _passwordController,
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
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("f1df00"),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("f1df00"),
          ),
        ),
      ),
      controller: _emailController,
    );
  }

  // _runFacebookOauth() async {
  //   final LoginResult result = await FacebookAuth.instance
  //       .login(); // by default we request the email and the public profile
  //   if (result.status == LoginStatus.success) {
  //     // you are logged
  //     final AccessToken accessToken = result.accessToken;
  //   }
  // }
}

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 40,
        top: 20,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/logo.png",
            width: 60,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "narrid",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                ),
              ),
              Text(
                "YOUR EVERYTHING, Right AWAY!",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
