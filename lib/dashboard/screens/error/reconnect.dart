import 'package:flutter/material.dart';
import 'package:narrid/dashboard/app_initializer.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';

bool loading = false;

class Reconnect extends StatefulWidget {
  const Reconnect({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  _ReconnectState createState() => _ReconnectState();
}

class _ReconnectState extends State<Reconnect> {
  @override
  Widget build(BuildContext context) {
    final appError = SnackBar(
      content: Text('Oops! there seem to be an error, try again later'),
    );
    final connectionError = SnackBar(
      content: Text('Oops! No Internet Connectivity'),
    );
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Container(
            child: Text(
              "Oops, there seem to be an error, try again.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 15,
              left: 20,
              right: 20,
            ),
            width: double.infinity,
            child: OutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
              ),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                Map<String, dynamic> result =
                    await AppInitializer().appInitializer();
                bool connectivityStatus = result['connectivity_status'];
                if (result.isNotEmpty) {
                  if (connectivityStatus) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NarridApp()));
                  } else {
                    //show snackbar error
                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(connectionError);
                    loading = false;
                  }
                } else {
                  //show snackbar error
                  // Find the ScaffoldMessenger in the widget tree
                  // and use it to show a SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(appError);
                  loading = false;
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: loading
                    ? Container(
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      )
                    : Text(
                        "Try again",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
