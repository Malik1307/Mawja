import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static SharedPreferences? sharedpref;

  static initialize() async {
    sharedpref = await SharedPreferences.getInstance();
  }

  static Future<bool> WriteData({required String key, required value}) async {
            if (sharedpref == null) await initialize();

    try {
      if (value is String) return await sharedpref!.setString(key, value);
      if (value is bool) return await sharedpref!.setBool(key, value);
      if (value is int) return await sharedpref!.setInt(key, value);
      if (value is double) return await sharedpref!.setDouble(key, value);
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  static dynamic ReadData({required String key}) async {
            if (sharedpref == null) await initialize();

    return  sharedpref!.get(key);
  }

  static Future<bool> RemoveValue({required String key}) async{
        if (sharedpref == null) await initialize();

  return  sharedpref!.remove(key);
  }
}
