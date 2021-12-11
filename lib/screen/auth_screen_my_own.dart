import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/model/http_exception.dart';
import 'package:shop_app_practic_28/provider/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1]),
            ),
          ),
          SingleChildScrollView(
              child: Container(
                  height: deviceSize.height,
                  width: deviceSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                        transform: Matrix4.rotationZ(-8 * pi / 180)
                          ..translate(-10.0),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                  color: Colors.black26),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepOrange.shade900),
                        child: Text(
                          'MyShop',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Anton',
                              fontSize: 50,
                              color: Colors.white),
                        ),
                      )),
                      Flexible(
                          flex: deviceSize.width > 600 ? 2 : 1,
                          child: AuthCard()),
                    ],
                  ))),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _fromKey = GlobalKey();
  var _isLoding = false;
  final _passwordControler = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  void showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text(message),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                ),
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_fromKey.currentState!.validate()) {
      return;
    }
    _fromKey.currentState!.save();
    setState(() {
      _isLoding = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
      }
    } on HttpException catch (error) {
      var errorMessaage = 'Athentication Faild';

      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessaage = 'Email Already Exists';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessaage = 'Invalid Email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessaage = 'Weak Password';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessaage = 'Email Not Found';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessaage = 'Invalid Password';
      }
      showErrorDialog(errorMessaage);
    } catch (error) {
      var errorMessage = 'Network Problem';
      showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoding = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
    setState(() {
      _isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
            key: _fromKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'E-mail'),
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                  controller: _passwordControler,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordControler.text) {
                              return 'Password do not match ';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                _isLoding
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _submit),
                FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: _switchAuthMode,
                    child: Text(
                      _authMode == AuthMode.Login ? 'SIGNUP INSTEAD' : 'Login',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ],
            )),
      ),
    );
  }
}
