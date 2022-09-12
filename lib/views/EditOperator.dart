// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_recap_app/model/DepartemenModel.dart';
import 'package:solar_recap_app/model/OperatorModel.dart';
import 'package:solar_recap_app/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:solar_recap_app/views/DataOperator.dart';
import 'package:solar_recap_app/views/DataOperator.dart';

class EditOperator extends StatefulWidget {
  final VoidCallback reload;
  final OperatorModel model;
  EditOperator(this.model, this.reload);
  @override
  _EditOperatorState createState() => _EditOperatorState();
}

class _EditOperatorState extends State<EditOperator> {
  String departemenID, namaOperator, nikOperator, operatorID;
  TextEditingController txtidOpt, txtidDept, txtnikOpt, txtNamaOpt;
  setup() async {
    txtidDept = TextEditingController(text: widget.model.idDept);
    txtnikOpt = TextEditingController(text: widget.model.nikOpt);
    txtNamaOpt = TextEditingController(text: widget.model.namaOpt);
    txtidOpt = TextEditingController(text: widget.model.id_opt);
  }

  DepartemenModel _currentDepartemen;

  List currentDepartemen;
  final listDepartemen = new List<DepartemenModel>();
  final String linkDepartemen = BaseUrl.urlDataDepartemen;

  Future<List<DepartemenModel>> _fetchDepartemen() async {
    var response = await http.get(Uri.parse(linkDepartemen));

    if (response.statusCode == 200) {
      final items = jsonDecode(response.body).cast<Map<String, dynamic>>();
      List<DepartemenModel> listOfDepartemen =
          items.map<DepartemenModel>((json) {
        return DepartemenModel.fromJson(json);
      }).toList();
      currentDepartemen = items;

      return listOfDepartemen;
    } else {
      throw Exception("Failed to load");
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      prosesData();
    }
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.commit();
    });
  }

  prosesData() async {
    final response = await http.post(Uri.parse(BaseUrl.urlEditOperator), body: {
      "nik_opt": nikOperator,
      "nama_opt": namaOperator,
      "id_dept": departemenID == null ? widget.model.idDept : departemenID,
      "id_opt": widget.model.id_opt
    });
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

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
                                        new DataOperator(signOut)));
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

  String body(http.Response response) => response.body;

  // updateData() async {
  //   final response = await http.post(Uri.parse(BaseUrl.urlEditOperator), body: {
  //     "id_dept": idDept,
  //     "nik_opt": nikOpt,
  //     "nama_opt": namaOpt,
  //     "id_opt": id_opt == null ? widget.model.id_opt : id_opt
  //   });
  //   final data = jsonDecode(response.body);
  //   int value = data['success'];
  //   String pesan = data['message'];

  //   if (value == 10) {
  //     setState(() {
  //       print(pesan);
  //       widget.reload;
  //       Navigator.pop(context);
  //     });
  //   } else {
  //     print(pesan);
  //   }
  // }

  convertDept(List listDepartemen, String idDept) {
    print(nikOperator);
    for (var item in listDepartemen) {
      if (item['id_dept'] == idDept) {
        print(item['nama_dept']);
        return item['nama_dept'];
      }
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
        elevation: 0.0,
        backgroundColor: Color(0xff9aacb8),
        automaticallyImplyLeading: false,
        title: Text(
          "Edit Operator",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 100),
          children: [
            FutureBuilder<List<DepartemenModel>>(
                future: _fetchDepartemen(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DepartemenModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButton<DepartemenModel>(
                      items: snapshot.data
                          .map((listDepartemen) =>
                              DropdownMenuItem<DepartemenModel>(
                                  child: Text(listDepartemen.namaDept),
                                  value: listDepartemen))
                          .toList(),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      isExpanded: true,
                      underline: SizedBox(),
                      onChanged: (DepartemenModel value) {
                        setState(() {
                          _currentDepartemen = value;
                          departemenID = _currentDepartemen.idDept;
                        });
                      },
                      hint: Text(departemenID == null ||
                              departemenID == widget.model.idDept
                          ? (convertDept(
                              currentDepartemen, widget.model.idDept))
                          : _currentDepartemen.namaDept),
                    ),
                  );
                }),
            // // DropdownSearch<String>(
            // //   mode: Mode.MENU,
            // //   showSelectedItem: true,
            // //   items: [],
            // //   label: "Pilih Departemen",
            // //   hint: "Harap Pilih Departemen",
            // //   onChanged: print,
            // //   selectedItem: "Harap Pilih Departemen",
            // ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: txtnikOpt,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi nik operator";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nikOperator = e,
              decoration: InputDecoration(
                  labelText: "Nomor Induk Operator",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: txtNamaOpt,
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi nama operator";
                } else {
                  return null;
                }
              },
              onSaved: (e) => namaOperator = e,
              decoration: InputDecoration(
                  labelText: "Nama Operator",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
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
            )
          ],
        ),
      ),
    );
  }
}
