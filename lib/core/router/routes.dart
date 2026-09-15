abstract class AppRoute {
  static const home = 'home';
  static const cart = 'cart';
  static const favorites = 'favorites';
  static const profile = 'profile';
  static const productDetails = 'product_details';

  static const login = 'login';
  static const confirmEmailOtp = 'confirm_email_otp';
  static const resetPwdOtp = 'reset_pwd_otp';
  static const bridge = 'bridge';
}

abstract class AppRouteGuard {
  static const guestOnlyRoutes = {'/login', '/confirm_email_otp'};
  static const authenticatedOnlyRoutes = {
    '/',
    '/cart',
    '/favorites',
    '/profile',
    '/product_details',
  };
}
