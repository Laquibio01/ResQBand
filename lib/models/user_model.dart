class UserModel {
  final String name;
  final String gender;
  final String birthDate;
  final String bloodType;
  final String address;
  final String emergencyContact;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> medications;

  UserModel({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.bloodType,
    required this.address,
    required this.emergencyContact,
    required this.allergies,
    required this.chronicConditions,
    required this.medications,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      birthDate: map['birthDate'].toString().split('T').first,
      bloodType: map['bloodType'] ?? '',
      address: map['address'] ?? '',
      emergencyContact: map['emergencyContact']?['name'] != null
          ? '${map['emergencyContact']['name']} - ${map['emergencyContact']['phone']}'
          : '',
      allergies: List<String>.from(map['allergies'] ?? []),
      chronicConditions: List<String>.from(map['chronicConditions'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
    );
  }
}
