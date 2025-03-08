import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'schedule_form_event.dart';

part 'schedule_form_state.dart';

class ScheduleFormBloc extends Bloc<ScheduleFormEvent, ScheduleFormState> {
  ScheduleFormBloc() : super(const ScheduleFormState()) {
    on<DepartureStationChanged>(_handleDepartStationChanged);

    on<ArrivalStationChanged>(_handleArrivalStationChanged);

    on<TravelDayChanged>(_handleTravelDayChanged);

    on<TimeSelected>(_handleTimeSelected);

    on<SubmitForm>(_handleOnSubmit);
  }

  Future<void> _handleOnSubmit(
    SubmitForm event,
    Emitter<ScheduleFormState> emit,
  ) async {
    // Handle form submission if needed
  }

  Future<void> _handleTravelDayChanged(
    TravelDayChanged event,
    Emitter<ScheduleFormState> emit,
  ) async {
    emit(state.copyWith(selectedTravelDay: event.travelDay));
  }

  Future<void> _handleArrivalStationChanged(
    ArrivalStationChanged event,
    Emitter<ScheduleFormState> emit,
  ) async {
    emit(
        state.copyWith(selectedArrivalStationIndex: event.arrivalStationIndex));
  }

  Future<void> _handleDepartStationChanged(
    DepartureStationChanged event,
    Emitter<ScheduleFormState> emit,
  ) async {
    emit(state.copyWith(
        selectedDepartureStationIndex: event.departureStationIndex));
  }

  Future<void> _handleTimeSelected(
    TimeSelected event,
    Emitter<ScheduleFormState> emit,
  ) async {
    emit(state.copyWith(selectedTime: event.time));
  }
}
