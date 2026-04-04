import 'package:attendalert/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:attendalert/features/auth/data/models/user_model.dart';
import 'package:attendalert/features/auth/domain/entities/user.dart';
import 'package:attendalert/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl({required this.authRemoteDataSource});
  @override
  Future<User> login({required String email, required String password}) async {
    final userModel = await authRemoteDataSource.login(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<User> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final userModel = await authRemoteDataSource.signup(
      email: email,
      password: password,
      name: name,
    );
    return userModel.toEntity();
  }
}
