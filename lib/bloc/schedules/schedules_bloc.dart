import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/form.model.dart';
import '../../models/schedule.model.dart';
import '../../services/cttrain.service.dart';
import '../../utils/util.dart';

part 'schedules_event.dart';
part 'schedules_state.dart';

class SchedulesBloc extends Bloc<SchedulesEvent, SchedulesState> {
  SchedulesBloc({required this.trainService})
      : super(const SchedulesSuccess(<Schedule>[], true)) {
    // Initial state
    on<ToggleFormVisibility>(_handleToggleFormVisibility);
    on<FetchSchedules>(_handleFetchSchedules);
  }

  final TrainService trainService;
  bool isFormVisible = false;

  void _handleToggleFormVisibility(
    ToggleFormVisibility event,
    Emitter<SchedulesState> emit,
  ) {
    isFormVisible = !isFormVisible;
    if (state is SchedulesSuccess) {
      emit(SchedulesSuccess((state as SchedulesSuccess).schedules, isFormVisible));
    } // Emit the updated state
  }

  Future<void> _handleFetchSchedules(
    FetchSchedules event,
    Emitter<SchedulesState> emit,
  ) async {
    emit(SchedulesLoading());
    try {
      final String htmlString =
          await trainService.fetchTrainSchedule(event.formData);
      final List<Schedule> schedules = Util.parseTrainSchedule(htmlString);
      emit(SchedulesSuccess(schedules, isFormVisible));
    } catch (e) {
      emit(
        const SchedulesFailure('Failed to fetch schedules. Please try again.'),
      );
    }
  }
}
