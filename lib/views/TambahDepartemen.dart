import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solar_recap_app/model/api.dart';
import 'package:solar_recap_app/views/DataDepartemen.dart';

class TambahDepartemen extends StatefulWidget {
  final VoidCallback reload;
  TambahDepartemen(this.reload);
  @override
  _TambahDepartemenState createState() => _TambahDepartemenState();
}

class _TambahDepartemenState extends State<TambahDepartemen> {
  String namaDepartemen;
  final _key = new GlobalKey<FormState>();

  check() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      simpanDepartemen();
      widget.reload();
    }
  }

  simpanDepartemen() async {
    try {
      var uri = Uri.parse(BaseUrl.urlTambahDepartemen);
      var req = http.MultipartRequest("POST", uri);
      req.fields['nama_dept'] = namaDepartemen;
      var response = await req.send();
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
                                "Data Berhasil Ditambah",
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xff9aacb8),
        title: Text(
          "Tambah Departemen",
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
              validator: (e) {
                if (e.isEmpty) {
                  return "Silahkan isi Nama Departemen";
                }
              },
              onSaved: (e) => namaDepartemen = e,
              decoration: InputDecoration(
                  hintText: "Masukkan Nama Departemen",
                  hintStyle: TextStyle(color: Colors.grey),
                  labelText: "Nama Departemen",
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
                    widget.reload;
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
