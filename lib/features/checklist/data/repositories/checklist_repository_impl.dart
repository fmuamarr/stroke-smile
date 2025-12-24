import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:pohps_app/features/checklist/domain/entities/checklist_item.dart';
import 'package:pohps_app/features/checklist/domain/repositories/checklist_repository.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/checklist_local_datasource_sqlite.dart';
import '../../data/models/checklist_model.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/daily_report.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistLocalDataSource localDataSource;

  ChecklistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ChecklistItem>>> getDailyChecklist(
    DateTime date,
  ) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final items = await localDataSource.getChecklistItems();
      final logs = await localDataSource.getChecklistLogs(dateStr);

      final domainItems = items.map((item) {
        final log = logs.firstWhere(
          (l) => l.checklistItemId == item.id,
          orElse: () => ChecklistLogModel(
            checklistItemId: item.id,
            date: dateStr,
            isCompleted: false,
          ),
        );

        return ChecklistItem(
          id: item.id,
          title: item.title,
          description: item.description,
          time: item.time,
          icon: IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
          color: Color(item.colorValue),
          isDefault: item.isDefault,
          isCompleted: log.isCompleted,
          mouthCondition: log.mouthCondition,
          notes: log.notes,
        );
      }).toList();

      // Sort by time
      domainItems.sort((a, b) => a.time.compareTo(b.time));

      return Right(domainItems);
    } catch (e) {
      return const Left(CacheFailure('Failed to load checklist'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleChecklistItem(
    String itemId,
    DateTime date,
    bool isCompleted, {
    String? mouthCondition,
    String? notes,
  }) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final log = ChecklistLogModel(
        checklistItemId: itemId,
        date: dateStr,
        isCompleted: isCompleted,
        completedAt: isCompleted ? DateTime.now().toIso8601String() : null,
        mouthCondition: mouthCondition,
        notes: notes,
      );
      await localDataSource.updateChecklistLog(log);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to update checklist item'));
    }
  }

  @override
  Future<Either<Failure, DateTime>> getStartDate() async {
    try {
      final date = await localDataSource.getStartDate();
      return Right(date);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<DateTime, double>>> getMonthlyCompletion(
    DateTime month,
  ) async {
    try {
      final monthPrefix = DateFormat('yyyy-MM').format(month);
      final logs = await localDataSource.getChecklistLogsForMonth(monthPrefix);
      final items = await localDataSource.getChecklistItems();
      final totalItems = items.length;

      if (totalItems == 0) return const Right({});

      final Map<String, int> completedCount = {};

      for (var log in logs) {
        if (log.isCompleted) {
          completedCount[log.date] = (completedCount[log.date] ?? 0) + 1;
        }
      }

      final Map<DateTime, double> result = {};

      completedCount.forEach((dateStr, count) {
        final date = DateTime.parse(dateStr);
        result[date] = count / totalItems;
      });

      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DailyReport>>> getMonthlyReports(
    DateTime month,
  ) async {
    try {
      final monthPrefix = DateFormat('yyyy-MM').format(month);
      final logs = await localDataSource.getChecklistLogsForMonth(monthPrefix);
      final items = await localDataSource.getChecklistItems();

      // Group logs by date
      final Map<String, List<ChecklistLogModel>> logsByDate = {};
      for (var log in logs) {
        if (!logsByDate.containsKey(log.date)) {
          logsByDate[log.date] = [];
        }
        logsByDate[log.date]!.add(log);
      }

      final List<DailyReport> reports = [];
      final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

      for (int i = 1; i <= daysInMonth; i++) {
        final date = DateTime(month.year, month.month, i);
        final dateStr = DateFormat('yyyy-MM-dd').format(date);

        final dayLogs = logsByDate[dateStr] ?? [];

        final domainItems = items.map((item) {
          final log = dayLogs.firstWhere(
            (l) => l.checklistItemId == item.id,
            orElse: () => ChecklistLogModel(
              checklistItemId: item.id,
              date: dateStr,
              isCompleted: false,
            ),
          );

          return ChecklistItem(
            id: item.id,
            title: item.title,
            description: item.description,
            time: item.time,
            icon: IconData(item.iconCodePoint, fontFamily: 'MaterialIcons'),
            color: Color(item.colorValue),
            isDefault: item.isDefault,
            isCompleted: log.isCompleted,
            mouthCondition: log.mouthCondition,
            notes: log.notes,
          );
        }).toList();

        // Sort by time
        domainItems.sort((a, b) => a.time.compareTo(b.time));

        reports.add(DailyReport(date: date, items: domainItems));
      }

      return Right(reports);
    } catch (e) {
      return const Left(CacheFailure('Failed to load monthly reports'));
    }
  }
}
