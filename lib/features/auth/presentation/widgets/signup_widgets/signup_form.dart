import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_technical_assessment/core/widgets/custom_text_field.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/validators.dart';
import 'signup_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
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
                label: AppStrings.fullName,
                hintText: AppConstants.fullNameHint,
                hintStyle: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  size: 20,
                  color: AppColors.grey400,
                ),
                controller: _nameController,
                focusNode: _nameFocusNode,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    Validators.required(value, fieldName: AppStrings.fullName),
                onFieldSubmitted: (_) => _phoneFocusNode.requestFocus(),
                style: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                filled: true,
                fillColor: AppColors.grey50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: info.spacing(ResponsiveSpacing.md),
                  vertical: info.spacing(ResponsiveSpacing.md),
                ),
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
              CustomTextField(
                label: AppStrings.phoneNumber,
                hintText: AppConstants.phoneNumberHint,
                hintStyle: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  size: 20,
                  color: AppColors.grey400,
                ),
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) => Validators.required(
                  value,
                  fieldName: AppStrings.phoneNumber,
                ),
                onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                style: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                filled: true,
                fillColor: AppColors.grey50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: info.spacing(ResponsiveSpacing.md),
                  vertical: info.spacing(ResponsiveSpacing.md),
                ),
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
              CustomTextField(
                label: AppStrings.emailAddress,
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
                controller: _emailController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
                onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                style: TextStyle(
                  fontSize: info.responsiveFontSize(15),
                  color: AppColors.black,
                ),
                filled: true,
                fillColor: AppColors.grey50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: info.spacing(ResponsiveSpacing.md),
                  vertical: info.spacing(ResponsiveSpacing.md),
                ),
              ),
              SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
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
                hintText: AppConstants.passwordHint,
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
              SignupButton(
                formKey: _formKey,
                nameController: _nameController,
                phoneController: _phoneController,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ],
          ),
        );
      },
    );
  }
}
