import 'package:flutter/material.dart';
import '../models/performance_model.dart';
import '../models/schedule_model.dart';
import '../services/api_service.dart';

class PerformanceProvider extends ChangeNotifier {
  PerformancePrediction? _prediction;
  final List<PerformancePrediction> _history = [];
  List<ScheduleTask> _schedules = [];
  bool _isLoading = false;
  String? _errorMessage;

  PerformancePrediction? get prediction => _prediction;
  List<PerformancePrediction> get history => List.unmodifiable(_history);
  List<ScheduleTask> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> predictPerformance(StudentPerformanceData data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.predictPerformance(data);

    _isLoading = false;
    if (result != null) {
      _prediction = result;
      _history.insert(0, result);
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to predict performance';
      notifyListeners();
      return false;
    }
  }

  Future<bool> generateSchedule(
    List<ScheduleTask> schedule, {
    String? goalType,
    double? availableHours,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.generateSchedule(
      schedule,
      goalType: goalType,
      availableHours: availableHours,
    );

    _isLoading = false;
    if (result != null) {
      _schedules = result;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to generate schedule';
      notifyListeners();
      return false;
    }
  }

  void clearPrediction() {
    _prediction = null;
    notifyListeners();
  }

  Future<bool> fetchSavedSchedule() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await ApiService.fetchSavedSchedule();

    _isLoading = false;
    if (result != null) {
      _schedules = result;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to fetch saved schedule';
      notifyListeners();
      return false;
    }
  }
}
