class DepartemenModel {
  String nomor;
  String idDept;
  String namaDept;

  DepartemenModel(this.nomor, this.idDept, this.namaDept);

  DepartemenModel.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    idDept = json['id_dept'];
    namaDept = json["nama_dept"];
  }
}
