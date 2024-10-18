class JadwalVaksinasi {
  int id;
  String personName;
  String vaccineType;
  int age;

  JadwalVaksinasi({
    required this.id,
    required this.personName,
    required this.vaccineType,
    required this.age,
  });

  factory JadwalVaksinasi.fromJson(Map<String, dynamic> json) {
    return JadwalVaksinasi(
      id: json['id'] as int,
      personName: json['person_name'] as String,
      vaccineType: json['vaccine_type'] as String,
      age: json['age'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'person_name': personName,
      'vaccine_type': vaccineType,
      'age': age,
    };
  }
}