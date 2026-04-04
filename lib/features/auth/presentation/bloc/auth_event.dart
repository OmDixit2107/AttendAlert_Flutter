import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// UI se Login ka request aayega with email and password
class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// UI se Signup ka request aayega with name, email, and password
class SignupRequestedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignupRequestedEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}
