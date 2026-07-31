import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_model.dart';
import 'profile_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  final ProfileService _profileService = ProfileService();

  bool isLoading = false;

  String gender = "Male";
  String goal = "Lose Weight";
  String activityLevel = "Moderately Active";

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final profile = UserProfile(
        uid: user.uid,
        name: nameController.text.trim(),
        email: user.email ?? "",
        age: int.parse(ageController.text.trim()),
        gender: gender,
        height: double.parse(heightController.text.trim()),
        weight: double.parse(weightController.text.trim()),
        goal: goal,
        activityLevel: activityLevel,
      );

      await _profileService.saveProfile(profile);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Saved Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // TODO:
      // Replace this with DashboardScreen later.
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const Icon(
                  Icons.account_circle,
                  size: 110,
                  color: Colors.green,
                ),

                const SizedBox(height: 25),

                buildTextField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person,
                  keyboardType: TextInputType.name,
                ),

                buildTextField(
                  controller: ageController,
                  label: "Age",
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                ),

                buildTextField(
                  controller: heightController,
                  label: "Height (cm)",
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                ),

                buildTextField(
                  controller: weightController,
                  label: "Weight (kg)",
                  icon: Icons.monitor_weight,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Male",
                      child: Text("Male"),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Text("Female"),
                    ),
                    DropdownMenuItem(
                      value: "Other",
                      child: Text("Other"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),

                const SizedBox(height: 18),

                DropdownButtonFormField<String>(
                  value: goal,
                  decoration: const InputDecoration(
                    labelText: "Fitness Goal",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Lose Weight",
                      child: Text("Lose Weight"),
                    ),
                    DropdownMenuItem(
                      value: "Gain Muscle",
                      child: Text("Gain Muscle"),
                    ),
                    DropdownMenuItem(
                      value: "Maintain Weight",
                      child: Text("Maintain Weight"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      goal = value!;
                    });
                  },
                ),

                const SizedBox(height: 18),

                DropdownButtonFormField<String>(
                  value: activityLevel,
                  decoration: const InputDecoration(
                    labelText: "Activity Level",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Sedentary",
                      child: Text("Sedentary"),
                    ),
                    DropdownMenuItem(
                      value: "Lightly Active",
                      child: Text("Lightly Active"),
                    ),
                    DropdownMenuItem(
                      value: "Moderately Active",
                      child: Text("Moderately Active"),
                    ),
                    DropdownMenuItem(
                      value: "Very Active",
                      child: Text("Very Active"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      activityLevel = value!;
                    });
                  },
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveProfile,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Save Profile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}