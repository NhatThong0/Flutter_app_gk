import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController idspEditingController = TextEditingController();
  TextEditingController giaEditingController = TextEditingController();
  TextEditingController loaiEditingController = TextEditingController();
  TextEditingController imageEditingController = TextEditingController();

  String imageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Thêm ",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
              "Sản Phẩm",
              style: TextStyle(
                color: Color.fromARGB(255, 240, 2, 2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(
              "ID sản phẩm",
              "Nhập ID sản phẩm",
              idspEditingController,
              isNumeric: true,
            ),
            buildTextField(
              "Giá",
              "Nhập giá sản phẩm",
              giaEditingController,
              isNumeric: true,
            ),
            buildTextField(
              "Loại sản phẩm",
              "Nhập loại sản phẩm",
              loaiEditingController,
            ),
            buildTextField(
              "Hình ảnh",
              "Nhập URL hình ảnh",
              imageEditingController,
              onChanged: (value) {
                setState(() {
                  imageUrl = value;
                });
              },
            ),
            SizedBox(height: 10.0),
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 100,
                    width: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return Text("URL không hợp lệ");
                    },
                  )
                : Container(),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                if (idspEditingController.text.isEmpty ||
                    giaEditingController.text.isEmpty ||
                    loaiEditingController.text.isEmpty ||
                    imageEditingController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Vui lòng nhập đầy đủ thông tin",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                String Id = randomAlphaNumeric(10);
                Map<String, dynamic> employeeInfoMap = {
                  "IDSP": idspEditingController.text,
                  "Gia": giaEditingController.text,
                  "Id": Id,
                  "Loai": loaiEditingController.text,
                  "HinhAnh": imageEditingController.text,
                };

                // Kiểm tra ID sản phẩm trùng lặp trước khi thêm
                String result = await DatabaseMethods().addEmployeeDetails(employeeInfoMap, Id);
                
                Fluttertoast.showToast(
                  msg: result,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: result == "Thêm sản phẩm thành công!" ? Colors.green : Colors.red,
                  textColor: Colors.white,
                );
              },
              child: Text(
                "Thêm",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool isNumeric = false,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 7.0),
        Container(
          padding: EdgeInsets.only(left: 5.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
