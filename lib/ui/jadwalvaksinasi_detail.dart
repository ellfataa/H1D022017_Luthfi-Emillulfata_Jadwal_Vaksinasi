import 'package:flutter/material.dart';
import 'package:jadwal_vaksinasi/bloc/jadwalvaksinasi_bloc.dart';
import 'package:jadwal_vaksinasi/model/jadwalvaksinasi.dart';
import 'package:jadwal_vaksinasi/ui/jadwalvaksinasi_form.dart';
import 'package:jadwal_vaksinasi/ui/jadwalvaksinasi_page.dart';
import 'package:jadwal_vaksinasi/widget/warning_dialog.dart';

class JadwalVaksinasiDetail extends StatefulWidget {
  final JadwalVaksinasi jadwal;

  const JadwalVaksinasiDetail({Key? key, required this.jadwal}) : super(key: key);

  @override
  _JadwalVaksinasiDetailState createState() => _JadwalVaksinasiDetailState();
}

class _JadwalVaksinasiDetailState extends State<JadwalVaksinasiDetail> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6EACB),
      appBar: AppBar(
        title: const Text('Detail Jadwal Vaksinasi', style: TextStyle(color: Colors.black87)),
        backgroundColor: Color(0xFFD1E9F6),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jadwal.personName,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.medical_services, "Jenis Vaksin", widget.jadwal.vaccineType),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.cake, "Umur", "${widget.jadwal.age} tahun"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16.0, color: Colors.black87),
              children: [
                TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text("EDIT", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JadwalVaksinasiForm(jadwal: widget.jadwal),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: _isLoading ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            ) : const Icon(Icons.delete, color: Colors.white),
            label: _isLoading ? const Text("") : const Text("DELETE", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isLoading ? null : confirmHapus,
          ),
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus jadwal ini?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              _deleteJadwal();
            },
          ),
        ],
      ),
    );
  }

  void _deleteJadwal() {
    setState(() {
      _isLoading = true;
    });
    JadwalVaksinasiBloc.deleteJadwalVaksinasi(id: widget.jadwal.id!).then(
          (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const JadwalVaksinasiPage(),
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Hapus gagal, silahkan coba lagi",
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}