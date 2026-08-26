import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/adminController/adminActiveInvisitPage.dart';
import 'package:hospital_mobile_app/adminController/adminProfilePage.dart';
import 'package:hospital_mobile_app/adminController/allPatientsPage.dart';
import 'package:hospital_mobile_app/adminController/doctorDetailsPage.dart';
import 'package:hospital_mobile_app/provider/adminProvider.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:provider/provider.dart';


@RoutePage()
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
     AllPatientsPage(),
     DoctorDetailsPage(),
    ActiveAdminInvisitsPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    Adminprovider adminprovider = context.watch<Adminprovider>();
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white ,
        centerTitle: true,
        elevation: 3,
        title: const Text("Admin Dashboard",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),)),
      // body: _pages[_selectedIndex],
      body:  Column(
          children: [
            if (adminprovider.shouldShowExpiryBanner())
              const ExpiryAlertBanner(),
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      bottomNavigationBar: 
      BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Patients',
                ),
                 BottomNavigationBarItem(
              icon: Icon(Icons.person_pin_rounded),
              label: 'Doctors',
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



class ExpiryAlertBanner extends StatelessWidget {
  const ExpiryAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Adminprovider>();
    final daysLeft = provider.remainingDays();

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD2691E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Validity Warning",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  daysLeft > 0
                      ? "Your account validity is expiring in $daysLeft days. "
                          "Please complete the payment on the payments page to "
                          "continue using your account without any disruption."
                      : "Your account will expire today. Please complete the "
                          "payment to reactivate.",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: point this to the admin app's payment route
                      // context.router.push(AdminPaymentRoute());
                    },
                    child: const Text(
                      "Click here to pay now",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => provider.closeExpiryBanner(),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}