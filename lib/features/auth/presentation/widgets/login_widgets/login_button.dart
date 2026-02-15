import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
  });
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    void _login() {
      if (formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
          LoginWithCredentialsEvent(
            email: emailController.text.trim(),
            password: passwordController.text,
          ),
        );
      }
    }

    return ResponsiveBuilder(
      builder: (context, info) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SizedBox(
              height: info.responsiveValue<double>(mobile: 56, tablet: 60),
              child: CustomButton(
                text: AppStrings.signIn,
                textColor: AppColors.white,
                onPressed: _login,
                isLoading: isLoading,
              ),
            );
          },
        );
      },
    );
  }
}
