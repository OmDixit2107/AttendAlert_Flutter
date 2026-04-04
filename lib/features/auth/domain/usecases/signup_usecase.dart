import 'package:attendalert/features/auth/domain/entities/user.dart';
import 'package:attendalert/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;
  SignupUseCase({required this.authRepository});
  Future<User> call({
    required String email,
    required String password,
    required String name,
  }) {
    return authRepository.signup(name: name, email: email, password: password);
  }
}
