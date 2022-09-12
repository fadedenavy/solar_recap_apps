import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_recap_app/model/DepartemenModel.dart';
import 'package:http/http.dart' as http;
import 'package:solar_recap_app/model/api.dart';
import 'package:solar_recap_app/model/OperatorModel.dart';
import 'package:intl/intl.dart';
import 'package:solar_recap_app/views/DataOperator.dart';

class TambahOperator extends StatefulWidget {
  final VoidCallback reload;
  TambahOperator(this.reload);
  @override
  _TambahOperatorState createState() => _TambahOperatorState();
}

class _TambahOperatorState extends State<TambahOperator> {
  String nikOpt, idOpt, namaOpt, DepartemenID;
  final _key = new GlobalKey<FormState>();

  //dropdown list
  DepartemenModel _currentDepartemen;
  final String linkDepartemen = BaseUrl.urlDataDepartemen;

  Future<List<DepartemenModel>> _fetchDepartemen() async {
    var response = await http.get(Uri.parse(linkDepartemen));

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<DepartemenModel> listOfDepartemen =
          items.map<DepartemenModel>((json) {
        return DepartemenModel.fromJson(json);
      }).toList();

      return listOfDepartemen;
    } else {
      throw Exception("Failed to load");
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      widget.reload;
      form.save();
      simpanoperator();
    }
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.commit();
    });
  }

  simpanoperator() async {
    try {
      var uri = Uri.parse(BaseUrl.urlTambahOperator);
      var request = http.MultipartRequest("POST", uri);
      // request.fields['id_opt'] = idOpt;
      request.fields['id_dept'] = DepartemenID;
      request.fields['nik_opt'] = nikOpt;
      request.fields['nama_opt'] = namaOpt;

      var response = await request.send();
      if (this.mounted) {
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
        });
      }
    } catch (e) {
      debugPrint(e);
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
        backgroundColor: Color(0xff9aacb8),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Tambah Operator",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 250, horizontal: 100),
          children: [
            FutureBuilder<List<DepartemenModel>>(
              future: _fetchDepartemen(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DepartemenModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<DepartemenModel>(
                    items: snapshot.data
                        .map((listDepartemen) =>
                            DropdownMenuItem<DepartemenModel>(
                              child: Text(listDepartemen.namaDept),
                              value: listDepartemen,
                            ))
                        .toList(),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 42,
                    underline: SizedBox(),
                    onChanged: (DepartemenModel value) {
                      setState(() {
                        _currentDepartemen = value;
                        DepartemenID = _currentDepartemen.idDept;
                      });
                    },
                    isExpanded: true,
                    hint: Text(DepartemenID == null
                        ? " Pilih Departemen "
                        : _currentDepartemen.namaDept),
                  ),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan Masukkan NIK Operator";
                }
              },
              onSaved: (e) => nikOpt = e,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                labelText: "Nomor Induk Operator",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Masukkan nama Operator";
                }
              },
              onSaved: (e) => namaOpt = e,
              decoration: InputDecoration(
                  labelText: "Nama Operator",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
            ),
            SizedBox(
              height: 15,
            ),
            ClipRRect(
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
                      "Tambah Data",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
