import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tugasakhirtpm/model/skinmodel.dart';
import 'package:intl/intl.dart';

class SkinDetailPage extends StatefulWidget {
  final Skin skin;

  SkinDetailPage({required this.skin});

  @override
  State<SkinDetailPage> createState() => _SkinDetailPageState();
}

class _SkinDetailPageState extends State<SkinDetailPage> {
  var priceInIDR;
  var priceInEuro;
  var priceInDollar;
  var priceInYen;

  var selectedCurrency = 'IDR';

  void checkRarity() {
    setState(() {
      if (widget.skin.rarity?.id == 'rarity_uncommon_weapon') {
        priceInIDR = 15000;
      } else if (widget.skin.rarity?.id == 'rarity_ancient_weapon') {
        priceInIDR = 100000;
      } else if (widget.skin.rarity?.id == 'rarity_rare_weapon') {
        priceInIDR = 250000;
      } else if (widget.skin.rarity?.id == 'rarity_legendary_weapon') {
        priceInIDR = 500000;
      } else if (widget.skin.rarity?.id == 'rarity_mythical_weapon') {
        priceInIDR = 750000;
      }
    });
  }

  String _convertCurrency(int price) {
    double rate = 1.0;
    if (selectedCurrency == 'USD') {
      rate = 0.000062;
    } else if (selectedCurrency == 'EUR') {
      rate = 0.00006;
    } else if (selectedCurrency == 'YEN') {
      rate = 0.0097;
    }
    double convertedPrice = price * rate;
    final formatCurrency =
        NumberFormat.currency(symbol: "", decimalDigits: 0, locale: 'id_ID');
    return formatCurrency.format(convertedPrice);
  }

  @override
  void initState() {
    super.initState();
    checkRarity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.skin.name ?? 'Skin Detail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, // Warna tombol kembali
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Tinggi garis
          child: Container(
            color: Colors.white, // Warna garis
            height: 1.0,
          ),
        ),
        actions: [
          DropdownButton<String>(
            dropdownColor: Colors.black, // Warna latar belakang dropdown
            value: selectedCurrency,
            onChanged: (newValue) {
              setState(() {
                selectedCurrency = newValue!;
              });
            },
            items: <String>['IDR', 'EUR', 'USD', 'YEN']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white), // Warna teks dropdown
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60), // Tambahkan spasi di bawah AppBar
            if (widget.skin.image != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Mengubah posisi bayangan
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.skin.image!,
                    height: 200, // Atur tinggi gambar sesuai kebutuhan
                    width: double.infinity, // Lebar gambar memenuhi layar
                    fit: BoxFit.cover, // Atur tata letak gambar
                  ),
                ),
              ),
            SizedBox(height: 30), // Spasi antara gambar dan informasi
            Card(
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
                      'Skin Type: ${widget.skin.rarity?.id ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Html(
                      data: widget.skin.description,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: ${_convertCurrency(priceInIDR)} ${selectedCurrency}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna latar belakang tombol
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
