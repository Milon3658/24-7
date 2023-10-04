
import 'package:twofourseven/Controller/profile_controller.dart';

import 'firebase_collections.dart';

class RequestModel {
  String? id;
  late String name;
  late String email;
  late String phone;
  late String address;
  late String latlng;
  late String time;
  late String zone;
  RequestModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.latlng,
    required this.time,
    required this.zone,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    name: json["name"],
    address: json["address"],
    latlng: json["latlng"],
    time: json["time"],
    zone: json["zone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "name": name,
    "address": address,
    "latlng": latlng,
    "time": time,
    "zone": zone,
  };

  @override
  String toString() {
    return 'RequestModel{id: $id, email: $email, phone: $phone, name: $name, latlng: $latlng, address: $address, time: $time, zone: $zone}';
  }

  save() {
    FirebaseCollections.REQUESTCOLLECTION.doc(id).set(toJson());
  }

  static Stream<List<RequestModel>> getRequests() {
    try {
      return FirebaseCollections.REQUESTCOLLECTION
          .where("zone", isEqualTo: ProfileController.to.profile.value!.zone.toString())
          .snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return RequestModel.fromJson(doc.data() as Map<String, dynamic>)
            ..id = doc.id;
        }).toList();
      });
    } on Exception catch (e) {
      rethrow;
    }
  }

  update() {
    FirebaseCollections.REQUESTCOLLECTION.doc(id).update(toJson());
  }

  delete() {
    FirebaseCollections.REQUESTCOLLECTION.doc(id).delete();
  }
}