import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  late AnimationController anim;
  late AnimationController anim2;
  late final Animation<double> _animation = CurvedAnimation(
    parent: anim,
    curve: Curves.easeIn,
  );

  late final Animation<double> _animation2 = CurvedAnimation(
    parent: anim2,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    anim = AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
        lowerBound: 0,
        upperBound: 1)
      ..animateTo(1);
    anim2 = AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
        lowerBound: 0,
        upperBound: 1);
    Future.delayed(Duration(milliseconds: 200), () => anim2.animateTo(1));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    anim.dispose();
    anim2.dispose();
    super.dispose();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid ?? false) {
      _formKey.currentState?.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.only(
        top: 35,
        // left: 25,
      ),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        FadeTransition(
                          opacity: _animation,
                          child: Text(
                            _isLogin ? "Hello Again!" : "Welcome!",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeTransition(
                          opacity: _animation2,
                          child: Text(
                            _isLogin
                                ? "Welcome Back you've \n been missed!"
                                : "Lets Get you all Set Up.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 54.0, left: 30.0, right: 30.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextFormField(
                                    key: const ValueKey('email'),
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Email',
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    enableSuggestions: false,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _userEmail = value!;
                                    },
                                  ),
                                ),
                              ),
                              if (!_isLogin) const SizedBox(height: 20.0),
                              if (!_isLogin)
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: TextFormField(
                                      key: const ValueKey('username'),
                                      decoration: const InputDecoration(
                                        labelText: 'Username',
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                      autocorrect: true,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      enableSuggestions: false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter a username';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _userName = value!;
                                      },
                                      // ignore: missing_return
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 20.0),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextFormField(
                                    key: const ValueKey('password'),
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      border: InputBorder.none,
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                    obscureText: true,

                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 7) {
                                        return 'Please enter a long password';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _userPassword = value!;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              if (widget.isLoading)
                                const CircularProgressIndicator(),
                              if (!widget.isLoading)
                                SizedBox(
                                  height: 57.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor:
                                        Color.fromARGB(134, 253, 106, 104),
                                    color: const Color(0xfffd6b68),
                                    elevation: 10.0,
                                    child: TextButton(
                                      onPressed: _trySubmit,
                                      child: Center(
                                        child: Text(
                                          _isLogin ? "Login" : "Sign up",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 25,
                              ),
                              if (!widget.isLoading)
                                SizedBox(
                                  height: 57.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: Colors.white,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLogin = !_isLogin;
                                          anim.reset();
                                          anim.animateTo(1);
                                          anim2.reset();
                                          Future.delayed(
                                              Duration(milliseconds: 200), () {
                                            anim2.animateTo(1);
                                          });
                                        });
                                      },
                                      child: Center(
                                        child: Text(
                                          _isLogin
                                              ? "Create new account"
                                              : "I already have an account",
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  253, 111, 150, 1),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Raleway'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom)),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
