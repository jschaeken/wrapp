import 'package:flutter/cupertino.dart';

class GetPlate extends ChangeNotifier {
  String _plate = '';
  String get plate => _plate;
  set plate(String value) {
    _plate = value;
    notifyListeners();
  }

  // void searchPlate() async {
  //   Future<String> getNCTSResponse(String registrationId) async {
  //     final http.Response response =
  //         await http.get('https://ncts.ie/1101' as Uri);
  //     if (response.statusCode == 200) {
  //       final document = parse(response.body);
  //       // The xpath for the textfield
  //       final textField = document.firstElementChild
  //           .findAllElements('input')
  //           .where((e) => e.attributes['id'] == 'RegistrationID')
  //           .first;
  //       // Set the value of the textfield
  //       textField.attributes['value'] = registrationId;
  //       // Submit the form
  //       final form = document.getElementById('inputForm');
  //       final response = await http.post('https://ncts.ie/1101' as Uri,
  //           body: form?.outerHtml ?? '');
  //       // return the response as a string
  //       return response.body;
  //     } else {
  //       throw Exception('Failed to load NCTS response');
  //     }
  //   }
  // }
}
