import 'package:elementary_test/elementary_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mvvm_elementary/domain/entities/task.dart';
import 'package:mvvm_elementary/domain/usecases/add_task_usecase.dart';
import 'package:mvvm_elementary/domain/usecases/delete_task_usecase.dart';
import 'package:mvvm_elementary/domain/usecases/get_tasks_usecase.dart';
import 'package:mvvm_elementary/domain/usecases/toggle_task_usecase.dart';
import 'package:mvvm_elementary/presentation/home/home_model.dart';
import 'package:mvvm_elementary/presentation/home/home_widget.dart';
import 'package:mvvm_elementary/presentation/home/home_widget_model.dart';

class MockGetTasks extends Mock implements GetTasksUseCase {}
class MockAddTask extends Mock implements AddTaskUseCase {}
class MockToggleTask extends Mock implements ToggleTaskUseCase {}
class MockDeleteTask extends Mock implements DeleteTaskUseCase {}

void main() {
  late GetTasksUseCase mockGetTasks;
  late AddTaskUseCase mockAddTask;
  late ToggleTaskUseCase mockToggleTask;
  late DeleteTaskUseCase mockDeleteTask;

  final sampleTask = Task(
    id: '1',
    title: 'Test task',
    description: '',
    isDone: false,
    createdAt: DateTime(2024),
  );

  setUpAll(() {
    registerFallbackValue(sampleTask);
  });

  setUp(() {
    mockGetTasks = MockGetTasks();
    mockAddTask = MockAddTask();
    mockToggleTask = MockToggleTask();
    mockDeleteTask = MockDeleteTask();
  });

  HomeWidgetModel makeWm() => HomeWidgetModel(
        HomeModel(mockGetTasks, mockAddTask, mockToggleTask, mockDeleteTask),
      );

  group('HomeWidgetModel', () {
    testWidgetModel<HomeWidgetModel, HomeWidget>(
      'loads tasks on init and exposes them via tasksState',
      makeWm,
      (wm, tester, context) async {
        when(() => mockGetTasks()).thenAnswer((_) async => [sampleTask]);
        tester.init();
        await Future(() {});

        final state = wm.tasksState.value;
        expect(state.isLoadingState, isFalse);
        expect(state.data, hasLength(1));
        expect(state.data!.first.title, 'Test task');
      },
    );

    testWidgetModel<HomeWidgetModel, HomeWidget>(
      'addTask calls model and reloads list',
      makeWm,
      (wm, tester, context) async {
        when(() => mockGetTasks()).thenAnswer((_) async => []);
        when(() => mockAddTask(any())).thenAnswer((_) async => {});
        tester.init();

        await wm.addTask(title: 'New task', description: '');
        verify(() => mockAddTask(any())).called(1);
      },
    );

    testWidgetModel<HomeWidgetModel, HomeWidget>(
      'deleteTask calls model and reloads list',
      makeWm,
      (wm, tester, context) async {
        when(() => mockGetTasks()).thenAnswer((_) async => [sampleTask]);
        when(() => mockDeleteTask(any())).thenAnswer((_) async => {});
        tester.init();

        await wm.deleteTask('1');
        verify(() => mockDeleteTask('1')).called(1);
      },
    );
  });
}
