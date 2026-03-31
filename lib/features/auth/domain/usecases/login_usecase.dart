import 'package:attendalert/features/auth/domain/entities/user.dart';
import 'package:attendalert/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;
  LoginUseCase({required this.authRepository});
  Future<User> call({required String email, required String password}) {
    return authRepository.login(email: email, password: password);
  }
}
