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
    // List<Medicine>  medicine = List.empty();
    final response = await http.get(Uri.parse(AppStrings.baseUrl));

    if (response.statusCode == 200) {
      print("${response.statusCode} server stuff");
      final jsonResult = json.decode(response.body);
      return flatten(jsonResult);

      // return List<Medicine>.from(jsonResult['problems']
      //         .map((data) => Medicine.fromJson(data))
      //         .toList() ??
      //     []);
    } else {
      print("${response.body} server stuff");
      throw Exception('Failed to load list of medication');
    }
  }

  List<Medicine> flatten(response) {
    List<List<Map<String, dynamic>>?> _1 =
        (response['problems'][0] as Map<String, dynamic>)
            .entries
            .map((ailment) {
              if ((ailment.value[0] as Map<String, dynamic>).entries.isEmpty) {
                return null;
              }

              Map<String, dynamic> medicationClasses =
                  ailment.value[0]['medications'][0]['medicationsClasses'][0];
              List<List<Map<String, dynamic>>> associatedDrugs =
                  medicationClasses.entries
                      .map((className) =>
                          ((className.value[0] as Map<String, dynamic>).entries)
                              .map((x) => x.value[0] as Map<String, dynamic>)
                              .toList())
                      .toList();

              List<Map<String, dynamic>> drugs;

              if (associatedDrugs.length == 1) {
                drugs = associatedDrugs.first;
              } else {
                drugs = associatedDrugs.reduce((a, b) => [...a, ...b]);
              }

              return drugs;
            })
            .where((element) => element != null)
            .toList();

    List<Map<String, dynamic>> allDrugs;

    if (_1.length == 1) {
      allDrugs = _1.first!;
    } else {
      allDrugs = _1.reduce((a, b) => [...a!, ...b!])!;
    }

    return allDrugs.map((e) => Medicine.fromJson(e)).toList();
  }
}
