part of 'schedules_bloc.dart';

abstract class SchedulesState extends Equatable {
  const SchedulesState();

  @override
  List<Object> get props => <Object>[];
}

class SchedulesInitial extends SchedulesState {}

class SchedulesLoading extends SchedulesState {}

class SchedulesSuccess extends SchedulesState {

  const SchedulesSuccess(this.schedules, this.isFormVisible);
  final List<Schedule> schedules;
  final bool isFormVisible;

  @override
  List<Object> get props => [schedules, isFormVisible];
}

class SchedulesFailure extends SchedulesState {

  const SchedulesFailure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}