import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:solar_recap_app/model/DepartemenModel.dart';
import 'package:http/http.dart' as http;
import 'package:solar_recap_app/model/OperatorModel.dart';
import 'package:solar_recap_app/model/api.dart';
import 'package:solar_recap_app/views/DataDepartemen.dart';
import 'dart:convert';

import 'package:solar_recap_app/views/LoginPage.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String DepartemenID, OperatorID, totalSolar;
  DepartemenModel _currentDepartemen;
  OperatorModel _currentOperator;
  final String linkDepartemen = BaseUrl.urlDataDepartemen;
  final String linkOperator = BaseUrl.urlDataOperator;
  final _key = new GlobalKey<FormState>();

  Future<List<DepartemenModel>> _fetchDepartemen() async {
    var response = await http.get(Uri.parse(linkDepartemen));

    if (response.statusCode == 200) {
      final items = jsonDecode(response.body).cast<Map<String, dynamic>>();
      List<DepartemenModel> listOfDepartemen =
          items.map<DepartemenModel>((json) {
        return DepartemenModel.fromJson(json);
      }).toList();

      return listOfDepartemen;
    } else {
      throw Exception("Failed to load");
    }
  }

  Future<List<OperatorModel>> _fetchOperator() async {
    var response = await http.get(Uri.parse(linkOperator));

    if (response.statusCode == 200) {
      final items = jsonDecode(response.body).cast<Map<String, dynamic>>();
      List<OperatorModel> listOfOperator = items.map<OperatorModel>((json) {
        return OperatorModel.fromJson(json);
      }).toList();

      return listOfOperator;
    } else {
      throw Exception("Failed to load");
    }
  }

  // String pilihTanggal, labelText;
  // DateTime tgl = new DateTime.now();
  // final TextStyle valueStyle = TextStyle(fontSize: 16);
  // Future<Null> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: tgl,
  //       firstDate: DateTime(1999),
  //       lastDate: DateTime(2999));

  //   if (picked != null && picked != tgl) {
  //     setState(() {
  //       tgl = picked;
  //       pilihTanggal = new DateFormat.yMd().format(tgl);
  //     });
  //   } else {}
  // }

  simpanHistory() async {
    final DateTime tanggal = new DateTime.now();
    try {
      var uri = Uri.parse(BaseUrl.urlAddHistory);
      var request = http.MultipartRequest("POST", uri);
      request.fields['tanggal'] = "$tanggal";
      request.fields['id_opt'] = OperatorID;
      request.fields['id_dept'] = DepartemenID;
      request.fields['total'] = totalSolar;

      var response = await request.send();
      print("Success");
      if (this.mounted) ;
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
                              "Data Berhasil Disimpan",
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
                                    builder: (context) => new Homepage()));
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
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      simpanHistory();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Color(0xff9aacb8),
        title: Image.asset(
          "assets/img/clariant_logo.png",
          width: 175,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton.icon(
              color: Color(0xff5aa897),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new LoginPage()));
              },
              icon: Icon(
                Icons.supervised_user_circle_sharp,
                color: Colors.white,
              ),
              label: Text(
                "Login Admin",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 100),
          children: [
            Center(
              child: Text(
                "Input Penggunaan Solar",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            FutureBuilder<List<DepartemenModel>>(
                future: _fetchDepartemen(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<DepartemenModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
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
                          DepartemenID = _currentDepartemen.idDept;
                        });
                      },
                      hint: Text(DepartemenID == null
                          ? "Pilih Departemen"
                          : _currentDepartemen.namaDept),
                    ),
                  );
                }),
            SizedBox(
              height: 15,
            ),
            FutureBuilder<List<OperatorModel>>(
                future: _fetchOperator(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<OperatorModel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButton<OperatorModel>(
                      items: snapshot.data
                          .map((listOperator) =>
                              DropdownMenuItem<OperatorModel>(
                                  child: Text(listOperator.namaOpt),
                                  value: listOperator))
                          .toList(),
                      icon: Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      iconSize: 42,
                      underline: SizedBox(),
                      onChanged: (OperatorModel value) {
                        setState(() {
                          _currentOperator = value;
                          OperatorID = _currentOperator.id_opt;
                        });
                      },
                      hint: Text(OperatorID == null
                          ? "Pilih Operator"
                          : _currentOperator.namaOpt),
                    ),
                  );
                }),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi penggunaan solar";
                }
                ;
              },
              onSaved: (e) => totalSolar = e,
              decoration: InputDecoration(
                  hintText: "Masukkan Total Solar",
                  hintStyle: TextStyle(color: Colors.grey),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onPressed: () {
                check();
              },
              color: Color(0xff5aa897),
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
