import 'package:attendalert/features/auth/domain/usecases/login_usecase.dart';
import 'package:attendalert/features/auth/domain/usecases/signup_usecase.dart';
import 'package:attendalert/features/auth/presentation/bloc/auth_event.dart';
import 'package:attendalert/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  AuthBloc({required this.loginUseCase, required this.signupUseCase})
    : super(AuthInitial()) {
    on<LoginRequestedEvent>(_onLoginRequestedEvent);
    on<SignupRequestedEvent>(_onSignupRequestedEvent);
  }

  Future<void> _onLoginRequestedEvent(
    LoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.call(
        email: event.email,
        password: event.password,
      );

      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignupRequestedEvent(
    SignupRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await signupUseCase.call(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
