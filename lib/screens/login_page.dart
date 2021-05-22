import 'package:firebase_auth/firebase_auth.dart';

import 'package:tempted_toes/screens/register_page.dart';
import 'package:tempted_toes/widgets/custom_btn.dart';
import 'package:tempted_toes/widgets/custom_input.dart';

import '../constants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
              child:  emptString ? Text('Both Email and Password is required') : Text(error)

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
        }
    );
  }

  // Create a new user account
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'wrong-password') {
        return 'Wrong Password entered.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if(e.code == 'user-not-found'){
        return 'User not found';
      }

      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    // Run the create account method
    String _loginFeedback = await _loginAccount();

    // If the string is not null, we got error while create account.
    if(_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  // Default Form Loading State
  bool _loginFormLoading = false;

  // Form Input Field Values
  String _loginEmail = "";
  String _loginPassword = "";

  // Focus Node for input fields
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
        double bigScreenTop = MediaQuery.of(context).size.height * 0.22;
    double bigScreenBottom = MediaQuery.of(context).size.height * 0.22;

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
                padding: EdgeInsets.only(
                  top: 24.0,
                ),
                child: Text(
                  "Welcome back,\nLogin to your account",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Padding( padding: EdgeInsets.only(top: isSmallPhone ? smallScreenTop: bigScreenTop,
                    bottom: isSmallPhone ? smallScreenBottom : bigScreenBottom),
                child: Column(
                  children: [
                    CustomInput(
                      hintText: "Enter your Email",
                      onChanged: (value) {
                        _loginEmail = value;
                      },
                      onSubmitted: (value) {
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Enter your Password",
                      onChanged: (value) {
                        _loginPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value) {
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Login",
                      onPressed: () {
                        _submitForm();
                      },
                      isLoading: _loginFormLoading,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomBtn(
                  text: "Create New Account",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage()
                      ),
                    );
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