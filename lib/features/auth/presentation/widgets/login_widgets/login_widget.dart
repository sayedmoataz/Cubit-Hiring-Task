import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/services/services.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_toast/custom_toast.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import 'login_form.dart';
import 'signin_link.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is BiometricAvailable) {
          context.read<AuthBloc>().add(LoginWithBiometricEvent());
        }
        if (state is AuthSuccess || state is AuthSuccessOffline) {
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: info.spacing(ResponsiveSpacing.lg),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.signIn,
                            style: TextStyle(
                              fontSize: info.responsiveFontSize(32),
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: info.spacing(ResponsiveSpacing.xl)),
                          const LoginForm(),
                          SizedBox(height: info.spacing(ResponsiveSpacing.lg)),
                          const SignInLink(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
