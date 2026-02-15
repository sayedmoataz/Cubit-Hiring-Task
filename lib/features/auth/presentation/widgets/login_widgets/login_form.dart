import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_technical_assessment/core/widgets/custom_text_field.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/validators.dart';
import 'login_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: AppStrings.emailAddress,
                controller: _emailController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
                style: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                hintText: AppConstants.emailHint,
                hintStyle: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  size: 20,
                  color: AppColors.grey400,
                ),
                filled: true,
                fillColor: AppColors.grey50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: info.spacing(ResponsiveSpacing.md),
                  vertical: info.spacing(ResponsiveSpacing.md),
                ),
                onFieldSubmitted: (_) {
                  _passwordFocusNode.requestFocus();
                },
              ),
              CustomTextField(
                label: AppStrings.password,
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    Validators.required(value, fieldName: AppStrings.password),
                style: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                hintText: '••••••••',
                hintStyle: TextStyle(
                  fontSize: info.responsiveFontSize(18),
                  color: AppColors.black,
                  letterSpacing: 2,
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: AppColors.grey400,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.grey400,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                filled: true,
                fillColor: AppColors.grey50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: info.spacing(ResponsiveSpacing.md),
                  vertical: info.spacing(ResponsiveSpacing.md),
                ),
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.xl)),
              LoginButton(
                emailController: _emailController,
                passwordController: _passwordController,
                formKey: _formKey,
              ),
            ],
          ),
        );
      },
    );
  }
}
