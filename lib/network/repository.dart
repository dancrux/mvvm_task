import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/strings.dart';
import 'package:mvvm_task/network/model/medicine_model.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<List<Medicine>> getMedicineInfo() async {
    List<Medicine> list = List.empty();

    final response = await http.get(Uri.parse(AppStrings.baseUrl));

    if (response.statusCode == 200) {
      print("${response.statusCode} server stuff");
      final jsonResult = json.decode(response.body);

      return list = List<Medicine>.from(
          jsonResult['items'].map((data) => Medicine.fromJson(data)).toList());
    } else {
      print("${response.body} server stuff");
      throw Exception('Failed to load list of books');
    }
  }
}
