import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leashapp/src/shared/providers/auth.dart.bak';

enum _SigninScreenMode {
  signin,
  signup,
}

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  _SigninScreenMode _mode = _SigninScreenMode.signin;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  String? _email;
  String? _password;
  String? _confirmPassword;

  final _formKey = GlobalKey<FormState>();

  final bool isDesktop = defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return isDesktop
          ? _buildDesktop(context, constraints)
          : _buildMobile(context, constraints);
    });
  }

  Widget _buildDesktop(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == _SigninScreenMode.signin ? 'Log In' : 'Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => GoRouter.of(context).go('/settings'),
        ),
      ),
      body: Container(
          alignment: Alignment.topCenter,
          child: Container(
              constraints: BoxConstraints(
                maxWidth: min(constraints.maxWidth * 0.6, 400),
              ),
              padding: const EdgeInsets.all(16),
              child: _buildForm(
                  context: context,
                  constraints: constraints,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _mode == _SigninScreenMode.signin
                        ? _buildSignInFields(context, constraints)
                        : _buildSignUpFields(context, constraints),
                  )))),
    );
  }

  Widget _buildForm(
      {required BuildContext context,
      required BoxConstraints constraints,
      required Widget child}) {
    return Form(
      key: _formKey,
      child: child,
    );
  }

  List<Widget> _buildSignUpFields(
      BuildContext context, BoxConstraints constraints) {
    return [
      const Text('Create an account to sync your data.'),
      const SizedBox(height: 16),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email *',
        ),
        keyboardType: TextInputType.emailAddress,
        initialValue: _email,
        onChanged: (String? value) {
          setState(() {
            _email = value;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          if (!EmailValidator.validate(value)) {
            return 'Invalid email';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Password *',
            suffixIcon: Focus(
              skipTraversal: true,
              descendantsAreFocusable: false,
              child: IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
              ),
            )),
        initialValue: _password,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _hidePassword,
        onChanged: (String? value) {
          setState(() {
            _password = value;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Confirm Password *',
            suffixIcon: Focus(
              skipTraversal: true,
              descendantsAreFocusable: false,
              child: IconButton(
                icon: Icon(
                  _hideConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _hideConfirmPassword = !_hideConfirmPassword;
                  });
                },
              ),
            )),
        initialValue: _confirmPassword,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _hideConfirmPassword,
        onChanged: (String? value) {
          setState(() {
            _confirmPassword = value;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }
          if (value != _password) {
            return 'Passwords must match';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      _buildActions(context, constraints),
    ];
  }

  List<Widget> _buildSignInFields(
      BuildContext context, BoxConstraints constraints) {
    return [
      const Text(
          'Sign in to an existing account to link that account\'s data. Please note that all data that exists locally will be lost.'),
      const SizedBox(height: 16.0),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email',
        ),
        initialValue: _email,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        onChanged: (String? value) {
          setState(() {
            _email = value;
          });
        },
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return 'Email is required';
          } else if (!EmailValidator.validate(value!)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: Focus(
                skipTraversal: true,
                descendantsAreFocusable: false,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                    icon: Icon(_hidePassword
                        ? Icons.visibility
                        : Icons.visibility_off)))),
        initialValue: _password,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _hidePassword,
        onChanged: (String? value) {
          setState(() {
            _password = value;
          });
        },
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return 'Password is required';
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),
      _buildActions(context, constraints),
    ];
  }

  Widget _buildActions(BuildContext context, BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          child: Text(_mode == _SigninScreenMode.signin ? 'Sign Up' : 'Log In'),
          onPressed: () {
            _changeMode();
          },
        ),
        OutlinedButton(
          onPressed: () {
            _mode == _SigninScreenMode.signup ? _signUp() : _signIn();
          },
          child: Text(_mode == _SigninScreenMode.signin ? 'Log In' : 'Sign Up'),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(_mode == _SigninScreenMode.signin ? 'Sign In' : 'Sign Up'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              GoRouter.of(context).go('/settings');
            },
          ),
        ),
        body: AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          key: widget.key,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: _buildMobileBody(context, constraints),
        ));
  }

  Widget _buildMobileBody(BuildContext context, BoxConstraints constraints) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(
            context: context,
            constraints: constraints,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _mode == _SigninScreenMode.signin
                  ? _buildSignInFields(context, constraints)
                  : _buildSignUpFields(context, constraints),
            )));
  }

  void _changeMode() {
    setState(() {
      _mode = _mode == _SigninScreenMode.signin
          ? _SigninScreenMode.signup
          : _SigninScreenMode.signin;
      _password = null;
      _email = null;
      _confirmPassword = null;
      _hidePassword = true;
      _hideConfirmPassword = true;
      _formKey.currentState!.reset();
    });
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await AuthProvider.instance.upgradeWithEmailPassword(_email!, _password!);
      _navigateBack();
    } on UpgradeUserException catch (e) {
      _showError(e.message!);
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await AuthProvider.instance.signInWithEmailPassword(_email!, _password!);
      _navigateBack();
    } on LoginException catch (e) {
      _showError(e.message);
    }
  }

  void _navigateBack() {
    GoRouter.of(context).go('/settings');
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(_mode == _SigninScreenMode.signin
                  ? 'Log In Error'
                  : 'Sign Up Error'),
              content: Text(message),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
