import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:shop_app_4/models/http_exception.dart';
import 'package:shop_app_4/provider/auth.dart';

enum AuthMode { signup, login }

class UserAuthScreen extends StatelessWidget {
  const UserAuthScreen({super.key});
  static const routeName = '/auth';

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
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
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
                  // title
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 50,
                      // top: 50,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                    transform: Matrix4.rotationZ((-8 * pi) / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade900,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "My Shop",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontFamily: "Anton",
                        fontSize: 50,
                      ),
                    ),
                  ),
                  // // const AuthCard()
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
// SingleTickerProviderStateMixin is mixin which provides tools used by animations and vsync
    with
        SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;

  Map<String, String> credentials = {
    'email': '',
    'password': '',
  };
  AnimationController? _animController;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnim;

  // we configure animation in init state

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      // 300 microsecond is generally used for animations
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animController!, curve: Curves.fastOutSlowIn),
    );
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController!, curve: Curves.easeIn),
    );
    // _heightAnimation!.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _animController!.dispose();
    super.dispose();
  }

  var isLoading = false;
  final passController = TextEditingController();

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('An error occured'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Okay'),
              ),
            ],
          );
        });
  }

  Future submit() async {
    if (!_formKey.currentState!.validate()) {
      //invalid
      return;
    }
    _formKey.currentState!.save();
    setState(
      () {
        isLoading = true;
      },
    );

    try {
      if (_authMode == AuthMode.login) {
        //log in
        await Provider.of<Auth>(context, listen: false)
            .logIn(credentials['email']!, credentials['password']!);
      } else {
        // sign up
        await Provider.of<Auth>(context, listen: false)
            .signUp(credentials['email']!, credentials['password']!);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email already exists';
      } else if (error.toString().contains('INVALID_EXISTS')) {
        errorMessage = 'This email in Invalid';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'The password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Couldnt find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      _showError(errorMessage);
    } catch (error) {
      var errorMessage = 'Couldnt Authenticate. Please try again later';
      _showError(errorMessage);
    }

    setState(() {
      isLoading = false;
    });
  }

  void switchState() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _animController!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _animController!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          //  AnimatedBuilder(
          //   animation: _heightAnimation!,
          //   builder: (context, ch) =>
          AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signup ? 320 : 260,
        // height: _heightAnimation!.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signup ? 320 : 260,
          // _heightAnimation!.value.height,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        //   child: ch,
        //   // sou... 'child' is passed into 'ch'?? not sure
        // ),
        // the following child doesnt rebuild
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Invalid Email';
                    }
                  },
                  onSaved: (newValue) {
                    credentials['email'] = newValue!;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: passController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  // keyboardType: TextInputType.,
                  validator: (value) {
                    if (value == null || value.length < 5) {
                      return 'Too short';
                    }
                  },
                  onSaved: (newValue) {
                    credentials['password'] = newValue!;
                  },
                ),
                // if (_authMode == AuthMode.signup)
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.signup ? 120 : 0),
                  child: FadeTransition(
                    opacity: _opacityAnim!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        // keyboardType: TextInputType.emailAddress,
                        validator: _authMode == AuthMode.signup
                            ? (value) {
                                if (value!.isEmpty ||
                                    value != passController.text) {
                                  return 'Password do not match';
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _authMode == AuthMode.login ? 'Login' : 'Signup',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                TextButton(
                    onPressed: switchState,
                    child: Text(
                        '${_authMode == AuthMode.login ? 'Signup' : 'Login'} Instead'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
