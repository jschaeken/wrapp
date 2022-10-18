import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  void storeData(String key, String value) async {
    SharedPreferences localDqList = await SharedPreferences.getInstance();
    List<String>? preWrittenList = localDqList.getStringList(key);
    preWrittenList?.add(value);
    if (preWrittenList != null) {
      localDqList.setStringList(key, preWrittenList);
    }
  }

  Future<List<String>> retrieveData(String key) async {
    SharedPreferences localDqList = await SharedPreferences.getInstance();
    List<String>? data = localDqList.getStringList(key);
    if (data != null) {
      return data;
    } else
      return ['No Data Found'];
  }
}
