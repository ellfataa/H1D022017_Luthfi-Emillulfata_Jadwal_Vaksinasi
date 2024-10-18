class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api';
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';

  // API ENDPOINT DARI JADWAL VAKSINASI
  static const String listJadwalVaksinasi = baseUrl + '/kesehatan/jadwal_vaksinasi';
  static const String createJadwalVaksinasi = baseUrl + '/kesehatan/jadwal_vaksinasi';
  static String updateJadwalVaksinasi(int id) {
    return baseUrl + '/kesehatan/jadwal_vaksinasi/' + id.toString() + '/update';
  }
  static String showJadwalVaksinasi(int id) {
    return baseUrl + '/kesehatan/jadwal_vaksinasi/' + id.toString();
  }
  static String deleteJadwalVaksinasi(int id) {
    return baseUrl + '/kesehatan/jadwal_vaksinasi/' + id.toString() + '/delete';
  }
}