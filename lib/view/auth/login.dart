import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/colors.dart';
import 'package:mvvm_task/constants/strings.dart';
import 'package:mvvm_task/constants/styles.dart';
import 'package:mvvm_task/utitlities/size_config.dart';
import 'package:mvvm_task/utitlities/spacing.dart';
import 'package:mvvm_task/utitlities/validator.dart';
import 'package:mvvm_task/view/customWidgets/continue_button.dart';
import 'package:mvvm_task/view/customWidgets/icon_button.dart';
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
  final _passwordTextController = TextEditingController();
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
                phoneTextController: _passwordTextController,
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
                        SizedBox(
                          height: getProportionateScreenHeight(23.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 43),
                          child: createIconButton(() async {
                            // User? user = await authProvider.signInWithGoogle(
                            //     context: context);

                            // if (user != null) {
                            //   Navigator.pushNamed(
                            //       context, AppStrings.homeRoute);
                            // }
                          }, AppStrings.signUpWithPhone),
                        )
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
    required this.phoneTextController,
  }) : super(key: key);
  final GlobalKey formKey;
  final TextEditingController emailTextController;
  final TextEditingController phoneTextController;

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
            AppStrings.phoneHint,
            style: TextStyle(
                fontSize: getProportionatefontSize(11),
                color: AppColors.formFieldLabel,
                fontWeight: FontWeight.bold),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            validator: (value) => Validator.validatePhone(phone: value ?? ''),
            controller: widget.phoneTextController,
            decoration: const InputDecoration(
                hintText: AppStrings.phoneHint,
                icon:
                    Icon(Icons.phone_android_outlined, color: AppColors.black)),
          ),
          Spacing.mediumHeight(),
        ],
      ),
    );
  }
}
