import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner_app/models/assignment_model.dart';
import 'package:study_planner_app/models/course_model.dart';
import 'package:study_planner_app/models/note_model.dart';
import 'package:study_planner_app/pages/home.dart';
import 'package:study_planner_app/pages/main%20screens/add_new_course.dart';
import 'package:study_planner_app/pages/main%20screens/add_new_note.dart';
import 'package:study_planner_app/pages/main%20screens/add_newassignment.dart';
import 'package:study_planner_app/pages/main%20screens/single_assingmentpage.dart';
import 'package:study_planner_app/pages/main%20screens/single_notepage.dart';
import 'package:study_planner_app/pages/single_course.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return const MaterialPage<dynamic>(
        child: Scaffold(
          body: Center(child: Text("This page is not Available!")),
        ),
      );
    },
    routes: [
      // Home Page
      GoRoute(
        name: "home",
        path: "/",
        builder: (context, state) {
          return HomePage();
        },
      ),

      //add course
      GoRoute(
        name: "add Course",
        path: "/add-course",
        builder: (context, state) {
          return AddNewCourse();
        },
      ),

      //Single Course
      GoRoute(
        path: '/single-course',
        name: "single-course",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return SingleCoursePage(course: course);
        },
      ),

      //add new note
      GoRoute(
        path: '/add-new-note',
        name: "add-new-note",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return AddNewnote(course: course);
        },
      ),

      //add new assignment
      GoRoute(
        path: '/add-new-assignment',
        name: "add-new-assignment",
        builder: (context, state) {
          final Course course = state.extra as Course;
          return AddNewassignment(course: course);
        },
      ),

      //Single Course
      GoRoute(
        path: '/single-course',
        builder: (context, state) {
          final Course course = state.extra as Course;
          return SingleCoursePage(course: course);
        },
      ),

      //single assignment
      GoRoute(
        path: '/single-assignment',
        builder: (context, state) {
          final Assignment assignment = state.extra as Assignment;
          return SingleAssignmentScreen(assignment: assignment);
        },
      ),

      //single note
      GoRoute(
        path: '/single-note',
        builder: (context, state) {
          final Note note = state.extra as Note;
          return SingleNoteScreen(note: note);
        },
      ),
    ],
  );
}
