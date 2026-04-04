import 'package:attendalert/core/network/dio_client.dart';
import 'package:attendalert/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:attendalert/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  // Any time a function returns a Future,
  // you must use await if you want to crack open that Future and use the actual data inside it.
  AuthRemoteDataSourceImpl(this.dioClient);
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        "Dummy-url",
        data: {"email": email, "password": password},
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Error occured : ${e.message}");
    }
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await dioClient.dio.post("dummy-url");
    return UserModel.fromJson(response.data);
  }
}
