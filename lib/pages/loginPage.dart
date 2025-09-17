import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/pages/adminDashboard.dart';
import 'package:hospital_mobile_app/pages/doctorDashboard.dart';
import 'package:hospital_mobile_app/pages/supportingStaffDashboard.dart';
import 'package:hospital_mobile_app/provider/loginProvider.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final List<String> roles = ['Doctor', 'Admin', 'Supporting Staff'];
  String? selectedRole;

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final loginformkey = GlobalKey<FormState>();

  void _login() {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role")),
      );
      return;
    }

    // Example: Navigate based on role
    if (selectedRole == "Doctor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DoctorDashboardPage()),
      );
    } else if (selectedRole == "Admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
      );
    } else if (selectedRole == "Supporting Staff") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StaffDashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Loginprovider loginprovider = context.read<Loginprovider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                side: BorderSide(
                    color: Colors.black26,
                    strokeAlign: BorderSide.strokeAlignOutside)),
            shadowColor: Colors.black,
            borderOnForeground: true,
            elevation: 20,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              child: Form(
                key: loginformkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login to Your Account",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "UserId",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: userIdController,
                      validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter UserId';
                                }
                                 if (value.contains(' ')) {
                    return 'Spaces are not allowed';
                  }
                  const useridRegex = r'^\d{10}_\d{3}$';

                              
                                if (!RegExp(useridRegex).hasMatch(value!)) {
                                  return 'Enter a valid userId';
                                }
                                return null; 
                              },
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 16, top: 14, bottom: 14),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        hintText: 'Enter UserId',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff333333).withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                 if (value.contains(' ')) {
                    return 'Spaces are not allowed';
                  }
                                return null; 
                              },
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 16, top: 14, bottom: 14),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff333333).withOpacity(0.5)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Role",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select the role';
                                }

                                return null; 
                              },
                      hint: const Text('Select your role'),
                      value: selectedRole,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue;
                        });
                      },
                      items: roles.map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed:()async {
  if (loginformkey.currentState!.validate()) {
    
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      bool isLogged = false;

      if (selectedRole == "Doctor") {
        isLogged = await loginprovider.doctorloginphone(userIdController.text, passwordController.text, context);
      } else if (selectedRole == "Admin") {
        isLogged = await loginprovider.adminloginphone(userIdController.text, passwordController.text, context);
      } else if (selectedRole == "Supporting Staff") {
        isLogged = await loginprovider.supportingstaffloginphone(userIdController.text, passwordController.text, context);
      }

      Navigator.of(context).pop(); // close loading

if (isLogged) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (selectedRole == "Doctor") {
      context.router.replaceAll([const DoctorDashboardRoute()]);
    } else if (selectedRole == "Admin") {
      context.router.replaceAll([const AdminDashboardRoute()]);
    } else {
      context.router.replaceAll([const StaffDashboardRoute()]);
    }
  });
}
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $e")));
    }

    // try {

    //   bool isLogged = await loginprovider.doctorloginphone(userIdController.text, passwordController.text, context);

    //     // Close loading dialog
    //     // if (Navigator.of(context).canPop()) {
    //     //   Navigator.of(context).pop();
    //     // }
    //     if (isLogged) {
    //       if (selectedRole == "Doctor") {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const DoctorDashboard()),
    //   );
    // } else if (selectedRole == "Admin") {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const AdminDashboard()),
    //   );
    // } else if (selectedRole == "Supporting Staff") {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const StaffDashboard()),
    //   );
    // }
    //       // Force rebuild of HomePage to pick up new token
    //       // Use pushAndPopUntil to clear the navigation stack
    //       // context.router.pushAndPopUntil(
    //       //   HomeRoute(),
    //       //   predicate: (_) => false,
    //       // );
    //     }


    //   // if (inputText == "8217309343") {
    //   //   bool isLogged = await authprovider.loginphone(inputText, context);

    //   //   // Close loading dialog
    //   //   if (Navigator.of(context).canPop()) {
    //   //     Navigator.of(context).pop();
    //   //   }
    //   //   if (isLogged) {
    //   //     // Force rebuild of HomePage to pick up new token
    //   //     // Use pushAndPopUntil to clear the navigation stack
    //   //     context.router.pushAndPopUntil(
    //   //       HomeRoute(),
    //   //       predicate: (_) => false,
    //   //     );
    //   //   }
    //   // } else {
    //   //   isotpsent = await authprovider.loginwithphone(inputText, context);

    //   //   // Close loading dialog
    //   //   if (Navigator.of(context).canPop()) {
    //   //     Navigator.of(context).pop();
    //   //   }

    //   //   if (isotpsent) {
    //   //     context.router.replaceAll([OtpVerificationRoute()]);
    //   //   }
    //   // }
    // } catch (e) {
    //   // Close loading dialog in case of error
    //   if (Navigator.of(context).canPop()) {
    //     Navigator.of(context).pop();
    //   }
      
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Login failed: ${e.toString()}')),
    //   );
    // }
  }
},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0857C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 36, vertical: 14),
                          ),
                          child: Text("Continue",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
