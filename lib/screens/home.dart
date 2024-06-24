import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhirtpm/base_network.dart';
import 'package:tugasakhirtpm/model/skinmodel.dart';
import 'package:tugasakhirtpm/screens/profile.dart';
import 'package:tugasakhirtpm/screens/sarankesan.dart';
import 'package:tugasakhirtpm/screens/skindetail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Skin>> futureSkins;
  List<Skin>? skins;
  List<Skin>? filteredSkins;
  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String selectedTimeZone = 'WIB';

  late Timer timer;
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    futureSkins = BaseNetwork().fetchSkins();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      currentTime = DateTime.now();
    });
  }

  void _showTimeZonePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 225,
          child: Column(
            children: [
              ListTile(
                title: Text('WIB'),
                onTap: () {
                  setState(() {
                    selectedTimeZone = 'WIB';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('WITA'),
                onTap: () {
                  setState(() {
                    selectedTimeZone = 'WITA';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('WIT'),
                onTap: () {
                  setState(() {
                    selectedTimeZone = 'WIT';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('London'),
                onTap: () {
                  setState(() {
                    selectedTimeZone = 'London';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredSkins = null;
      });
    } else {
      setState(() {
        isSearching = true;
        filteredSkins = skins!
            .where((skin) =>
                skin.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  String _formatCurrentTime(String timeZone) {
    DateTime now = currentTime;
    switch (timeZone) {
      case 'WITA':
        now = now.add(Duration(hours: 1));
        break;
      case 'WIT':
        now = now.add(Duration(hours: 2));
        break;
      case 'London':
        now = now.subtract(Duration(hours: 6));
        break;
    }
    return DateFormat('HH:mm').format(now);
  }

  void _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSGO Skins',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 0),
          child: AppBar(
            title: !isSearching
                ? Text("CS:GO SKINS",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ))
                : TextField(
                    controller: _searchController,
                    onChanged: _performSearch,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search skins...",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
            centerTitle: true,
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              isSearching
                  ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        _stopSearch();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _startSearch();
                      },
                    ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Container(
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            FutureBuilder<List<Skin>>(
              future: futureSkins,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (snapshot.hasData) {
                  skins = snapshot.data;
                  if (skins != null && skins!.length > 30) {
                    skins = skins!.sublist(0, 30);
                  }
                  return ListView(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatCurrentTime(selectedTimeZone),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showTimeZonePicker(context);
                                  },
                                  child: Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              selectedTimeZone,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: isSearching
                            ? (filteredSkins?.length ?? 0)
                            : (skins?.length ?? 0),
                        itemBuilder: (context, index) {
                          final skin = isSearching
                              ? filteredSkins![index]
                              : skins![index];
                          return Card(
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                skin.name!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  skin.image ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SkinDetailPage(skin: skin),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      'No data found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SaranKesanPage()),
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
      ),
    );
  }
}
