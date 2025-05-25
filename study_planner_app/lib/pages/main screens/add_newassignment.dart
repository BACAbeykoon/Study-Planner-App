import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/Elements/colors.dart';
import 'package:study_planner_app/models/assignment_model.dart';
import 'package:study_planner_app/models/course_model.dart';
import 'package:study_planner_app/services/databases/assignment_service.dart';
import 'package:study_planner_app/utils/util_functions.dart';
import 'package:study_planner_app/widgets/custom_button.dart';
import 'package:study_planner_app/widgets/custom_input.dart';

class AddNewassignment extends StatelessWidget {
  final Course course;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assignmentNameController =
      TextEditingController();
  final TextEditingController _assignmentDescriptionController =
      TextEditingController();
  final TextEditingController _assignmentDurationController =
      TextEditingController();
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier<DateTime>(
    DateTime.now(),
  );
  final ValueNotifier<TimeOfDay> _selectedTime = ValueNotifier<TimeOfDay>(
    TimeOfDay.now(),
  );

  AddNewassignment({super.key, required this.course}) {
    _selectedDate.value = DateTime.now();
    _selectedTime.value = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != _selectedDate.value) {
      _selectedDate.value = picked;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime.value,
    );

    if (picked != null && picked != _selectedTime.value) {
      _selectedTime.value = picked;
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final Assignment assignment = Assignment(
          id: "",
          name: _assignmentNameController.text,
          description: _assignmentDescriptionController.text,
          duration: _assignmentDurationController.text,
          dueDate: _selectedDate.value,
          dueTime: _selectedTime.value,
        );

        AssignmentService().createAssignment(course.id, assignment);

        showSnackbar(
          context: context,
          text: "Successfully added the Assignment",
        );

        await Future.delayed(const Duration(seconds: 2));

        GoRouter.of(context).go('/');
      } catch (error) {
        print(error);
        showSnackbar(context: context, text: "Failed to add Assignment");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Add New Assignment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Assignment Details Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: cardGradient,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assignment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomInput(
                        controller: _assignmentNameController,
                        labelText: 'Assignment Name',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter an assignment name';
                          }
                          return null;
                        },
                      ),
                      CustomInput(
                        controller: _assignmentDescriptionController,
                        labelText: 'Assignment Description',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter an assignment description';
                          }
                          return null;
                        },
                      ),
                      CustomInput(
                        controller: _assignmentDurationController,
                        labelText: 'Assignment Duration',
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter the assignment duration';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Due Date & Time Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: cardGradient,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date & Time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Date Picker
                      ValueListenableBuilder<DateTime>(
                        valueListenable: _selectedDate,
                        builder: (context, selectedDate, child) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: surfaceColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.calendar_today_rounded,
                                  color: primaryColor,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                'Due Date',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'EEEE, MMM dd, yyyy',
                                ).format(selectedDate),
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: primaryColor,
                                size: 16,
                              ),
                              onTap: () => _selectDate(context),
                            ),
                          );
                        },
                      ),
                      // Time Picker
                      ValueListenableBuilder<TimeOfDay>(
                        valueListenable: _selectedTime,
                        builder: (context, selectedTime, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: surfaceColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: secondaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.access_time_rounded,
                                  color: secondaryColor,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                'Due Time',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                selectedTime.format(context),
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: secondaryColor,
                                size: 16,
                              ),
                              onTap: () => _selectTime(context),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Action Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CustomElevatedButton(
                    text: 'Create Assignment',
                    onPressed: () => _submitForm(context),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
