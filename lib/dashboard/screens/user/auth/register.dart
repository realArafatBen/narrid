import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narrid/dashboard/bloc/user/register/register_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';

import '../../../bloc/user/auth/authentication_bloc.dart';
import '../../../repositories/user/auth/userRepository.dart';

class Register extends StatelessWidget {
  final UserRepository userRepository;
  final String route;
  Register({
    Key key,
    @required this.userRepository,
    @required this.route,
  })  : assert(userRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider(
          create: (context) => RegisterBloc(
              userRepository: userRepository,
              authenticationBloc:
                  AuthenticationBloc(authenticationRepository: userRepository)),
          child: RegisterBody(route: route),
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
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Login(
                        userRepository: UserRepository(),
                        route: 'home',
                      )));
            },
            child: Container(
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
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
                "REGISTER",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.black),
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
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final route;
  RegisterBody({@required this.route});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:
        BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Container(
        padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
        margin: const EdgeInsets.only(
          bottom: 100,
        ),
        child: Column(
          children: <Widget>[
            Logo(),
            TextAuth(),
            SizedBox(
              height: 40,
            ),
            buildFirstName(),
            SizedBox(
              height: 10,
            ),
            buildLastName(),
            SizedBox(
              height: 10,
            ),
            buildEmailAddress(),
            SizedBox(
              height: 10,
            ),
            buildMobile(),
            SizedBox(
              height: 10,
            ),
            buildState(),
            SizedBox(
              height: 10,
            ),
            buildCountry(),
            SizedBox(
              height: 10,
            ),
            buildPassword(),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Login(
                          userRepository: UserRepository(),
                          route: 'home',
                        )));
              },
              child: Container(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                alignment: Alignment.topRight,
                child: Text(
                  "Already, have an account? Login",
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            buildRegisterButton(state, context),
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
            buildContinueFacebook(),
            Container(
              child: state is RegisterFailure
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
              child: state is RegisterMessageAlert
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
              child:
                  state is RegisterSuccess ? _redirectRegister(context) : null,
            )
          ],
        ),
      );
    }));
  }

  _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _redirectRegister(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (route) {
        case 'home':
          Route loc = MaterialPageRoute(builder: (context) => NarridApp());
          Navigator.pushReplacement(context, loc);
          break;
        default:
          print("No Location");
      }
    });
  }

  SizedBox buildRegisterButton(state, context) {
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
          if (state is! RegisterLoading) {
            return BlocProvider.of<RegisterBloc>(context)
              ..add(
                RegisterButtonPressed(
                  password: _passwordController.text,
                  email: _emailController.text,
                  first_name: _firstnameController.text,
                  last_name: _lastnameController.text,
                  mobile: _mobileController.text,
                  state: _stateController.text,
                  country: _countryController.text,
                ),
              );
          } else {
            return null;
          }
        },
        child: state is RegisterLoading
            ? CircularProgressIndicator()
            : Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  SizedBox buildContinueFacebook() {
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
        },
        icon: FaIcon(FontAwesomeIcons.facebook),
        label: Text("Continue with facebook"),
      ),
    );
  }

  TextFormField buildPassword() {
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

  TextFormField buildEmailAddress() {
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

  TextFormField buildMobile() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
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
      controller: _mobileController,
    );
  }

  TextFormField buildState() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'State',
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
      controller: _stateController,
    );
  }

  TextFormField buildCountry() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Country',
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
      controller: _countryController,
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
      controller: _lastnameController,
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
      controller: _firstnameController,
    );
  }
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
