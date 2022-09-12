class BaseUrl {
  static String url = "http://172.20.10.7/api_skripsi/";
  static String paths = "http://172.20.10.7/api_skripsi/upload/";

  //Departemen
  static String urlDataDepartemen = url + "api/data_departemen.php";
  static String urlEditDepartemen = url + "api/edit_departemen.php";
  static String urlDeleteDepartemen = url + "api/delete_departemen.php";
  static String urlTambahDepartemen = url + "api/tambah_departemen.php";

  //Operator
  static String urlDataOperator = url + "api/data_operator.php";
  static String urlEditOperator = url + "api/edit_operator.php";
  static String urlTambahOperator = url + "api/tambah_operator.php";
  static String urlDeleteOperator = url + "api/delete_operator.php";

  //Login
  static String urlLogin = url + "api/login.php";

  //history
  static String urlAddHistory = url + "api/add_history.php";
  static String urlHistory = url + "api/riwayat.php";
  static String urlDeleteAll = url + "api/delete_semua.php";
  static String urlDeleteHistory = url + "api/delete_history.php";
  static String urlTotalSolar = url + "api/total_solar.php";
}
