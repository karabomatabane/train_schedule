import 'package:train_schedule/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../models/form.model.dart';

class TrainService {
  final String _baseUrl = Constants.baseUrl;
  final String _schedulePath = Constants.schedulePath;

  Future<String> fetchTrainSchedule(ScheduleFormData form) async {
    var url = Uri.https(_baseUrl, _schedulePath);
    var body = {
      'departStation': form.departStation.toString(),
      'arriveStation': form.arriveStation.toString(),
      'travel_day': form.travelDay,
      'search_time': form.searchTime,
      'HH': form.hours,
      'MM': form.minutes,
    };

    print('Sending request to $url with body: $body');

    var response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load train schedule');
    }
  }
}
