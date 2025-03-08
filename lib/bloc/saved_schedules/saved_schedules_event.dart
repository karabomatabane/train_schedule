part of 'saved_schedules_bloc.dart';

sealed class SavedSchedulesEvent extends Equatable {
  const SavedSchedulesEvent();
}

class FetchSavedSchedules extends SavedSchedulesEvent {
  const FetchSavedSchedules();

  @override
  List<Object> get props => [];
}

class SaveSchedule extends SavedSchedulesEvent {

  const SaveSchedule(this.schedule);
  final Schedule schedule;

  @override
  List<Object> get props => [schedule];
}

class DeleteSavedSchedule extends SavedSchedulesEvent {

  const DeleteSavedSchedule(this.schedule);
  final Schedule schedule;

  @override
  List<Object> get props => [schedule];
}

class DeleteAllSavedSchedules extends SavedSchedulesEvent {
  const DeleteAllSavedSchedules();

  @override
  List<Object> get props => [];
}