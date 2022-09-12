import 'package:flutter/material.dart';
import 'package:solar_recap_app/views/DataDepartemen.dart';
import 'package:solar_recap_app/views/DataOperator.dart';
import 'package:solar_recap_app/views/History.dart';
import 'package:solar_recap_app/views/Homepage.dart';

class DashboardAdmin extends StatefulWidget {
  final VoidCallback signOut;
  DashboardAdmin(this.signOut);
  @override
  _DashboardAdminState createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  signOut() {
    setState(() {
      widget.signOut();
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
                            "Berhasil Logout",
                            style: TextStyle(fontSize: 20.0),
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
  }

  dialogLogout() async {
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
                          "Apakah anda yakin ingin logout?",
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
                              signOut();
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
                        SizedBox(width: 5),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Color(0xff5aa897),
                            child: Text(
                              "Tidak",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          "Dashboard Admin",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff9aacb8),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                dialogLogout();
              },
              child: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(150.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: [
            Card(
              margin: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DataOperator(signOut)));
                },
                splashColor: Color(0xffb4b4b4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        size: 50,
                        color: Colors.black,
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Data Operator",
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new DataDepartemen()));
                },
                splashColor: Color(0xffb4b4b4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.work,
                        size: 50,
                        color: Colors.black,
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Data Departemen",
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => History()));
                },
                splashColor: Color(0xffb4b4b4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history,
                        size: 50,
                        color: Colors.black,
                      ),
                      SizedBox(height: 25),
                      Text(
                        "History",
                        style: TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
