abstract class AppRoute {
  static const login = 'login';
  static const home = 'home';
  static const confirmEmailOtp = 'confirm_email_otp';
  static const resetPwdOtp = 'reset_pwd_otp';
}

abstract class AppRouteGuard {
  static const guestOnlyRoutes = {
    '/login',
    '/confirm_email_otp',
    '/reset_pwd_otp',
  };
  static const authenticatedOnlyRoutes = {'/'};
}
