import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/Login/login_screen.dart';
import 'package:flutter_app/Screens/Signup/components/background.dart';
import 'package:flutter_app/Screens/Signup/components/or_divider.dart';
import 'package:flutter_app/Screens/Signup/components/social_icon.dart';
import 'package:flutter_app/components/already_have_an_account_acheck.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/components/rounded_input_field.dart';
import 'package:flutter_app/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:flutter_app/social_auth.dart';
import 'package:flutter_app/profile.dart';
import 'package:flutter_app/global.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isLoggedIn = false;

  final facebookLogin = FacebookLogin();

  _loginWithFB() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });

        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreen();
                    },
                  ),
                );
     
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logout() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Text(
              'SIGNUP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {
                    _loginWithFB();

                    
                    
                  },
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () async{
                    await signInGoogle();

                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/*class ProfileScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(userProfile["name"]),
    );
  }
}*/
class ProfileScreen extends StatelessWidget {
  
  void _showDialog(BuildContext context, {String title, String msg}) {
    final dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        RaisedButton(
          color: Colors.teal,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    showDialog(context: context, builder: (x) => dialog);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            
            Image.network(userProfile["picture"]["data"]["url"], height: 100.0, width: 100.0,),
            
            
                
            Text(userProfile["name"]),
            SizedBox(
              height: 50,
              width: 200,
              child: Divider(
                color: Colors.teal.shade700,
              ),
            ),
            
            InfoCard(
              text: userProfile['email'],
              icon: Icons.email,
              onPressed: () {},
            ),
            /*InfoCard(
              text: 'than aaruva?',
              icon: Icons.web,
              onPressed: () {},
            ),
            InfoCard(
              text: 'enthelum venel ida',
              icon: Icons.location_city,
              onPressed: null,
            ),*/

            RaisedButton(
              padding: EdgeInsets.all(8),
              color: Colors.blueGrey,
              child: const Text('Sign Out', style: TextStyle( color: Colors.white)),
              onPressed: (){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()));

              

            }
            
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({
    @required this.text,
    @required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white60,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.blueGrey,
          ),
          title: Text(
            text,
            //style: GoogleFonts.sourceSansPro(fontSize: 20, color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }
}
