abstract class AppRoute {
  static const home = 'home';
  static const cart = 'cart';
  static const favorites = 'favorites';
  static const profile = 'profile';
  static const productDetails = 'product_details';
  static const search = 'search';
  static const checkout = 'checkout';
  static const orderConfirm = 'order_confirm';
  static const orders = 'orders';
  static const products = 'products';
  static const myProducts = 'my_products';
  static const createProduct = 'create_product';
  static const editProfile = 'edit_profile';

  static const login = 'login';
  static const confirmEmailOtp = 'confirm_email_otp';
  static const resetPwdOtp = 'reset_pwd_otp';
}

abstract class AppRouteGuard {
  static const guestOnlyRoutes = {'/login', '/confirm_email_otp'};
  static const authenticatedOnlyRoutes = {
    '/',
    '/cart',
    '/favorites',
    '/profile',
    '/product_details',
    '/search',
    '/checkout',
    '/order_confirm',
    '/orders',
    '/products',
    '/my_products',
    '/create_product',
    '/edit_profile',
  };
}
