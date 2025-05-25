import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/Elements/colors.dart';
import 'package:study_planner_app/models/assignment_model.dart';
import 'package:study_planner_app/pages/notificationpage.dart';
import 'package:study_planner_app/services/databases/assignment_service.dart';
import 'package:study_planner_app/services/databases/notification_service.dart';
import 'package:study_planner_app/widgets/countdowntimer.dart';

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key});

  Future<Map<String, List<Assignment>>> _fetchAssignments() async {
    return await AssignmentService().getAssignmentsWithCourseName();
  }

  Future<void> _checkAndStoreOverdueAssignments() async {
    await NotificationsService().storeOverdueAssignments();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger the method when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStoreOverdueAssignments();
    });
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
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assignments',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: FutureBuilder<Map<String, List<Assignment>>>(
                  future: _fetchAssignments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: warningColor,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: secondaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    final assignmentsMap = snapshot.data!;
                    final now = DateTime.now();

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: assignmentsMap.keys.length,
                      itemBuilder: (context, index) {
                        final courseName = assignmentsMap.keys.elementAt(index);
                        final assignments = assignmentsMap[courseName]!;

                        final colors = [
                          [const Color(0xFF6C63FF), const Color(0xFF4ECDC4)],
                          [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
                          [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
                          [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)],
                        ];
                        final gradientColors = colors[index % colors.length];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              expansionTileTheme: ExpansionTileThemeData(
                                backgroundColor: Colors.transparent,
                                collapsedBackgroundColor: Colors.transparent,
                                iconColor: gradientColors[0],
                                collapsedIconColor: gradientColors[0],
                              ),
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              childrenPadding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 16,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.folder_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              title: Text(
                                courseName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${assignments.length} assignment${assignments.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              children:
                                  assignments.map((assignment) {
                                    final isOverdue = assignment.dueDate
                                        .isBefore(now);
                                    final isUpcoming =
                                        assignment.dueDate
                                                .difference(now)
                                                .inDays <=
                                            3 &&
                                        !isOverdue;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isOverdue
                                                  ? warningColor.withOpacity(
                                                    0.5,
                                                  )
                                                  : isUpcoming
                                                  ? accentColor.withOpacity(0.5)
                                                  : gradientColors[0]
                                                      .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(
                                          16,
                                        ),
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                isOverdue
                                                    ? warningColor.withOpacity(
                                                      0.2,
                                                    )
                                                    : isUpcoming
                                                    ? accentColor.withOpacity(
                                                      0.2,
                                                    )
                                                    : gradientColors[0]
                                                        .withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            isOverdue
                                                ? Icons.warning_rounded
                                                : isUpcoming
                                                ? Icons.schedule_rounded
                                                : Icons.assignment_outlined,
                                            color:
                                                isOverdue
                                                    ? warningColor
                                                    : isUpcoming
                                                    ? accentColor
                                                    : gradientColors[0],
                                            size: 20,
                                          ),
                                        ),
                                        title: Text(
                                          assignment.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                isOverdue
                                                    ? warningColor
                                                    : Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Text(
                                              assignment.description,
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 14,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 16,
                                                  color:
                                                      isOverdue
                                                          ? warningColor
                                                          : gradientColors[0],
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Due: ${DateFormat.yMMMd().format(assignment.dueDate)}',
                                                  style: TextStyle(
                                                    color:
                                                        isOverdue
                                                            ? warningColor
                                                            : gradientColors[0],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Duration: ${assignment.duration} hours',
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            CountdownTimer(
                                              dueDate: assignment.dueDate,
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: gradientColors[0],
                                          size: 16,
                                        ),
                                      ),
                                    );
                                  }).toList(),
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
                  gradient: LinearGradient(
                    colors: [accentColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.assignment_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              // Main Message
              Text(
                'No Assignments Yet',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Add courses first, then create assignments to track your academic progress and deadlines',
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
                  gradient: LinearGradient(
                    colors: [accentColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
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
                      Navigator.pop(context);
                      // Navigate to courses tab (index 1)
                      if (context.mounted) {
                        // This will trigger the parent HomePage to switch to courses tab
                        // You might need to implement a callback or use a state management solution
                      }
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
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Add Courses First',
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
                      Icons.schedule_rounded,
                      'Track Deadlines',
                      'Never miss an assignment deadline',
                      warningColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildFeatureCard(
                      Icons.timer_rounded,
                      'Time Management',
                      'Plan your study time effectively',
                      successColor,
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
}
