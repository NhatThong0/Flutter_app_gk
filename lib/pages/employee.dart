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
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController ageEditingController = new TextEditingController();
  TextEditingController locationEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Employee ",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
              "Form",
              style: TextStyle(
                color: const Color.fromARGB(255, 240, 2, 2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID san pham",
              style: TextStyle(
                color: const Color.fromARGB(255, 21, 17, 17),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: nameEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nhập id cua san pham",
                ),
              ),
            ),
            Text(
              "gia",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: ageEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nhập gia cua san pham",
                ),
              ),
            ),
            Text(
              "loai san pham",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: locationEditingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nhập loai san pham",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String Id = randomAlphaNumeric(10);
                Map<String, dynamic> employeeInfoMap = {
                  "IDSP": nameEditingController.text,
                  "Gia": ageEditingController.text,
                  "Id": Id,
                  "Loai": locationEditingController.text,
                };
                await DatabaseMethods()
                    .addEmployeeDetails(employeeInfoMap, Id)
                    .then((value) {
                      Fluttertoast.showToast(
                        msg: "Employee details added successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    });
              },
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
