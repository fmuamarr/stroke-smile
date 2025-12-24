import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pohps_app/features/step_by_step/data/models/step_guide_model.dart';
import '../../../../core/error/failures.dart';

abstract class StepLocalDataSource {
  Future<List<StepGuideModel>> getStepGuides();
}

class StepLocalDataSourceImpl implements StepLocalDataSource {
  @override
  Future<List<StepGuideModel>> getStepGuides() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/steps.json',
      );
      final List<dynamic> data = json.decode(response);
      return data.map((json) => StepGuideModel.fromJson(json)).toList();
    } catch (e) {
      throw const CacheFailure('Failed to load steps');
    }
  }
}
