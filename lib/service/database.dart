import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  

  // 🔍 Kiểm tra ID sản phẩm đã tồn tại chưa
  Future<bool> checkIfIdExists(String idsp) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Employees")
        .where("IDSP", isEqualTo: idsp)
        .get();

    return querySnapshot.docs.isNotEmpty; // Trả về true nếu IDSP đã tồn tại
  }

  // 🆕 Thêm sản phẩm (Chặn ID trùng)
  Future<String> addEmployeeDetails(
    Map<String, dynamic> employeeInfoMap,
    String id,
  ) async {
    bool exists = await checkIfIdExists(employeeInfoMap["IDSP"]);
    if (exists) {
      return "ID sản phẩm đã tồn tại!";
    }

    await _firestore.collection("Employees").doc(id).set(employeeInfoMap);
    return "Thêm sản phẩm thành công!";
  }

  // 📥 Đọc danh sách sản phẩm
  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return _firestore.collection("Employees").snapshots();
  }

  // ✏️ Cập nhật sản phẩm
  Future<void> updateEmployeeDetails(
    String id,
    Map<String, dynamic> updateInfo,
  ) async {
    await _firestore.collection("Employees").doc(id).update(updateInfo);
  }

  // ❌ Xóa sản phẩm
  Future<void> deleteEmployee(String id) async {
    await _firestore.collection("Employees").doc(id).delete();
  }
}
