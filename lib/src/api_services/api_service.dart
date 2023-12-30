import 'package:diary/src/api_services/api_settings.dart';

class ApiService {
  ApiService();

  ApiSettings apiSettings = ApiSettings();

  login(body) {
    final url = '${ApiSettings.apis['LOGIN_USER']}';
    return apiSettings.requestServer(body, url);
  }

  singup(body) {
    final url = '${ApiSettings.apis['SIGNUP_USER']}';
    return apiSettings.requestServer(body, url);
  }

  verifyUser(body) {
    final url = '${ApiSettings.apis['VERIFY_USER']}';
    return apiSettings.requestServer(body, url);
  }

  resendOtp(body) {
    final url = '${ApiSettings.apis['RESEND_OTP']}';
    return apiSettings.requestServer(body, url);
  }

  userDetails(body) {
    final url = '${ApiSettings.apis['FETCH_USER_DETAILS']}';
    return apiSettings.requestServer(body, url);
  }

  createDairy(body) {
    final url = '${ApiSettings.apis['CREATE_DAIRY']}';
    return apiSettings.requestServer(body, url);
  }

  selfDairies(body) {
    final url = '${ApiSettings.apis['FETCH_SELF_DAIRIES']}';
    return apiSettings.requestServer(body, url);
  }

  dairyDetails(body) {
    final url = '${ApiSettings.apis['FETCH_DAIRY_DETAILS']}';
    return apiSettings.requestServer(body, url);
  }

  savePage(body) {
    final url = '${ApiSettings.apis['SAVE_PAGE']}';
    return apiSettings.requestServer(body, url);
  }

  pagesFromDairy(body) {
    final url = '${ApiSettings.apis['DAIRY_PAGES']}';
    return apiSettings.requestServer(body, url);
  }

  // password reset request
  forgotPassword(body) {
    final url = '${ApiSettings.apis['REQUEST_PASS_RESET']}';
    return apiSettings.requestServer(body, url);
  }
}
