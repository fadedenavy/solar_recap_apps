class HistoryModel {
  String nomor;
  String id;
  String tanggal;
  String nama_opt;
  String nama_dept;
  String total;

  HistoryModel(this.nomor, this.id, this.tanggal, this.nama_opt, this.nama_dept,
      this.total);

  HistoryModel.fromJson(Map<String, dynamic> json) {
    nomor = json['baris'];
    id = json['id_history'];
    tanggal = json['tanggal'];
    nama_opt = json['nama_opt'];
    nama_dept = json["nama_dept"];
    total = json['total'];
  }
}
