part of 'schedules_bloc.dart';

abstract class SchedulesEvent extends Equatable {
  const SchedulesEvent();

  @override
  List<Object> get props => [];
}

class ToggleFormVisibility extends SchedulesEvent {}

class FetchSchedules extends SchedulesEvent {
  final ScheduleFormData formData;

  const FetchSchedules(this.formData);

  @override
  List<Object> get props => [formData];
}
