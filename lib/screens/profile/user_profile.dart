import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_app/screens/map/user-map.dart';
import 'package:work_app/screens/permission/user-permission.dart';
class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userName = "UserName";
  String userSurname = "UserSurname";
  String userPhone = "UserPhone";

  bool isObscurePassword = true;
  
  @override
  void initState() {
    super.initState();
    loadUserDetails(); 
  }

  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "UserName";
      userSurname = prefs.getString('user_surname') ?? "UserSurname";
      userPhone = prefs.getString('user_phone') ?? "UserPhone";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
         bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 6),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),  
          child: GNav(
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(20),
            gap: 5,
            selectedIndex: 2,
            onTabChange: (index) {
              switch (index) {
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
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/vector.jpg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                buildTextField("Name", userName, false),
                buildTextField("Surname", userSurname, false),
                buildTextField("Number", userPhone, false),
                SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {},
                //       child: Text(
                //         "Save",
                //         style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.black),
                //       ),
                //       style: ElevatedButton.styleFrom(
                //         padding: EdgeInsets.symmetric(horizontal: 50),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String labelText,
    String value,
    bool isPasswordTextField,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscurePassword = !isObscurePassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.black,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: value,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 65, 62, 62),
          ),
        ),
      ),
    );
  }
}

