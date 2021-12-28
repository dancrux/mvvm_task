class Medicine {
  final String? name, dose, strength;

  Medicine({
    this.name,
    this.dose,
    this.strength,
  });

  factory Medicine.fromJson(Map<dynamic, dynamic> json) {
    Map medicineDetail = json['problems'][0]['Diabetes'][0]['medications'][0]
        ['medicationsClasses'][0]['className'][0]['associatedDrug'][0];
    String name = '';
    String dose = '';
    String strength = '';

    if (medicineDetail['name'] != null) {
      name = medicineDetail['name'];
    }
    if (medicineDetail['dose'] != null) {
      dose = medicineDetail['dose'];
    }
    if (medicineDetail['strength'] != null) {
      strength = medicineDetail['strength'];
    }

    return Medicine(
      name: name,
      dose: dose,
      strength: strength,
    );
  }
}
