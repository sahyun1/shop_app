import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatelessWidget {
  // const SignInScreen({ Key? key }) : super(key: key);
  static const ROUTE_NAME = '/sign-in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign in with your email and password \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SignInForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  // const SignInForm({ Key? key }) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildInputField(
              labelText: "Email",
              hintText: "Enter your email",
              icon: Icons.email_outlined),
          SizedBox(
            height: 20,
          ),
          buildInputField(
              labelText: "Password",
              hintText: "Enter your password",
              icon: Icons.lock_outline,
              isForPassword: true),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white, // foreground
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField buildInputField(
      {String labelText,
      String hintText,
      IconData icon,
      bool isForPassword = false}) {
    return TextFormField(
      keyboardType: isForPassword
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      obscureText: isForPassword,
      decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: Icon(
            icon,
            color: Color(0xFF757575),
          )),
    );
  }
}
