import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner_app/models/course_model.dart';
import 'package:study_planner_app/services/databases/course_service.dart';
import 'package:study_planner_app/utils/util_functions.dart';
import 'package:study_planner_app/widgets/custom_button.dart';
import 'package:study_planner_app/widgets/custom_input.dart';
import 'package:study_planner_app/Elements/colors.dart';

class AddNewCourse extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _courseDurationController =
      TextEditingController();
  final TextEditingController _courseScheduleController =
      TextEditingController();
  final TextEditingController _courseInstructorController =
      TextEditingController();

  AddNewCourse({super.key});

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        final Course course = Course(
          id: '',
          name: _courseNameController.text,
          description: _courseDescriptionController.text,
          duration: _courseDurationController.text,
          schedule: _courseScheduleController.text,
          instructor: _courseInstructorController.text,
        );

        await CourseService().createCourse(course);

        if (context.mounted) {
          showSnackbar(context: context, text: "Course Added Succsesfully");
        }

        await Future.delayed(const Duration(seconds: 2));

        GoRouter.of(context).go('/');
      } catch (error) {
        print(error);
        if (context.mounted) {
          showSnackbar(context: context, text: " Failed to Add Course");
        }
      }
    }
  }

  // Helper method to build field with icon
  Widget _buildFieldWithIcon({required IconData icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: primaryColor, size: 18),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: surfaceColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryTextColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Add Course",
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    // Header Section with Enhanced Design
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: cardGradient,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Animated Icon Container
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.school_rounded,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Create New Course',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Fill in the details below to add a new course and start managing your study planner effectively. All fields are required.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 15,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Progress indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: surfaceColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: primaryColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Step 1 of 1: Course Information',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Enhanced Form Fields Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: cardGradient,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: primaryGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.edit_note_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Course Information',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please fill in all the required information about your course',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Course Name Field with Icon
                          _buildFieldWithIcon(
                            icon: Icons.book_rounded,
                            child: CustomInput(
                              controller: _courseNameController,
                              labelText: 'Course Name',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter a course name';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Course Description Field with Icon
                          _buildFieldWithIcon(
                            icon: Icons.description_rounded,
                            child: CustomInput(
                              controller: _courseDescriptionController,
                              labelText: 'Course Description',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter a course description';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Course Duration Field with Icon
                          _buildFieldWithIcon(
                            icon: Icons.access_time_rounded,
                            child: CustomInput(
                              controller: _courseDurationController,
                              labelText: 'Course Duration (e.g., 80 H)',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter the course duration';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Course Schedule Field with Icon
                          _buildFieldWithIcon(
                            icon: Icons.calendar_today_rounded,
                            child: CustomInput(
                              controller: _courseScheduleController,
                              labelText: 'Course Schedule (e.g., 2025-06-14)',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter the course schedule';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Course Instructor Field with Icon
                          _buildFieldWithIcon(
                            icon: Icons.person_rounded,
                            child: CustomInput(
                              controller: _courseInstructorController,
                              labelText: 'Course Instructor',
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter the course instructor';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Enhanced Action Buttons Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: cardGradient,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.rocket_launch_rounded,
                                color: primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ready to Create?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Review your information and create your new course',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              // Cancel Button
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Create Button
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: CustomElevatedButton(
                                    text: '✨ Create Course',
                                    onPressed: () => _submitForm(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
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
