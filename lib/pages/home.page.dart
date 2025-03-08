import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/saved_schedules/saved_schedules_bloc.dart';
import '../bloc/schedules/schedules_bloc.dart';
import '../models/form.model.dart';
import '../models/schedule.model.dart';
import '../services/cttrain.service.dart';
import '../widgets/app_bar.dart';
import '../widgets/save_schedules_bottom_sheet.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TrainService trainService = TrainService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              showDragHandle: true,
              builder: (BuildContext context) {
                // Trigger data fetch when showing bottom sheet
                final SavedSchedulesBloc savedSchedulesBloc =
                    context.read<SavedSchedulesBloc>();
                savedSchedulesBloc.add(const FetchSavedSchedules());

                return BlocProvider<SavedSchedulesBloc>.value(
                  value: context.read<SavedSchedulesBloc>(),
                  child: const SavedSchedulesBottomSheet(),
                );
              });
        },
        child: const Icon(Icons.bookmark),
      ),
      body: BlocBuilder<SchedulesBloc, SchedulesState>(
        builder: (BuildContext context, SchedulesState state) {
          print(state.runtimeType);
          if (state is SchedulesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SchedulesFailure) {
            return Center(child: Text(state.message));
          } else if (state is SchedulesSuccess) {
            final List<Schedule> trainSchedules = state.schedules;
            return Column(
              children: <Widget>[
                // Animated Form Visibility
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  // Animation duration
                  crossFadeState: state.isFormVisible
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: ScheduleForm(
                    onSubmit: (ScheduleFormData formData) {
                      context
                          .read<SchedulesBloc>()
                          .add(FetchSchedules(formData));
                    },
                  ),
                  secondChild:
                      Container(), // Empty container when form is hidden
                ),
                // Caret Button to Toggle Form Visibility
                GestureDetector(
                  onTap: () {
                    context.read<SchedulesBloc>().add(ToggleFormVisibility());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.background,
                    child: Icon(
                      state.isFormVisible
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 32.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  // Animation duration
                  height: state.isFormVisible
                      ? 190
                      : MediaQuery.of(context).size.height * 0.6,
                  // Adjust height based on form visibility
                  child: ListView.builder(
                    itemCount: trainSchedules.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Schedule schedule = trainSchedules[index];
                      return ScheduleCard(
                        schedule: schedule,
                        onPressed: (Schedule schedule) async {
                          final bool isSaved = await context
                              .read<SavedSchedulesBloc>()
                              .saveScheduleAndGetResult(schedule);
                          if (isSaved && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Trip (${schedule.trainNo}) saved successfully!'),
                              ),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Trip (${schedule.trainNo}) already saved!'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            );
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
