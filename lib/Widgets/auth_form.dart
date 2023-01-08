import 'package:flutter/material.dart';
import 'user_image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  //const AuthForm({Key? key}) : super(key: key);
  final bool _isLoading;
  final void Function(String email, String password, String username, File userImage,
      bool isLogin, BuildContext ctx) submitFn;
  AuthForm(this.submitFn, this._isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var userEmail = '';
  var userName = '';
  var password = '';
  var _isLogin = true;
  bool _isHidden = true;
  File? userImage;
  void _pickedImage(File image) {
     userImage = image;
  }
  void _submitForm() {
    final isValid = _formkey.currentState!.validate();
    FocusManager.instance.primaryFocus!.unfocus();
    if(userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please pick some image'),));
    }
    if (isValid) {
      _formkey.currentState!.save();
    }
    widget.submitFn(
        userEmail.trim(), userName.trim(), password.trim(), userImage ?? File('') , _isLogin, context);
  }

  void _PasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'email id', icon: Icon(Icons.email)),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(
                          labelText: 'user name',
                          icon: Icon(Icons.person_outlined)),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please provide a user name more than 5 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('passwrod'),
                    decoration: InputDecoration(
                      suffix: InkWell(
                          child: Icon(_isHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onTap: _PasswordView),
                      labelText: 'password',
                      icon: Icon(Icons.password),
                    ),
                    obscureText: _isHidden,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Please provide a strong password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                 // if (widget._isLoading)
                   // Center(child: CircularProgressIndicator()),
                 // if (!widget._isLoading)
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(_isLogin ? 'LOGIN' : 'SignUp'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.orange)),
                    ),
                 // if (!widget._isLoading)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? "create a new account"
                              : "I already have an account",
                          style: TextStyle(color: Colors.pinkAccent),
                        ))
                ],
              ),
            ),
          ))),
    );
  }
}
