import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/employee.dart';
import 'package:flutter_application_1/service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController ageEditingController = new TextEditingController();
  TextEditingController locationEditingController = new TextEditingController();

  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    if (mounted) {
      setState(() {});
    }
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
        return snapshot.hasData
            ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "IDSP: " + ds["IDSP"],
                                style: TextStyle(color: Colors.white),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  nameEditingController.text = ds["IDSP"];
                                  ageEditingController.text = ds["Gia"];
                                  locationEditingController.text = ds["Loai"];
                                  EditEmployeeDetails(ds['Id']);
                                },
                                child: Icon(Icons.edit, color: Colors.orange),
                              ),
                              SizedBox(width: 5.0),
                              GestureDetector(
                                onTap: () async {
                                  await DatabaseMethods().deleteEmployee(
                                    ds["Id"],
                                  );
                                },
                                child: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                          Text(
                            "Gia: " + ds["Gia"],
                            style: TextStyle(color: Colors.cyan),
                          ),
                          Text(
                            "Loai: " + ds["Loai"],
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
            : Container();
      },
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Futter ",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
              "CRUD ",
              style: TextStyle(
                color: const Color.fromARGB(255, 240, 2, 2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(children: [Expanded(child: allEmployeeDetails())]),
      ),
    );
  }

  Future EditEmployeeDetails(String id) => showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel),
                    ),
                    SizedBox(width: 60.0),
                    Text(
                      "edit",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "details",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 240, 2, 2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  "IDSP",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 19, 19),
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
                      hintText: "Nhập tên của bạn",
                    ),
                  ),
                ),
                Text(
                  "Gia",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 19, 19),
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
                      hintText: "Nhập tuổi của bạn",
                    ),
                  ),
                ),
                Text(
                  "Loai",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 19, 19),
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
                      hintText: "Nhập địa chỉ của bạn",
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> updateInfo = {
                        "IDSP": nameEditingController.text,
                        "Gia": ageEditingController.text,
                        "Id": id,
                        "Loai": locationEditingController.text,
                      };
                      await DatabaseMethods()
                          .updateEmployeeDetails(id, updateInfo)
                          .then((value) {
                            Navigator.pop(context);
                            getontheload();
                          });
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
