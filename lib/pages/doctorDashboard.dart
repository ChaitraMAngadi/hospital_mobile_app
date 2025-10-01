import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/doctorController/activeInvisitsPage.dart';
import 'package:hospital_mobile_app/doctorController/todaysOutVisitsPage.dart';
import 'package:hospital_mobile_app/doctorController/patientsPage.dart';
import 'package:hospital_mobile_app/doctorController/profilePage.dart';


@RoutePage()
class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = 
  <Widget>[
    const PatientsPage(),
    const TodaysOutvisitsPage(),
    const ActiveInvisitsPage(),
    const ProfilePage(),
  ];
  // [
  //   const Center(child: Text("Doctor Patients")),
  //   const Center(child: Text("Doctor todays out visits")),
  //   const Center(child: Text("Doctor active in visits")),
  //   const Center(child: Text("Profile")),

  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:const Color(0xFF0857C0) ,
        centerTitle: true,
        title: const Text("Doctor Dashboard",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),)),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Patients',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description),
                  label: 'Todays OutPatients',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_pin_rounded),
                  label: 'Active InPatients',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              backgroundColor: const Color(0xFF0857C0),
              currentIndex: _selectedIndex,
              iconSize: 30,
              selectedLabelStyle: const TextStyle(fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontSize: 16),
              showUnselectedLabels: true,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              // unselectedItemColor: const Color(0xFF545454),
              // selectedItemColor: const Color(0xFF0857C0),
              onTap: (index) => setState(() => _selectedIndex = index),
            )
      
      // BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) => setState(() => _selectedIndex = index),
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.group), label: "Patients"),
      //     BottomNavigationBarItem(icon: Icon(Icons.description), label: "Todays Out Visits"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Active In Visits"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      //   backgroundColor: const Color(0xFF0857C0),
           
      //         iconSize: 30,
      //         selectedLabelStyle: const TextStyle(fontSize: 16),
      //         unselectedLabelStyle: const TextStyle(fontSize: 16),
      //         showUnselectedLabels: true,
      //         selectedItemColor: Colors.white,
      //         unselectedItemColor: Colors.white54,
      // ),
    );
  }
}
