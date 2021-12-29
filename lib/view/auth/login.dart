import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/colors.dart';
import 'package:mvvm_task/constants/strings.dart';
import 'package:mvvm_task/constants/styles.dart';
import 'package:mvvm_task/db/shared_prefs_db.dart';
import 'package:mvvm_task/utitlities/size_config.dart';
import 'package:mvvm_task/utitlities/spacing.dart';
import 'package:mvvm_task/utitlities/validator.dart';
import 'package:mvvm_task/view/customWidgets/continue_button.dart';
import 'package:mvvm_task/view/customWidgets/custom.dart';
import 'package:mvvm_task/view/customWidgets/google_button.dart';
import 'package:mvvm_task/view/customWidgets/icon_button.dart';
import 'package:mvvm_task/view/home/home.dart';
import 'package:mvvm_task/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            AppStrings.login,
            style: AppStyles.heading1,
          ),
        ),
        body: _buildLoginScreen(context));
  }

  Widget _buildLoginScreen(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);

    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.largeHeight(),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: LoginForm(
                formKey: _formKey,
                emailTextController: _emailTextController,
                passwordTextController: _passwordEditingController,
              ),
            ),
            Spacing.mediumHeight(),
            Spacing.bigHeight(),
            authProvider.authStatus == AuthStatus.authenticating
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        createIconButton(() async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus;
                            String email = _emailTextController.text.trim();
                            User? user = await authProvider.signInWithEmail(
                                email: _emailTextController.text.trim(),
                                password: _passwordEditingController.text,
                                context: context);

                            if (user != null) {
                              SharedPrefsUtil.instance.saveEmail(email);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            userEmail: email,
                                          )));
                            }
                          }
                        }, AppStrings.login),
                        SizedBox(
                          height: getProportionateScreenHeight(23.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 43),
                          child: createGoogleButton(() async {
                            String email = _emailTextController.text.trim();
                            User? user = await authProvider.signInWithGoogle(
                                context: context);

                            if (user != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            userEmail: email,
                                          )));
                            }
                          }, AppStrings.signUpWithGoogle),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(23.0),
                        ),
                      ],
                    ),
                  ),
          ],
        ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.formKey,
    required this.emailTextController,
    required this.passwordTextController,
  }) : super(key: key);
  final GlobalKey formKey;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.bigHeight(),
          Text(
            AppStrings.emailHint,
            style: TextStyle(
                fontSize: getProportionatefontSize(11),
                color: AppColors.formFieldLabel,
                fontWeight: FontWeight.bold),
          ),
          TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validator.validateEmail(email: value ?? ''),
              controller: widget.emailTextController,
              decoration: const InputDecoration(
                  hintText: AppStrings.emailHint,
                  icon: Icon(
                    Icons.email_outlined,
                    color: AppColors.black,
                  ))),
          Spacing.bigHeight(),
          Text(
            AppStrings.passwordHint,
            style: TextStyle(
                fontSize: getProportionatefontSize(11),
                color: AppColors.formFieldLabel,
                fontWeight: FontWeight.bold),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            validator: (value) =>
                Validator.validatePassword(password: value ?? ''),
            controller: widget.passwordTextController,
            decoration: const InputDecoration(
                hintText: AppStrings.passwordHint,
                icon: Icon(
                  Icons.password_rounded,
                  color: AppColors.black,
                )),
          ),
          Spacing.mediumHeight(),
        ],
      ),
    );
  }
}
