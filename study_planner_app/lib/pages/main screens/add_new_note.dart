import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_planner_app/models/course_model.dart';
import 'package:study_planner_app/widgets/custom_button.dart';
import 'package:study_planner_app/widgets/custom_input.dart';

class AddNewnote extends StatefulWidget {
  final Course course;
  AddNewnote({super.key, required this.course});

  @override
  State<AddNewnote> createState() => _AddNewnoteState();
}

class _AddNewnoteState extends State<AddNewnote> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _referencesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      print(_selectedImage!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Note For Your Course',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              //description
              const Text(
                'Fill in the details below to add a new note. And start managing your study planner.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInput(
                      controller: _titleController,
                      labelText: "Note Title",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a Note Title';
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: _sectionController,
                      labelText: "Note Section",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a Note Section';
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: _referencesController,
                      labelText: "Reference Book",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter the reference Book';
                        }
                        return null;
                      },
                    ),
                    CustomInput(
                      controller: _descriptionController,
                      labelText: "Description",
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a Description';
                        }
                        return null;
                      },
                    ),

                    const Divider(),
                    const Text(
                      'Upload Note Image , for better understanding and quick revision',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    CustomElevatedButton(
                      text: "Add Note Images",
                      onPressed: _pickImage,
                    ),
                    const SizedBox(height: 20),
                    // Display selected image
                    _selectedImage != null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Image:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_selectedImage!.path),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        )
                        : const Text(
                          'No image selected.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      text: "Submit Notes",
                      onPressed: () => _submitForm(context),
                    ),
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
