import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solar_recap_app/model/HistoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:solar_recap_app/model/api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:solar_recap_app/views/DashboardAdmin.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List pdfList;
  final _key = new GlobalKey<FormState>();
  var loading = false;
  final list = new List<HistoryModel>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future fetchAllPdf() async {
    final response = await http.get(Uri.parse(BaseUrl.urlHistory));
    if (response.statusCode == 200) {
      setState(() {
        pdfList = jsonDecode(response.body);
        loading = false;
      });
      print(pdfList);
    }
  }

  simpanPDF() async {
    //class pdf
    final pdf = pw.Document();

    //font
    final font = await rootBundle.load("assets/OpenSans-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    //buat pages
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Text(
              "History Pencatatan Solar",
              style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 25),
          pw.Center(
            child: pw.Table(
                defaultColumnWidth: pw.FixedColumnWidth(50.0),
                border: pw.TableBorder.all(
                  style: pw.BorderStyle.solid,
                  width: 1,
                ),
                children: [
                  pw.TableRow(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text("No.",
                                  style: pw.TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: pw.FontWeight.bold))),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text("Operator",
                                  style: pw.TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: pw.FontWeight.bold))),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text("Departemen",
                                  style: pw.TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: pw.FontWeight.bold))),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text("Tanggal",
                                  style: pw.TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: pw.FontWeight.bold))),
                        ]),
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(5),
                              child: pw.Text("Total",
                                  style: pw.TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: pw.FontWeight.bold))),
                        ]),
                  ]),
                ]),
          ),
          pw.ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return pw.Table(
                    defaultColumnWidth: pw.FixedColumnWidth(50.0),
                    border: pw.TableBorder.all(
                      style: pw.BorderStyle.solid,
                      width: 1,
                    ),
                    children: [
                      pw.TableRow(children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text(x.nomor,
                                      style: pw.TextStyle(fontSize: 10.0))),
                            ]),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text(x.nama_opt,
                                      style: pw.TextStyle(fontSize: 10.0))),
                            ]),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text(x.nama_dept,
                                      style: pw.TextStyle(fontSize: 10.0))),
                            ]),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text(x.tanggal,
                                      style: pw.TextStyle(fontSize: 10.0))),
                            ]),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Text(x.total + " Liter",
                                      style: pw.TextStyle(fontSize: 10.0))),
                            ]),
                      ]),
                    ]);
              })
        ];
      },
    ));

    //simpan
    Uint8List bytes = await pdf.save();
    final now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd, H:m');
    String formattedDate = formatter.format(now);

    //buat file kosong
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Rekapitulasi Solar - ${formattedDate}.pdf');

    //timpa file pdf kosong
    await file.writeAsBytes(bytes);

    // open pdf
    await OpenFile.open(file.path);
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlHistory));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new HistoryModel(api['baris'], api['id_history'],
            api['tanggal'], api['nama_opt'], api['nama_dept'], api['total']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _deleteData(String id) async {
    print('${id}');
    final response = await http
        .post(Uri.parse(BaseUrl.urlDeleteHistory), body: {"id_history": id});
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
                              "Data Berhasil Dihapus",
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
                                    builder: (context) => new History()));
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
              _lihatData();
            });
      });
    } else {
      print(pesan);
    }
  }

  dialogDelete(String id) async {
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
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Apakah anda yakin ingin menghapus data ini?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              _deleteData(id);
                              print("nama");
                            },
                            color: Color(0xff5aa897),
                            child: Text(
                              "Ya",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Color(0xff31485f),
                            child: Text(
                              "Tidak",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.commit();
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
    fetchAllPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9aacb8),
        elevation: 0.0,
        title: Text(
          "History",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new DashboardAdmin(signOut)));
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: RaisedButton.icon(
              color: Color(0xff5aa897),
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: Text(
                "Clear All",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Column(
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              width: 100,
                              height: 100,
                              child: Center(
                                child: Text(
                                  x.nomor,
                                  style: TextStyle(fontSize: 75),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    x.tanggal,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    x.nama_opt ?? 'data tes',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  Text(
                                    x.nama_dept,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: 15,
                                bottom: 15,
                                left: 15,
                              ),
                              width: 100,
                              height: 100,
                              child: Text(
                                x.total + "Ltr.",
                                style: TextStyle(fontSize: 50.0),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                print(x.id);
                                dialogDelete(x.id);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => simpanPDF(),
          label: Text(
            "Print History",
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.print,
            color: Colors.white,
          ),
          backgroundColor: Color(0xff5aa897)),
    );
  }
}
