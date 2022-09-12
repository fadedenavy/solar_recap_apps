import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:solar_recap_app/model/DepartemenModel.dart';
import 'package:solar_recap_app/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:solar_recap_app/views/DataDepartemen.dart';

class EditDepartemen extends StatefulWidget {
  final VoidCallback reload;
  final DepartemenModel model;
  EditDepartemen(this.model, this.reload);
  @override
  _EditDepartemenState createState() => _EditDepartemenState();
}

class _EditDepartemenState extends State<EditDepartemen> {
  String IdDept, namaDept;

  TextEditingController txtIdDept, txtNamaDept;
  setup() async {
    txtNamaDept = TextEditingController(text: widget.model.namaDept);
    txtIdDept = TextEditingController(text: widget.model.idDept);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      updateData();
    }
  }

  updateData() async {
    final response = await http.post(Uri.parse(BaseUrl.urlEditDepartemen),
        body: {
          "nama_dept": namaDept,
          "id_dept": IdDept == null ? widget.model.idDept : IdDept
        });
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data["message"];

    if (value == 1) {
      setState(() {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  height: 150,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white70,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Data Berhasil Diubah",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new DataDepartemen()));
                          },
                          color: Color(0xff5aa897),
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
        widget.reload();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  final _key = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff9aacb8),
        centerTitle: true,
        title: Text(
          "Edit Departemen",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 250, horizontal: 100),
          children: [
            TextFormField(
              controller: txtNamaDept,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi data";
                }
              },
              onSaved: (e) => namaDept = e,
              decoration: InputDecoration(
                  hintText: "Masukkan Nama Departemen",
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: "Nama Departemen",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          check();
                        },
                        color: Color(0xff5aa897),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "Update Data",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Color(0xff31485f),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Container(
        //     child: Row(
        //   children: [
        //     TextButton(
        //       onPressed: () {},
        //       child: Text(
        //         "Update Data",
        //       ),
        //       style: TextButton.styleFrom(
        //           primary: Colors.black,
        //           textStyle: TextStyle(
        //             color: Colors.white,
        //             fontSize: 24,
        //           )),
        //     ),
        //     TextButton(
        //       onPressed: () {},
        //       child: Text("Batal"),
        //       style: TextButton.styleFrom(
        //           primary: Colors.black,
        //           textStyle: TextStyle(
        //             color: Colors.white,
        //             fontSize: 24,
        //           )),
        //     ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(8),
        //   child: Container(
        //     width: double.infinity,
        //     child: RaisedButton(
        //       onPressed: () {},
        //       color: Color(0xffebbb7e),
        //       child: Padding(
        //         padding: EdgeInsets.symmetric(vertical: 16.0),
        //         child: Text(
        //           "Update Data",
        //           style: TextStyle(
        //               color: Colors.black,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 16.0),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(8),
        //   child: Container(
        //     width: double.infinity,
        //     child: RaisedButton(
        //       onPressed: () {},
        //       color: Color(0xffebbb7e),
        //       child: Padding(
        //         padding: EdgeInsets.symmetric(vertical: 16.0),
        //         child: Text(
        //           "Update Data",
        //           style: TextStyle(
        //               color: Colors.black,
        //               fontWeight: FontWeight.bold,
        //               fontSize: 16.0),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
