import 'package:ai_assistent_app/controllers/account_controller.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class AppAPI {
  static String baseUrl = 'https://~~~';

  // static getHeader() {
  //   AccountController accountController = Get.find();
  //   return {
  //     'Authorization': 'token : ${accountController.accessToken.value}',
  //   };
  // }

  // 2024.03.19
  // 유저 구분을 헤더로 하는데,
  // 이 부분은 백엔드쪽에서 강의 들어보고 맞춰서 해야 할듯.

  static checkAccessToken(String accessToken) async {
    Dio dio = DioServices().to();
    final res = await dio.post('/api/v1/check_token', data: {
      'token': accessToken,
    });
    var data = res.data;
    return data['token'];
  }

  static login(id, password) async {
    Dio dio = DioServices().to();
    final res = await dio.post('/api/v1/login', data: {
      'id': id,
      'password': password,
    });
    var data = res.data;
    return {
      'success': data['access_token'] != null,
      'accessToken': data['access_token'] ?? '',
    };
  }

  static logout() async {
    Dio dio = DioServices().to();
    final res = await dio.post('/api/v1/user/logout');
    var data = res.data;
    return {
      'success': data['logout_status'] == 'true',
    };
  }

  static getUserInfo() async {
    Dio dio = DioServices().to();
    final res = await dio.get('/api/v1/user');
    var data = res.data;
    return data;
  }
}

class DioServices {
  static final DioServices _dioServices = DioServices._internal();
  factory DioServices() => _dioServices;
  Map<String, dynamic> dioInformation = {};

  static Dio _dio = Dio();

  DioServices._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: AppAPI.baseUrl,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
      // headers: {},
    );
    _dio = Dio(options);
    _dio.interceptors.add(DioInterceptor());
  }

  Dio to() {
    return _dio;
  }
}

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.e("BaseUrl ${options.baseUrl}");
    logger.e("Path ${options.path}");
    logger.e("Parameters ${options.queryParameters}");
    logger.e("Data ${options.data}");
    logger.e("Connect Timeout ${options.connectTimeout}");
    logger.e("Send Timeout ${options.sendTimeout}");
    logger.e("Receive Timeout ${options.receiveTimeout}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.e(response.statusCode);
    logger.e(response.data);
    logger.e("BaseUrl ${response.requestOptions.baseUrl}");
    logger.e("Path ${response.requestOptions.path}");
    logger.e("Parameters ${response.requestOptions.queryParameters}");
    logger.e("Data ${response.requestOptions.data}");
    logger.e("Connect Timeout ${response.requestOptions.connectTimeout}");
    logger.e("Send Timeout ${response.requestOptions.sendTimeout}");
    logger.e("Receive Timeout ${response.requestOptions.receiveTimeout}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e("Error ${err.error}");
    logger.e("Error Message ${err.message}");
    super.onError(err, handler);
  }
}
