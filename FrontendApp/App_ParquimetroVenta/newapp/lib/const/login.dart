import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsKeys {
  static const String walletId = 'walletid';
  static const String operatorId = 'operatorid';
  static const String refreshtokens = 'refreshtoken';
  static const String token = 'token';
  static const String nombre = 'nombre';
  static const String apellido = 'apellido';

  static Future<int> getStoredWallet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(walletId) ?? 0; // Devuelve 0 si no existe
  }

  static Future<int> getStoredValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(operatorId) ?? 0; // Devuelve 0 si no existe
  }

  static Future<String?> getNombre() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nombre); // Devuelve null si no existe
  }

  static Future<String?> getApellido() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(apellido); // Devuelve null si no existe
  }
}
