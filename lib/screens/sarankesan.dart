import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhirtpm/screens/home.dart';
import 'package:tugasakhirtpm/screens/profile.dart'; // Import halaman Profile jika belum diimport

class SaranKesanPage extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    // Menghapus status login dari shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navigasi ke halaman login
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(kToolbarHeight + 0), // Tinggi AppBar + garis
        child: AppBar(
          title: Text("Saran dan Kesan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
              color: Colors.white), // Mengubah warna tombol back ke putih
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Container(
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: Colors.white, width: 1.0), // Garis di atas body
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 5,
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kesan',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Saya sangat senang karena dapat mempelajari dan mengimplementasikan berbagai konsep dan teknologi terbaru dalam mata kuliah Teknologi Pemrograman Mobile. Mampu membuat aplikasi mobile dari awal hingga akhir adalah pengalaman yang sangat memuaskan bagi saya. Proses belajar yang interaktif dan praktis memberikan pemahaman yang mendalam tentang pengembangan aplikasi mobile, serta memberikan wawasan baru tentang tren dan teknologi terkini dalam industri ini. Selain itu, kolaborasi dengan teman-teman sekelas dan mendapatkan pandangan dari sudut pandang yang berbeda telah memperkaya pengalaman saya dalam memahami konsep-konsep yang diajarkan dalam mata kuliah ini. Saya yakin pengetahuan dan keterampilan yang saya peroleh dari mata kuliah ini akan menjadi pondasi yang kuat dalam karier pengembangan aplikasi mobile saya di masa depan. ',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 5,
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesan',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Pesan saya untuk mata kuliah Teknologi Pemrograman Mobile adalah mengucapkan terima kasih kepada dosen pengampu dan semua pihak yang terlibat dalam penyelenggaraan mata kuliah ini.',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Warna teks tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 5,
                  ),
                  child: Text('Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor:
          Colors.black, // Mengatur background halaman menjadi hitam
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: 2, // Set index untuk halaman ini ke 2
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Saran Dan Kesan',
          ),
        ],
      ),
    );
  }
}
