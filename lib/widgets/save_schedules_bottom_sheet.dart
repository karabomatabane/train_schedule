import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/saved_schedules/saved_schedules_bloc.dart';
import '../models/schedule.model.dart';
import 'schedule_card.dart';

class SavedSchedulesBottomSheet extends StatefulWidget {
  const SavedSchedulesBottomSheet({
    super.key,
  });

  @override
  State<SavedSchedulesBottomSheet> createState() =>
      _SavedSchedulesBottomSheetState();
}

class _SavedSchedulesBottomSheetState extends State<SavedSchedulesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Text(
        'Planned Trips',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 16.0),
      // List of saved schedules
      BlocBuilder<SavedSchedulesBloc, SavedSchedulesState>(
        builder: (BuildContext context, SavedSchedulesState state) {
          if (state is SavedSchedulesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedSchedulesFailure) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SavedSchedulesSuccess) {
            if (state.schedules.isEmpty) {
              return const Center(child: Text('No saved schedules found.'));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.schedules.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Schedule schedule =state.schedules[index];
                    return ScheduleCard(
                        schedule: schedule,
                        onPressed: (Schedule schedule) {
                          //are you sure you want to delete this schedule?
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Schedule'),
                                content: Text(
                                    'Are you sure you want to delete the schedule for train ${schedule.trainNo} from ${schedule.departStation} to ${schedule.arriveStation}?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Delete the schedule an
                                      context.read<SavedSchedulesBloc>().add(
                                          DeleteSavedSchedule(schedule));
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        }); // Add onPressed callback
                  },
                ),
              );
            }
          }
          return const Center(child: Text('Unknown state'));},
      ),
    ]);
  }
}
