import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _uidKey = 'user_uid';

  static Future<void> saveUID(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_uidKey, uid);
  }

  static Future<String?> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_uidKey);
  }

  static Future<void> clearUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_uidKey);
  }
}


class EventCache {
  static const _key = 'cached_user_event_data';

  static Future<void> cacheEvents(String uid, List<String> events) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> data = {
      'uid': uid,
      'events': events,
    };
    prefs.setString(_key, jsonEncode(data));
  }

  static Future<List<String>> getCachedEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final List<dynamic> jsonList = jsonMap['events'];
      return List<String>.from(jsonList);
    }
    return [];
  }

  static Future<String?> getCachedUid() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return jsonMap['uid'] as String?;
    }
    return null;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key); // 🔥 clears event data
  }
}
