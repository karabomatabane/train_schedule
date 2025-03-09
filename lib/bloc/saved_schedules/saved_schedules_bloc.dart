import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/schedule.model.dart';
import '../../services/local_storage.service.dart';
import '../../services/notification.service.dart';

part 'saved_schedules_event.dart';
part 'saved_schedules_state.dart';

class SavedSchedulesBloc extends Bloc<SavedSchedulesEvent, SavedSchedulesState> {
  SavedSchedulesBloc({required this.localStorageService}) : super(SavedSchedulesInitial()) {
    on<FetchSavedSchedules>(_handleFetchSavedSchedules);
    on<SaveSchedule>(_handleSaveSchedule);
    on<DeleteSavedSchedule>(_handleDeleteSavedSchedule);
    _onInit();
  }

  void _onInit() {
    add(const FetchSavedSchedules());
  }

  final LocalStorageService localStorageService;
  final NotificationService notificationService = NotificationService();

  Future<void> _handleFetchSavedSchedules(
    FetchSavedSchedules event,
    Emitter<SavedSchedulesState> emit,
  ) async {
    // Fetch saved schedules from local storage
    final List<Schedule> savedSchedules = await localStorageService.getScheduleList();
    emit(SavedSchedulesSuccess(savedSchedules));
  }

  Future<void> _handleSaveSchedule(
    SaveSchedule event,
    Emitter<SavedSchedulesState> emit,
  ) async {
    // Save the schedule to local storage
    await localStorageService.saveSchedule(event.schedule);
    // Fetch saved schedules from local storage
    final List<Schedule> savedSchedules = await localStorageService.getScheduleList();
    emit(SavedSchedulesSuccess(savedSchedules));
  }

  Future<bool> saveScheduleAndGetResult(Schedule schedule) async {
    final bool isNew = await localStorageService.saveSchedule(schedule);
    if (isNew) {
      notificationService.scheduleNotification(schedule);
    }
    // Emit the updated state
    add(const FetchSavedSchedules());
    return isNew;
  }

  Future<void> _handleDeleteSavedSchedule(
      DeleteSavedSchedule event,
      Emitter<SavedSchedulesState> emit,
      ) async {
    try {
      // Show loading state while deleting
      emit(SavedSchedulesLoading());

      // Await the deletion to avoid race conditions
      await localStorageService.deleteSchedule(event.schedule);

      // Fetch the updated list of saved schedules
      final List<Schedule> savedSchedules =
      await localStorageService.getScheduleList();

      // Emit the updated list
      emit(SavedSchedulesSuccess(List<Schedule>.from(savedSchedules)));
    } catch (e) {
      emit(const SavedSchedulesFailure('Failed to delete schedule.'));
    }
  }

}
