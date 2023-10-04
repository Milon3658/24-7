import 'firebase_collections.dart';

class ProfileModel {
  String? id;
  late String name;
  late String phone;
  late String email;
  String? address;
  String? zone;
  String? type;
  ProfileModel({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    this.zone,
    this.type,
  });

  ProfileModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? zone,
    String? type,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      zone: zone ?? this.zone,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
          "id": id,
          "name": name,
          "phone": phone,
          "email": email,
          "address": address,
          "zone": zone,
          "type": type,
        };
      }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
       return ProfileModel(
        id: map["id"],
        name: map["name"],
        phone: map["phone"],
        email: map["email"],
        address: map["address"],
         zone: map["zone"],
         type: map["type"],
      );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    zone: json["zone"],
    type: json["type"],
  );

  @override
  String toString() {
    return 'ProfileModel{id: $id, name: $name, phone: $phone, email: $email, address: $address, zone: $zone, type: $type}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.address == address &&
        other.zone == zone &&
        other.type == type &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    email.hashCode ^
    address.hashCode ^
    zone.hashCode ^
    type.hashCode ^
    phone.hashCode;
  }

  save() {
    FirebaseCollections.PROFILECOLLECTION.doc(id).set(toMap());
  }

  update() {
  FirebaseCollections.PROFILECOLLECTION.doc(id).update(toMap());
  }

  static Stream<List<ProfileModel>> getProfiles() {
    try {
      return FirebaseCollections.PROFILECOLLECTION.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return ProfileModel.fromMap(doc.data() as Map<String, dynamic>)
            ..id = doc.id;
        }).toList();
      });
    } on Exception catch (e) {
      rethrow;
    }
  }

  delete() {
    FirebaseCollections.PROFILECOLLECTION.doc(id).delete();
  }

  static getProfileByUserId({required String uId}) async {
    try {
      return ProfileModel.fromMap(
          (await FirebaseCollections.PROFILECOLLECTION.doc(uId).get()).data()
              as Map<String, dynamic>);
    } on Exception {
      rethrow;
    }
  }

  static Stream<List<ProfileModel>> getProfileByEmail(String email) {
    try {
      return FirebaseCollections.PROFILECOLLECTION
          .where('email', isEqualTo: email)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ProfileModel.fromJson(doc.data() as Map<String, dynamic>)
            ..id = doc.id;
        }).toList();
      });
    } on Exception catch (e) {
      rethrow;
    }
  }
}
