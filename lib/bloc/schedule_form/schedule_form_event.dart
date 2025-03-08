part of 'schedule_form_bloc.dart';

abstract class ScheduleFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DepartureStationChanged extends ScheduleFormEvent {
  DepartureStationChanged(this.departureStationIndex);
  final int departureStationIndex;

  @override
  List<Object?> get props => [departureStationIndex];
}

class ArrivalStationChanged extends ScheduleFormEvent {
  ArrivalStationChanged(this.arrivalStationIndex);
  final int arrivalStationIndex;

  @override
  List<Object?> get props => [arrivalStationIndex];
}

class TravelDayChanged extends ScheduleFormEvent {
  TravelDayChanged(this.travelDay);
  final String travelDay;

  @override
  List<Object?> get props => [travelDay];
}

class TimeSelected extends ScheduleFormEvent {
  TimeSelected(this.time);
  final TimeOfDay time;

  @override
  List<Object?> get props => [time];
}

class SubmitForm extends ScheduleFormEvent {}

