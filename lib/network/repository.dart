import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/strings.dart';
import 'package:mvvm_task/db/app_sqlite_.dart';
import 'package:mvvm_task/network/model/medicine_model.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future saveEmail(String email) async {
    try {
      var value = {'userEmail': email};
      await AppSqliteDb.sqliteDb?.insert(AppStrings.dbTableName, value);
    } catch (e) {
      print(e);
    }
  }

  // Future<String> getEmail(String email) async {
  //   var email = '';
  //   try {
  //     var value = {'userEmail': email};
  //     email = await AppSqliteDb.sqliteDb?.query(
  //       AppStrings.dbTableName,
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<List<Medicine>> getMedicineInfo() async {
    // List<Medicine>  = List.empty();

    final response = await http.get(Uri.parse(AppStrings.baseUrl));

    if (response.statusCode == 200) {
      print("${response.statusCode} server stuff");
      final jsonResult = json.decode(response.body);

      return List<Medicine>.from(jsonResult['problems']
              .map((data) => Medicine.fromJson(data))
              .toList() ??
          []);
    } else {
      print("${response.body} server stuff");
      throw Exception('Failed to load list of books');
    }
  }
}
