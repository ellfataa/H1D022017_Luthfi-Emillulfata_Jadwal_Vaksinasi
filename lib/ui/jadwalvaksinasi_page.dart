import 'package:flutter/material.dart';
import 'package:jadwal_vaksinasi/bloc/jadwalvaksinasi_bloc.dart';
import 'package:jadwal_vaksinasi/bloc/logout_bloc.dart';
import 'package:jadwal_vaksinasi/model/jadwalvaksinasi.dart';
import 'package:jadwal_vaksinasi/ui/jadwalvaksinasi_detail.dart';
import 'package:jadwal_vaksinasi/ui/jadwalvaksinasi_form.dart';
import 'package:jadwal_vaksinasi/ui/login_page.dart';

class JadwalVaksinasiPage extends StatefulWidget {
  const JadwalVaksinasiPage({Key? key}) : super(key: key);

  @override
  _JadwalVaksinasiPageState createState() => _JadwalVaksinasiPageState();
}

class _JadwalVaksinasiPageState extends State<JadwalVaksinasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6EACB),  // Changed background color to #F6EACB
      appBar: AppBar(
        title: const Text('Jadwal Vaksinasi'),
        backgroundColor: Color(0xFFD1E9F6),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0, color: Colors.white),
              onTap: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const JadwalVaksinasiForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFD1E9F6),  // Changed to match AppBar color
              ),
              child: Text(
                'Menu Vaksinasi',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false)
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<JadwalVaksinasi>>(
        future: JadwalVaksinasiBloc.getJadwalVaksinasi(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return snapshot.hasData
              ? ListJadwalVaksinasi(list: snapshot.data)
              : const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ListJadwalVaksinasi extends StatelessWidget {
  final List<JadwalVaksinasi>? list;
  const ListJadwalVaksinasi({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemJadwalVaksinasi(jadwal: list![i]);
      },
    );
  }
}

class ItemJadwalVaksinasi extends StatelessWidget {
  final JadwalVaksinasi jadwal;
  const ItemJadwalVaksinasi({Key? key, required this.jadwal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JadwalVaksinasiDetail(jadwal: jadwal),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFEECAD5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(Icons.calendar_today, size: 40, color: Color(0xFFF6EACB)),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jadwal.personName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    jadwal.vaccineType,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}