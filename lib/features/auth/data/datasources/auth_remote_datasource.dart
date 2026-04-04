import 'package:attendalert/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({
    required String email,
    required String password,
    required String name,
  });
}
