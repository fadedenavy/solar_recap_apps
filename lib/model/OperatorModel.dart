class OperatorModel {
  String nomor;
  String id_opt;
  String idDept;
  String namaDept;
  String nikOpt;
  String namaOpt;

  OperatorModel(this.nomor, this.id_opt, this.idDept, this.namaDept,
      this.nikOpt, this.namaOpt);

  OperatorModel.fromJson(Map<String, dynamic> json) {
    nomor = json['nomor'];
    id_opt = json['id_opt'];
    idDept = json['id_dept'];
    namaDept = json['nama_dept'];
    nikOpt = json['nik_opt'];
    namaOpt = json['nama_opt'];
  }
}
