import 'package:attendalert/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess({required this.user});
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});
}
