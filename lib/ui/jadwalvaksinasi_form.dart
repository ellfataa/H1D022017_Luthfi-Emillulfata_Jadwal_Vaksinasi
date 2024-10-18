import 'package:flutter/material.dart';
import 'package:jadwal_vaksinasi/bloc/jadwalvaksinasi_bloc.dart';
import 'package:jadwal_vaksinasi/model/jadwalvaksinasi.dart';
import 'package:jadwal_vaksinasi/ui/jadwalvaksinasi_page.dart';
import 'package:jadwal_vaksinasi/widget/warning_dialog.dart';

class JadwalVaksinasiForm extends StatefulWidget {
  final JadwalVaksinasi? jadwal;

  const JadwalVaksinasiForm({Key? key, this.jadwal}) : super(key: key);

  @override
  _JadwalVaksinasiFormState createState() => _JadwalVaksinasiFormState();
}

class _JadwalVaksinasiFormState extends State<JadwalVaksinasiForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "Tambah Jadwal Vaksinasi";
  String tombolSubmit = "Simpan";
  final _personNameTextboxController = TextEditingController();
  final _vaccineTypeTextboxController = TextEditingController();
  final _ageTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.jadwal != null) {
      setState(() {
        judul = "Ubah Jadwal Vaksinasi";
        tombolSubmit = "Ubah";
        _personNameTextboxController.text = widget.jadwal!.personName;
        _vaccineTypeTextboxController.text = widget.jadwal!.vaccineType;
        _ageTextboxController.text = widget.jadwal!.age.toString();
      });
    } else {
      judul = "Tambah Jadwal Vaksinasi";
      tombolSubmit = "Simpan";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EACB),
      appBar: AppBar(
        title: Text(judul, style: const TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFD1E9F6),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildTextField("Nama", _personNameTextboxController, TextInputType.text),
                const SizedBox(height: 20),
                _buildTextField("Jenis Vaksin", _vaccineTypeTextboxController, TextInputType.text),
                const SizedBox(height: 20),
                _buildTextField("Umur", _ageTextboxController, TextInputType.number),
                const SizedBox(height: 40),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          keyboardType: keyboardType,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label harus diisi";
            }
            if (label == "Umur" && int.tryParse(value) == null) {
              return "Umur harus berupa angka";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buttonSubmit() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Color(0xFFD1E9F6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Text(tombolSubmit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        onPressed: () {
          if (_formKey.currentState!.validate() && !_isLoading) {
            widget.jadwal != null ? ubah() : simpan();
          }
        },
      ),
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    JadwalVaksinasi createJadwal = JadwalVaksinasi(
      id: 0,
      personName: _personNameTextboxController.text,
      vaccineType: _vaccineTypeTextboxController.text,
      age: int.parse(_ageTextboxController.text),
    );

    JadwalVaksinasiBloc.addJadwalVaksinasi(jadwal: createJadwal).then((success) {
      setState(() {
        _isLoading = false;
      });
      if (success) {
        _showSuccessDialog("Data berhasil disimpan");
      } else {
        _showErrorDialog("Simpan gagal, silahkan coba lagi");
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Terjadi kesalahan: ${error.toString()}");
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });
    JadwalVaksinasi updateJadwal = JadwalVaksinasi(
      id: widget.jadwal!.id,
      personName: _personNameTextboxController.text,
      vaccineType: _vaccineTypeTextboxController.text,
      age: int.parse(_ageTextboxController.text),
    );

    JadwalVaksinasiBloc.updateJadwalVaksinasi(jadwal: updateJadwal).then((success) {
      if (success) {
        _showSuccessDialog("Data berhasil diubah");
      } else {
        _showErrorDialog("Permintaan ubah data gagal, silahkan coba lagi");
      }
    }).catchError((error) {
      _showErrorDialog("Terjadi kesalahan: ${error.toString()}");
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sukses'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const JadwalVaksinasiPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => WarningDialog(
        description: message,
      ),
    );
  }
}