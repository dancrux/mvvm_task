import 'package:flutter/material.dart';
import 'package:mvvm_task/network/model/medicine_model.dart';
import 'package:mvvm_task/network/repository.dart';
import 'package:mvvm_task/view/customWidgets/custom.dart';

enum HomeState {
  loading,
  dbLoading,
  completed,
  error,
}

class HomeViewModel extends ChangeNotifier {
  Repository repository = Repository();
  HomeState _state = HomeState.loading;
  HomeState get state => _state;

  List<Medicine> medicineInfo = List.empty();

  Future<List<Medicine>> getMedInfo(
    BuildContext context,
  ) async {
    try {
      var result = await repository.getMedicineInfo();
      _state = HomeState.completed;
      notifyListeners();
      if (result.isNotEmpty) {
        medicineInfo = result;
        return medicineInfo;
      } else {
        _state = HomeState.error;
        notifyListeners();
      }
    } catch (e) {
      _state = HomeState.error;
      notifyListeners();
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(content: e.toString()));
    }
    return medicineInfo;
  }
}
