import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/Elements/colors.dart';
import 'package:study_planner_app/models/assignment_model.dart';
import 'package:study_planner_app/models/course_model.dart';
import 'package:study_planner_app/models/note_model.dart';
import 'package:study_planner_app/services/databases/assignment_service.dart';
import 'package:study_planner_app/services/databases/course_service.dart';
import 'package:study_planner_app/services/databases/note_service.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    try {
      final courses = await CourseService().getCourses();
      final assignmentsMap =
          await AssignmentService().getAssignmentsWithCourseName();
      final notesMap = await NoteService().getNotesWithCourseName();

      return {
        'courses': courses,
        'assignments': assignmentsMap,
        'notes': notesMap,
      };
    } catch (error) {
      print('Error fetching data: $error');
      return {'courses': [], 'assignments': {}, 'notes': {}};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF0F0F23), const Color(0xFF16213E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Courses',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: cardGradient,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_rounded,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          GoRouter.of(context).push('/notifications');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading your courses...',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return _buildErrorState(
                        context,
                        snapshot.error.toString(),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return _buildEmptyState(context);
                    }

                    final courses =
                        snapshot.data!['courses'] as List<Course>? ?? [];
                    final assignmentsMap =
                        snapshot.data!['assignments']
                            as Map<String, List<Assignment>>? ??
                        {};
                    final notesMap =
                        snapshot.data!['notes'] as Map<String, List<Note>>? ??
                        {};

                    if (courses.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        final courseAssignments =
                            assignmentsMap[course.name] ?? [];
                        final courseNotes = notesMap[course.name] ?? [];

                        final colors = [
                          [const Color(0xFF6C63FF), const Color(0xFF4ECDC4)],
                          [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
                          [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
                          [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)],
                        ];
                        final gradientColors = colors[index % colors.length];

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [surfaceColor, cardColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: gradientColors[0].withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors[0].withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                GoRouter.of(
                                  context,
                                ).push('/single-course', extra: course);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: gradientColors,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.book_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course.name,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                course.description,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: secondaryTextColor,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: gradientColors[0],
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildDetailRow(
                                            Icons.schedule_rounded,
                                            'Duration',
                                            course.duration,
                                            gradientColors[0],
                                          ),
                                          const SizedBox(height: 8),
                                          _buildDetailRow(
                                            Icons.calendar_today_rounded,
                                            'Schedule',
                                            course.schedule,
                                            gradientColors[0],
                                          ),
                                          const SizedBox(height: 8),
                                          _buildDetailRow(
                                            Icons.person_rounded,
                                            'Instructor',
                                            course.instructor,
                                            gradientColors[0],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (courseAssignments.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.assignment_rounded,
                                            color: gradientColors[0],
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Assignments (${courseAssignments.length})',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: gradientColors[0],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ...courseAssignments.map((assignment) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: gradientColors[0]
                                                  .withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: gradientColors[0]
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.assignment_outlined,
                                                color: gradientColors[0],
                                                size: 20,
                                              ),
                                            ),
                                            title: Text(
                                              assignment.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Due: ${DateFormat.yMMMd().format(assignment.dueDate)}',
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: gradientColors[0],
                                              size: 16,
                                            ),
                                            onTap: () {
                                              GoRouter.of(context).push(
                                                '/single-assignment',
                                                extra: assignment,
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    if (courseNotes.isNotEmpty) ...[
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.note_rounded,
                                            color: gradientColors[1],
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Notes (${courseNotes.length})',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: gradientColors[1],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ...courseNotes.map((note) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: gradientColors[1]
                                                  .withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: gradientColors[1]
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.note_outlined,
                                                color: gradientColors[1],
                                                size: 20,
                                              ),
                                            ),
                                            title: Text(
                                              note.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Section: ${note.section}',
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: gradientColors[1],
                                              size: 16,
                                            ),
                                            onTap: () {
                                              GoRouter.of(context).push(
                                                '/single-note',
                                                extra: note,
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon Container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Main Message
              Text(
                'No Courses Yet',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Start your learning journey by adding your first course',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Action Button
              Container(
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      GoRouter.of(context).push('/add-course');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Add Your First Course',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Feature Cards
              Row(
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      Icons.assignment_rounded,
                      'Track Assignments',
                      'Manage deadlines and submissions',
                      secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFeatureCard(
                      Icons.note_rounded,
                      'Take Notes',
                      'Organize your study materials',
                      accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: warningColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: warningColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 50,
                color: warningColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Trigger rebuild
                (context as Element).markNeedsBuild();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: warningColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: secondaryTextColor, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
