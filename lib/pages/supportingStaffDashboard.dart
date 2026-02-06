// ---------------- Supporting Staff Dashboard ----------------
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/supportingstaffController/supportingstaffPatientsPage.dart';
import 'package:hospital_mobile_app/supportingstaffController/supportingstaffProfilePage.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';


@RoutePage()
class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
   SupportingstaffPatientsPage(),
   SupportingStaffProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:Colors.white ,
        centerTitle: true,
        title: const Text("Supporting Staff Dashboard",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),)),
      body: _pages[_selectedIndex],
      bottomNavigationBar: 
      BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Patients',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              backgroundColor:  Colors.white,
              currentIndex: _selectedIndex,
              iconSize: 30,
              selectedLabelStyle: const TextStyle(fontSize: 16),
              unselectedLabelStyle: const TextStyle(fontSize: 16),
              showUnselectedLabels: true,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey.shade600,
              // unselectedItemColor: const Color(0xFF545454),
              // selectedItemColor: const Color(0xFF0857C0),
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
    );
  }
}
