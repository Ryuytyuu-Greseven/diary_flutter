import 'package:diary/src/api_services/api_settings.dart';

class ApiService {
  ApiService();

  ApiSettings apiSettings = ApiSettings();

  login(body,context) {
    final url = '${ApiSettings.apis['LOGIN_USER']}';
    return apiSettings.requestServer(body, url, context);
  }

  singup(body,context) {
    final url = '${ApiSettings.apis['SIGNUP_USER']}';
    return apiSettings.requestServer(body, url, context);
  }

  verifyUser(body,context) {
    final url = '${ApiSettings.apis['VERIFY_USER']}';
    return apiSettings.requestServer(body, url, context);
  }

  resendOtp(body,context) {
    final url = '${ApiSettings.apis['RESEND_OTP']}';
    return apiSettings.requestServer(body, url, context);
  }

  userDetails(body,context) {
    final url = '${ApiSettings.apis['FETCH_USER_DETAILS']}';
    return apiSettings.requestServer(body, url, context);
  }

  createDairy(body,context) {
    final url = '${ApiSettings.apis['CREATE_DAIRY']}';
    return apiSettings.requestServer(body, url, context);
  }

  selfDairies(body,context) {
    final url = '${ApiSettings.apis['FETCH_SELF_DAIRIES']}';
    return apiSettings.requestServer(body, url, context);
  }

  dairyDetails(body,context) {
    final url = '${ApiSettings.apis['FETCH_DAIRY_DETAILS']}';
    return apiSettings.requestServer(body, url, context);
  }

  savePage(body,context) {
    final url = '${ApiSettings.apis['SAVE_PAGE']}';
    return apiSettings.requestServer(body, url, context);
  }

  pagesFromDairy(body,context) {
    final url = '${ApiSettings.apis['DAIRY_PAGES']}';
    return apiSettings.requestServer(body, url, context);
  }

  // password reset request
  forgotPassword(body,context) {
    final url = '${ApiSettings.apis['REQUEST_PASS_RESET']}';
    return apiSettings.requestServer(body, url, context);
  }
}
