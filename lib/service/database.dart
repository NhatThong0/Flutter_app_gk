import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
    Map<String, dynamic> employeeInfoMap,
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection("Employees")
        .doc(id)
        .set(employeeInfoMap);
  }
//Read employee
  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return FirebaseFirestore.instance.collection("Employees").snapshots();
  }
// Update employee
  Future updateEmployeeDetails(
    String id,
    Map<String, dynamic> updateInfo,
  ) async {
    return await FirebaseFirestore.instance
        .collection("Employees")
        .doc(id)
        .update(updateInfo);
  }
// Delete employee
  Future deleteEmployee(String id) async {
    return await FirebaseFirestore.instance
        .collection("Employees")
        .doc(id)
        .delete();
  }
}
