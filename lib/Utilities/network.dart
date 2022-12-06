import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:async';

class Network {
  Future<Set<String>> parser() async {
    int i = 128;
    Set<String> codesList = {};
    String url =
        "https://www.boards.ie/discussion/2056744169/dominos-pizza-codes-cant-use-with-meal-deals/p$i";
    Uri uri = Uri.parse(url);
    var page = await http.get(uri);
    var document = parse(page.body);
    List<String> words = [];
    List<DateTime> postDates = [];
    document.querySelectorAll('*').forEach((node) {
      if (node.text.trim().isNotEmpty) {
        words.addAll(node.text.split(' '));
      }
    });
    for (var word in words) {
      String? answer = findWordWithThreeCapitals(word);
      if (answer != 'GAMSAT' && answer != null) {
        codesList.add(answer);
      }
    }
    return codesList;
  }

  String? findWordWithThreeCapitals(String string) {
    int count = 0;
    for (String char in string.split('')) {
      if (char.toUpperCase() == char) {
        count++;
      }
    }
    if (count >= 4 &&
        string.length > 5 &&
        string.length < 9 &&
        string.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
      return string;
    } else {
      return null;
    }
  }
}

//make a class for the discount codes
class DiscountCode {
  String code;
  String discountAmount;
  String datePosted;
  DiscountCode(this.code, this.discountAmount, this.datePosted);
}
