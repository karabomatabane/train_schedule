import 'package:flutter/material.dart';

import '../models/schedule.model.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onPressed,
  });

  final Schedule schedule;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final Schedule schedule = this.schedule;
    return GestureDetector(
      onTap: () => onPressed(schedule),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Train Number
              Text(
                schedule.trainNo,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8.0), // Spacing
              // Departure Details
              Row(
                children: [
                  const Icon(
                    Icons.arrow_upward, // Departure icon
                    color: Colors.green,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0), // Spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Departure',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      Text(
                        '${schedule.departStation} at ${schedule.departTime}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8.0), // Spacing
              // Arrival Details
              Row(
                children: [
                  const Icon(
                    Icons.arrow_downward, // Arrival icon
                    color: Colors.red,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8.0), // Spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arrival',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      Text(
                        '${schedule.arriveStation} at ${schedule.arriveTime}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
