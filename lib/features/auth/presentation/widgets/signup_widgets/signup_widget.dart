import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter_technical_assessment/core/widgets/custom_toast/custom_toast.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/services/services.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';
import '../login_widgets/signup_link.dart';
import 'signup_form.dart';



class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          sl<NavigationService>().navigateAndRemoveUntil(Routes.dashboard);
        }
        if (state is AuthError) {
          CustomToast.error(context, state.message);
        }
      },
      child: ResponsiveBuilder(
        builder: (context, info) {
          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: info.spacing(ResponsiveSpacing.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.signUp,
                      style: TextStyle(
                        fontSize: info.responsiveFontSize(32),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: info.spacing(ResponsiveSpacing.xl)),
                    const SignUpForm(),
                    SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
                    const SignupLink(),
                    SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
