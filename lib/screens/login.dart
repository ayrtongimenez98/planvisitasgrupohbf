import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planvisitas_grupohbf/screens/dashboard.dart';
import 'package:planvisitas_grupohbf/utilities/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  bool passwordVisible = false;

  @override
  void initState() {
    passwordVisible = false;
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Usuario',
            prefixIcon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            fillColor: Colors.white,
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          style: const TextStyle(
            color: Colors.white,
          ),
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: 'Contraseña',
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'RECUPERAR CONTRASEÑA',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
        child: Center(
            child: FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      },
      padding: EdgeInsets.all(16),
      color: Color(0xFF8C44C0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          Text(
            'INGRESAR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Icon(
            Icons.arrow_forward,
            size: 25,
            color: Colors.white,
          ),
        ],
      ),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3F7A88),
                      Color(0xFF4B959C),
                      Color(0xFF5CB1AD),
                      Color(0xFF74CCBB),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/logos/logo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                      const SizedBox(
                        height: 60.0,
                      ),
                      const Text(
                        'BIENVENIDO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      SizedBox(
                        height: 40.0,
                      ),
                      _buildLoginBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
