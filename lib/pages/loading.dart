import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  void gotoHome(context){
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/home");
    });
  }

  Widget build(BuildContext context) {
    gotoHome(context);
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(height: 20, color: Colors.grey[200], indent: 20, endIndent: 20,),
            Text(
              "Chatti Wortshatz",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontSize: 25,
              ),
            ),
            Divider(height: 20, color: Colors.grey[300], indent: 50, endIndent: 50,),
          ],
        )
      ),
    );
  }
}
