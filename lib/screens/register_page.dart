import 'package:firebase_auth/firebase_auth.dart';
import 'package:tempted_toes/widgets/custom_btn.dart';
import 'package:tempted_toes/widgets/custom_input.dart';

import '../constants.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> _alertDialogBuilder(String error) async {
    bool emptString = false;

    if (error == "Given String is empty or null") {
      setState(() {
        emptString = true;
      });
    }
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("An Error occurred, please try again!"),
            content: Container(
                child: emptString
                    ? Text('Both Email and Password is required')
                    : Text(error)
                //  child: Text(error),
                ),
            actions: [
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  void _submitForm() async {
    setState(() {
      _registerFormLoading = true;
    });

    String _createAccountFeedback = await _createAccount();

    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  bool _registerFormLoading = false;
  String _registerEmail = '';
  String _registerPassword = '';

  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bigScreenTop = MediaQuery.of(context).size.height * 0.24;
    double bigScreenBottom = MediaQuery.of(context).size.height * 0.24;

  double smallScreenTop = MediaQuery.of(context).size.height * 0.15;
    double smallScreenBottom = MediaQuery.of(context).size.height * 0.15;
    

    double screenHeight = MediaQuery.of(context).size.height;

    bool isSmallPhone = false;

    if (screenHeight < 700) {
      setState(() {
        isSmallPhone = true;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  'Create new account',
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: isSmallPhone ? smallScreenTop: bigScreenTop,
                    bottom: isSmallPhone ? smallScreenBottom : bigScreenBottom),
                child: Column(
                  children: [
                    CustomInput(
                      hintText: "Enter your Email",
                      onChanged: (value) {
                        _registerEmail = value;
                      },
                      onSubmitted: (value) {
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Enter your Password",
                      onChanged: (value) {
                        _registerPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value) {
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Register",
                      onPressed: () {
                        _submitForm();
                      },
                      isLoading: _registerFormLoading,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomBtn(
                  text: "Go back to Login",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  outlineBtn: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
