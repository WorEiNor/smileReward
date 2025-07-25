import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:loyalty_app/models/item_model.dart';

class ApiService {
  static Future<List<Reward>> fetchRewards() async {

    //Replace with api
    await Future.delayed(Duration(seconds: 2));
    final String jsonString = await rootBundle.loadString(
      'assets/reward_list.json',
    );


    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> jsonList = jsonMap['data'];
    return jsonList.map((e) => Reward.fromJson(e)).toList();
  }
}
