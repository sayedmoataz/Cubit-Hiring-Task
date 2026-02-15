import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    super.key,
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    void _signUp() {
      if (formKey.currentState!.validate()) {
        context.read<AuthBloc>().add(
          SignupEvent(
            name: nameController.text.trim(),
            phone: phoneController.text.trim(),
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
                text: AppStrings.signUp,
                textColor: AppColors.white,
                onPressed: _signUp,
                isLoading: isLoading,
                fontSize: info.responsiveFontSize(16),
              ),
            );
          },
        );
      },
    );
  }
}
