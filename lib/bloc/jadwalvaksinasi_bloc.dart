import 'dart:convert';
import 'package:jadwal_vaksinasi/helpers/api.dart';
import 'package:jadwal_vaksinasi/helpers/api_url.dart';
import 'package:jadwal_vaksinasi/model/jadwalvaksinasi.dart';

class JadwalVaksinasiBloc {
  // MENAMPILKAN LIST JADWAL
  static Future<List<JadwalVaksinasi>> getJadwalVaksinasi() async {
    try {
      String apiUrl = ApiUrl.listJadwalVaksinasi;
      var response = await Api().get(apiUrl);
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        List<dynamic> listJadwal = (jsonObj as Map<String, dynamic>)['data'];
        return listJadwal.map((jadwal) => JadwalVaksinasi.fromJson(jadwal)).toList();
      } else {
        throw Exception('Failed to load jadwal vaksinasi');
      }
    } catch (e) {
      print("Error in getJadwalVaksinasi: $e");
      return [];
    }
  }

  // MENAMBAHKAN JADWAL
  static Future<bool> addJadwalVaksinasi({required JadwalVaksinasi jadwal}) async {
    try {
      String apiUrl = ApiUrl.createJadwalVaksinasi;
      var body = {
        "person_name": jadwal.personName,
        "vaccine_type": jadwal.vaccineType,
        "age": jadwal.age.toString()
      };
      print("Sending request to $apiUrl with body: $body");
      var response = await Api().post(apiUrl, body);
      print("Received response with status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return true;
      } else {
        print("Failed to add jadwal vaksinasi. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error in addJadwalVaksinasi: $e");
      return false;
    }
  }

  // MENGUPDATE JADWAL
  static Future<bool> updateJadwalVaksinasi({required JadwalVaksinasi jadwal}) async {
    try {
      String apiUrl = ApiUrl.updateJadwalVaksinasi(jadwal.id);
      var body = {
        "person_name": jadwal.personName,
        "vaccine_type": jadwal.vaccineType,
        "age": jadwal.age.toString()
      };
      var response = await Api().put(apiUrl, jsonEncode(body));
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return jsonObj['success'] == true;
      } else {
        throw Exception('Failed to update jadwal vaksinasi');
      }
    } catch (e) {
      print("Error in updateJadwalVaksinasi: $e");
      return false;
    }
  }

  // MENGHAPUS JADWAL
  static Future<bool> deleteJadwalVaksinasi({required int id}) async {
    try {
      String apiUrl = ApiUrl.deleteJadwalVaksinasi(id);
      var response = await Api().delete(apiUrl);
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return jsonObj['success'] == true;
      } else {
        throw Exception('Failed to delete jadwal vaksinasi');
      }
    } catch (e) {
      print("Error in deleteJadwalVaksinasi: $e");
      return false;
    }
  }
}