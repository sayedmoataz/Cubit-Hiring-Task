import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_assessment/core/utils/app_strings.dart';

import '../../../../core/network/network_info.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/biometric/contracts/biometric_consumer.dart';
import '../../../../core/services/biometric/utils/biometric_preferences.dart';
import '../../../../core/services/firebase/crashlytics/crashlytics_logger.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final BiometricConsumer biometricConsumer;
  final BiometricPreferences biometricPreferences;
  final NavigationService navigationService;
  final NetworkInfo networkInfo;

  AuthBloc({
    required this.repository,
    required this.biometricConsumer,
    required this.biometricPreferences,
    required this.navigationService,
    required this.networkInfo,
  }) : super(AuthInitial()) {
    on<CheckBiometricEvent>(_onCheckBiometric);
    on<SignupEvent>(_onSignup);
    on<LoginWithCredentialsEvent>(_onLoginWithCredentials);
    on<LoginWithBiometricEvent>(_onLoginWithBiometric);
    on<SetupBiometricEvent>(_onSetupBiometric);
    on<SkipBiometricEvent>(_onSkipBiometric);
    on<LogoutEvent>(_onLogout);
  }

  /// Check if biometric is enabled
  Future<void> _onCheckBiometric(
    CheckBiometricEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(BiometricCheckLoading());

      final result = await biometricPreferences.isBiometricEnabled();

      result.fold((failure) => emit(BiometricNotAvailable()), (enabled) {
        if (enabled) {
          emit(BiometricAvailable());
          add(LoginWithBiometricEvent());
        } else {
          emit(ShowLoginForm());
        }
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to check biometric',
        feature: 'AuthBloc',
      );
      emit(ShowLoginForm());
    }
  }

  /// Signup
  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      if (!await networkInfo.isConnected) {
        emit(const AuthError('Internet connection required for signup'));
        return;
      }

      final result = await repository.signup(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );

      result.fold((failure) => emit(AuthError(failure.message)), (user) async {
        emit(BiometricSetupPrompt());
        add(SetupBiometricEvent());
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to signup',
        feature: 'AuthBloc',
      );
      emit(const AuthError('An unexpected error occurred during signup'));
    }
  }

  // Setup biometric (after signup)
  Future<void> _onSetupBiometric(
    SetupBiometricEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final availableResult = await biometricConsumer.isBiometricAvailable();

      final isAvailable = availableResult.fold(
        (failure) => false,
        (available) => available,
      );

      if (!isAvailable) {
        emit(BiometricSetupSkipped());
        await biometricPreferences.setBiometricEnabled(false);
        navigationService.navigateAndRemoveUntil(Routes.dashboard);
        return;
      }

      final authResult = await biometricConsumer.authenticateWithBiometric(
        reason: AppStrings.enableBiometricLogin,
      );

      await authResult.fold(
        (failure) async {
          emit(BiometricSetupSkipped());
          await biometricPreferences.setBiometricEnabled(false);
          navigationService.navigateAndRemoveUntil(Routes.dashboard);
        },
        (success) async {
          if (success) {
            emit(BiometricSetupSuccess());
            await biometricPreferences.setBiometricEnabled(true);
            navigationService.navigateAndRemoveUntil(Routes.dashboard);
          } else {
            emit(BiometricSetupSkipped());
            await biometricPreferences.setBiometricEnabled(false);
            navigationService.navigateAndRemoveUntil(Routes.dashboard);
          }
        },
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to setup biometric',
        feature: 'AuthBloc',
      );
      emit(BiometricSetupSkipped());
      await biometricPreferences.setBiometricEnabled(false);
      navigationService.navigateReplace(Routes.dashboard);
    }
  }

  /// Skip biometric setup
  Future<void> _onSkipBiometric(
    SkipBiometricEvent event,
    Emitter<AuthState> emit,
  ) async {
    await biometricPreferences.setBiometricEnabled(false);
    emit(BiometricSetupSkipped());
    navigationService.navigateReplace(Routes.dashboard);
  }

  /// Login with credentials
  Future<void> _onLoginWithCredentials(
    LoginWithCredentialsEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      if (!await networkInfo.isConnected) {
        emit(
          const AuthError(
            'No internet connection. Enable biometric for offline access',
          ),
        );
        return;
      }

      final result = await repository.login(
        email: event.email,
        password: event.password,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to login',
        feature: 'AuthBloc',
      );
      emit(const AuthError('An unexpected error occurred during login'));
    }
  }

  /// Login with biometric
  Future<void> _onLoginWithBiometric(
    LoginWithBiometricEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final authResult = await biometricConsumer.authenticateWithBiometric(
        reason: AppStrings.loginToYourAccount,
      );

      await authResult.fold(
        (failure) async {
          emit(BiometricFailed(failure.message));
          emit(ShowLoginForm());
        },
        (success) async {
          if (!success) {
            emit(
              const BiometricFailed(AppStrings.biometricAuthenticationFailed),
            );
            emit(ShowLoginForm());
            return;
          }

          final hasInternet = await networkInfo.isConnected;

          if (hasInternet) {
            final result = await repository.getCurrentUser();

            result.fold(
              (failure) => emit(AuthError(failure.message)),
              (user) => emit(AuthSuccess(user)),
            );
          } else {
            final result = await repository.getCachedUser();

            result.fold(
              (failure) => emit(const AuthError('Failed to load cached data')),
              (user) {
                if (user != null) {
                  emit(AuthSuccessOffline(user));
                } else {
                  emit(const AuthError('No cached user data found'));
                }
              },
            );
          }
        },
      );
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to login with biometric',
        feature: 'AuthBloc',
      );
      emit(
        const AuthError('An unexpected error occurred during biometric login'),
      );
      emit(ShowLoginForm());
    }
  }

  /// Logout
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      final result = await repository.logout();

      result.fold((failure) => emit(AuthError(failure.message)), (_) {
        emit(AuthLoggedOut());
        navigationService.navigateReplace(Routes.login);
      });
    } catch (e, stackTrace) {
      CrashlyticsLogger.logError(
        e,
        stackTrace,
        reason: 'Failed to logout',
        feature: 'AuthBloc',
      );
      emit(const AuthError('An unexpected error occurred during logout'));
    }
  }
}
