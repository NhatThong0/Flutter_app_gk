import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/employee.dart';
import 'package:flutter_application_1/authentication/login.dart';
import 'package:flutter_application_1/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController idspEditingController = TextEditingController();
  TextEditingController giaEditingController = TextEditingController();
  TextEditingController loaiEditingController = TextEditingController();
  TextEditingController imageEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  Stream? EmployeeStream;
  String searchKeyword = '';
  bool isSearching = false;
  Stream? searchStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    if (mounted) {
      setState(() {});
    }
  }

  searchByCategory(String category) async {
    searchStream = FirebaseFirestore.instance
        .collection("employees")
        .where("Loai", isEqualTo: category)
        .snapshots();
    setState(() {});
  }


  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
      stream: EmployeeStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text("Không có sản phẩm nào"));
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            ds["HinhAnh"],
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "IDSP: ${ds["IDSP"]}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          GestureDetector(
  onTap: () {
    idspEditingController.text = ds["IDSP"];
    giaEditingController.text = ds["Gia"];
    loaiEditingController.text = ds["Loai"];
    imageEditingController.text = ds["HinhAnh"];
    EditEmployeeDetails(ds['Id'], ds["IDSP"]); // Truyền ID sản phẩm hiện tại
  },
  child: Icon(Icons.edit, color: Colors.orange),
),

                          SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Xác nhận xóa"),
                                  content: Text("Bạn có muốn xóa sản phẩm này không?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Không"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await DatabaseMethods().deleteEmployee(ds["Id"]);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Có"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                      Text("Giá: ${ds["Gia"]}", style: TextStyle(color: Colors.cyan)),
                      Text("Loại: ${ds["Loai"]}", style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Employee()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Nhập loại sản phẩm...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    searchByCategory(value);
                  } else {
                    setState(() => searchStream = null);
                  }
                },
              )
            : Text("Danh sách Sản phẩm", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: const Color.fromARGB(255, 234, 9, 9)),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchController.clear();
                searchStream = null;
              });
            },
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: allEmployeeDetails(),
      ),
    );
  }

  Future EditEmployeeDetails(String id, String currentIDSP) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Chỉnh sửa Sản phẩm", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: idspEditingController, decoration: InputDecoration(labelText: "IDSP")),
            TextField(controller: giaEditingController, decoration: InputDecoration(labelText: "Giá")),
            TextField(controller: loaiEditingController, decoration: InputDecoration(labelText: "Loại")),
            TextField(
              controller: imageEditingController,
              decoration: InputDecoration(labelText: "Hình ảnh URL"),
            ),
            SizedBox(height: 10),
            Image.network(
              imageEditingController.text,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () async {
    String newIDSP = idspEditingController.text;

    // Kiểm tra IDSP mới đã tồn tại trong Firestore hay chưa
    var existingProducts = await FirebaseFirestore.instance
        .collection("employees")
        .where("IDSP", isEqualTo: newIDSP)
        .get();

    // Nếu IDSP đã tồn tại và không phải chính nó => báo lỗi
    if (existingProducts.docs.isNotEmpty && existingProducts.docs.first.id != id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("IDSP đã tồn tại! Vui lòng nhập IDSP khác.")),
      );
      return;
    }

    // Nếu ID hợp lệ, cập nhật sản phẩm
    await DatabaseMethods().updateEmployeeDetails(id, {
      "IDSP": newIDSP,
      "Gia": giaEditingController.text,
      "Loai": loaiEditingController.text,
      "HinhAnh": imageEditingController.text,
    });

    Navigator.pop(context);
    getontheload();
  },
  child: Text("Cập nhật"),
),
          ],
        ),
      ),
    );

      
}
