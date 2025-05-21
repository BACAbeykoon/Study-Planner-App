import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_planner_app/pages/home.dart';
import 'package:study_planner_app/pages/main%20screens/add_new_course.dart';

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
    ],
  );
}
