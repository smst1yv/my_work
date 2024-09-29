import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:work_app/api/config.dart';
import 'dart:convert';

import 'package:work_app/screens/permission/user-permission.dart';
import 'package:work_app/screens/profile/user_profile.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  String userName = "UserName";
  String userSurname = "UserSurname";
  String userPhone = "UserPhone";
  String userEmail = "UserEmail";
  bool isWorkingButtonVisible = false;
  final LatLng officeLocation = LatLng(40.36878995923975, 49.82711960253402);
  String? selectedReason;
  bool isFormVisible = true; // Formun görünürlüğünü kontrol eder
  String successMessage = ''; // Başarı mesajı için

  @override
  void initState() {
    super.initState();
    loadUserDetails();
    _checkProximityToOffice();
    _checkTimePassed();
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "UserName";
      userSurname = prefs.getString('user_surname') ?? "UserSurname";
      userPhone = prefs.getString('user_phone') ?? "UserPhone";
      userEmail = prefs.getString('user_email') ?? "UserEmail";
    });
  }

  Future<void> _checkProximityToOffice() async {
    try {
      Position userPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        officeLocation.latitude,
        officeLocation.longitude,
      );
      setState(() {
        isWorkingButtonVisible = distanceInMeters <= 100;
      });
    } catch (e) {
      print('Konum alınamadı: $e');
    }
  }

  Future<void> sendReason(String reason, String email, String name) async {
  const String apiUrl = Config.apiUrl + 'save-permission-reason';

    try {
    var client = http.Client();
    var request = http.Request('POST', Uri.parse(apiUrl));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'user_email': email,
      'reason': reason,
      'user_name': name,
    });

    final response = await client.send(request);

    if (response.statusCode == 200) {
      print('Başarıyla kaydedildi');
      _saveSubmissionTime();
      setState(() {
        successMessage = 'Başarıyla gönderildi!';
        isFormVisible = false; 
      });
    } else {
      print('Hata: ${response.statusCode}');
    }
  } catch (e) {
    print('İstek sırasında hata oluştu: $e');
  }
}

  Future<void> _saveSubmissionTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('last_submission_time', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _checkTimePassed() async {
    final prefs = await SharedPreferences.getInstance();
    int? lastSubmissionTime = prefs.getInt('last_submission_time');
    if (lastSubmissionTime != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int elapsedTime = currentTime - lastSubmissionTime;

      // 12 saati ms cinsinden kontrol et (12 saat = 43200000 milisaniye)
      if (elapsedTime >= 43200000) {
        setState(() {
          isFormVisible = true; // 12 saat geçtiyse form tekrar aktif olsun
        });
      } else {
        setState(() {
          isFormVisible = false; // 12 saat geçmemişse form gizli
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 6),
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        child: GNav(
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.all(20),
          gap: 5,
          selectedIndex: 0,
          onTabChange: (index) {
            switch(index){
              case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                      builder: (context) => const UserLocation(),
                    ),
              );
              break;
              case 1:
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserPermission(),
                    ),
                  );
              break;
              case 2:
               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfile(),
                    ),
                  );
                  break;
              }
            },
          tabs: const [
            GButton(
              icon: Icons.location_city,
            ),
            GButton(
              icon: Icons.border_color,
            ),
            GButton(
              icon: Icons.person,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: officeLocation,
              zoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: officeLocation,
                    radius: 100,
                    useRadiusInMeter: true,
                    color: Colors.red.withOpacity(0.3),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: isWorkingButtonVisible
                  ? GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        width: 130,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "I Am Working",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
          if (!isWorkingButtonVisible && isFormVisible) // Form görünürlüğü kontrolü
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: DropdownButton<String>(
                        value: selectedReason,
                        hint: const Text("Neden Çalışamıyorsunuz?"),
                        items: <String>["Trafik Var", "Hastayım", "Lotuyam"]
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedReason = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (selectedReason != null) {
                          sendReason(selectedReason!, userEmail,userName);
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 130,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            "Gönder",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (successMessage.isNotEmpty) 
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  successMessage,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
