import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nutritrackerapp/components/my_button.dart';
import 'package:nutritrackerapp/components/add_user_textfield.dart';
import 'package:nutritrackerapp/pages/user_info_or_user_home_page.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  // Controllers for the patient info
  final babyNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final genderController = TextEditingController();
  final weightController = TextEditingController();

  // Date controller
  final TextEditingController _dateController = TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // DOB selection function
  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  // Function for registering new user
  void newUserHome(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        var box = Hive.box('userBox');
        print('Saving data to Hive: ${babyNameController.text}, ${motherNameController.text}, ${_dateController.text}, ${genderController.text}, ${weightController.text}');
        await box.put('babyName', babyNameController.text);
        await box.put('motherName', motherNameController.text);
        await box.put('dob', _dateController.text);
        await box.put('gender', genderController.text);
        await box.put('weight', weightController.text);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserHomepage(),
          ),
        );
      } catch (e) {
        print('Error saving data to Hive: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF40E0D0),
              Color(0xFF1C1563),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Custom AppBar-like section
              Container(
                padding: const EdgeInsets.only(left: 10, top: 26, right: 185),
                height: 42 + 26, // Account for padding
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop(); // Navigate back to the previous page
                      },
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'User Info',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: -0.02,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 180),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    UserTextfield(
                      controller: babyNameController,
                      hintText: "Baby's Name",
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the baby's name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    UserTextfield(
                      controller: motherNameController,
                      hintText: "Mother's Name",
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the mother's name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          hintText: "D.O.B",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                        readOnly: true,
                        onTap: () {
                          selectDate();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select the date of birth";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    UserTextfield(
                      controller: genderController,
                      hintText: "Gender",
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the gender";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    UserTextfield(
                      controller: weightController,
                      hintText: "Weight (in grams)",
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the weight";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTap: () => newUserHome(context),
                      text: "Continue",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
