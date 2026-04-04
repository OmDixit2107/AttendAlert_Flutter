import 'package:dio/dio.dart';

class DioClient {
  // In Dart, a final variable must be initialized before the constructor body executes
  final Dio dio;

  // When you instantiate a class in Dart (e.g., final myObj = MyClass();),
  //  Dart goes through three distinct phases in this exact order:

  // Memory Allocation: Dart grabs a chunk of memory for your new object.
  //  At this exact millisecond, all variables are "empty" (null).

  // The Initializer List: Dart runs the initializer list (the code between the : and the {).
  //  This is where variables get their first, official values.
  //  3. The Constructor Body: Finally, Dart runs the code inside the curly braces
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: "dummy.com",
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    //interceptors come here
  }
}
