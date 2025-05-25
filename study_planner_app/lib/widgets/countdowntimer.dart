import 'package:flutter/material.dart';
import 'dart:async';

import 'package:study_planner_app/Elements/colors.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime dueDate;

  const CountdownTimer({super.key, required this.dueDate});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  String _timeRemaining = '';
  bool _isOverdue = false;
  bool _isUrgent = false;

  @override
  void initState() {
    super.initState();
    _updateTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  void _updateTimer() {
    final now = DateTime.now();
    final difference = widget.dueDate.difference(now);

    if (difference.isNegative) {
      setState(() {
        _timeRemaining = 'Overdue';
        _isOverdue = true;
        _isUrgent = false;
      });
    } else {
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      setState(() {
        if (days > 0) {
          _timeRemaining = '${days}d ${hours}h ${minutes}m';
        } else if (hours > 0) {
          _timeRemaining = '${hours}h ${minutes}m ${seconds}s';
        } else {
          _timeRemaining = '${minutes}m ${seconds}s';
        }
        _isOverdue = false;
        _isUrgent = difference.inHours <= 24; // Less than 24 hours
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    if (_isOverdue) {
      backgroundColor = warningColor.withOpacity(0.2);
      textColor = warningColor;
      icon = Icons.warning_rounded;
    } else if (_isUrgent) {
      backgroundColor = accentColor.withOpacity(0.2);
      textColor = accentColor;
      icon = Icons.schedule_rounded;
    } else {
      backgroundColor = successColor.withOpacity(0.2);
      textColor = successColor;
      icon = Icons.check_circle_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            _isOverdue ? _timeRemaining : 'Due in $_timeRemaining',
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
