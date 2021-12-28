import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_task/network/model/medicine_model.dart';

void main() {
  test('Test model class', () {
    final file = File('test/testResource/medicine.json').readAsStringSync();

    final medicine =
        Medicine.fromJson(jsonDecode(file) as Map<String, dynamic>);
    expect(medicine.name, 'asprin');
    expect(medicine.strength, '500 mg');
  });
}
