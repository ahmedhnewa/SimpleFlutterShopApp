const databaseUrl =
    'https://demoproject-970fa-default-rtdb.europe-west1.firebasedatabase.app';
const productsUrl = '$databaseUrl/products';
const ordersUrl = '$databaseUrl/orders';
String getOrdersUrlOfUser(String userId) => '$ordersUrl/$userId.json';
const apiKey = 'AIzaSyC22WK6kW3MqglmawbQpf8sZOOwW_gIBMw';
final signUpUrl = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');
final signInUrl = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');
String getProductUrl(String productId) => '$productsUrl/$productId.json';
String getUserFavoriteUrl(
        {required String userId, required String productId}) =>
    '$databaseUrl/userFavorites/$userId/$productId.json';
String getUserFavoritesUrl(String userId) =>
    '$databaseUrl/userFavorites/$userId.json';

String attachTokenParameter(String token) => '?auth=$token';
