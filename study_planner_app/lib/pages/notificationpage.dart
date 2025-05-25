import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/Elements/colors.dart';
import 'package:study_planner_app/models/notification_model.dart';
import 'package:study_planner_app/services/databases/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<List<NotificationModel>> _fetchNotifications() async {
    return await NotificationsService().getNotifications();
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
          'Notifications',
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
          child: FutureBuilder<List<NotificationModel>>(
            future: _fetchNotifications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading notifications...',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: cardGradient,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accentColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: accentColor,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error Loading Notifications',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: cardGradient,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.notifications_off_rounded,
                            color: primaryColor,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No Notifications',
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'re all caught up! No pending notifications at the moment.',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final notifications = snapshot.data!;

              return Column(
                children: [
                  // Header Section
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_active_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Notifications',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${notifications.length} pending assignment${notifications.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Notifications List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        final hoursLeft =
                            notification.dueDate
                                .difference(DateTime.now())
                                .inHours;
                        final isOverdue = hoursLeft < 0;
                        final isUrgent = hoursLeft <= 24 && hoursLeft > 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            gradient: cardGradient,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isOverdue
                                      ? accentColor.withOpacity(0.5)
                                      : isUrgent
                                      ? warningColor.withOpacity(0.5)
                                      : primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isOverdue
                                        ? accentColor
                                        : isUrgent
                                        ? warningColor
                                        : primaryColor)
                                    .withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with status indicator
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: (isOverdue
                                                ? accentColor
                                                : isUrgent
                                                ? warningColor
                                                : primaryColor)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        isOverdue
                                            ? Icons.warning_rounded
                                            : isUrgent
                                            ? Icons.schedule_rounded
                                            : Icons.assignment_rounded,
                                        color:
                                            isOverdue
                                                ? accentColor
                                                : isUrgent
                                                ? warningColor
                                                : primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notification.assignmentName,
                                            style: TextStyle(
                                              color: primaryTextColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            notification.courseName,
                                            style: TextStyle(
                                              color: secondaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (isOverdue
                                                ? accentColor
                                                : isUrgent
                                                ? warningColor
                                                : successColor)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isOverdue
                                            ? 'OVERDUE'
                                            : isUrgent
                                            ? 'URGENT'
                                            : 'PENDING',
                                        style: TextStyle(
                                          color:
                                              isOverdue
                                                  ? accentColor
                                                  : isUrgent
                                                  ? warningColor
                                                  : successColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Due date and time info
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: surfaceColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Due Date',
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              DateFormat(
                                                'MMM dd, yyyy',
                                              ).format(notification.dueDate),
                                              style: TextStyle(
                                                color: primaryTextColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Time Left',
                                              style: TextStyle(
                                                color: secondaryTextColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              isOverdue
                                                  ? '${(-hoursLeft)} hours ago'
                                                  : hoursLeft < 24
                                                  ? '$hoursLeft hours'
                                                  : '${(hoursLeft / 24).floor()} days',
                                              style: TextStyle(
                                                color:
                                                    isOverdue
                                                        ? accentColor
                                                        : isUrgent
                                                        ? warningColor
                                                        : primaryTextColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
