import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });




  //test add remove course
  test('adds and removes a course', () {
  final lms = LmsSystem();
  lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
  expect(lms.courses.length, 1);

  lms.removeCourse(courseId: 'C1');
  expect(lms.courses.length, 0);
});


  test('rejects duplicate course id', () {
  final lms = LmsSystem();
  lms.addCourse(courseId: 'C1', courseName: 'A');
  expect(() => lms.addCourse(courseId: 'C1', courseName: 'B'), throwsException);
});

test('rejects removal of nonexistent course', () {
  final lms = LmsSystem();
  expect(() => lms.removeCourse(courseId: 'C9'), throwsException);
});

//!test enrolll

test('enrolls and rejects invalid enrollments', () {
  final lms = LmsSystem();
  lms.addStudent(studentId: 'S1', studentName: 'Ronan');
  lms.addCourse(courseId: 'C1', courseName: 'Mobile');

  lms.enrollStudent(studentId: 'S1', courseId: 'C1');
  expect(lms.courses.first.studentIds, contains('S1'));

  expect(() => lms.enrollStudent(studentId: 'S9', courseId: 'C1'), throwsException);
  expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C9'), throwsException);
  expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C1'), throwsException);
});

  //!test remove student
  test('discard removes enrollment and results, keeps student and course', () {
  final lms = LmsSystem();
  lms.addStudent(studentId: 'S1', studentName: 'Ronan');
  lms.addCourse(courseId: 'C1', courseName: 'Mobile');
  lms.enrollStudent(studentId: 'S1', courseId: 'C1');
  lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');

  expect(lms.courses.first.studentIds, isEmpty);
  expect(lms.results, isEmpty);
  expect(lms.students.length, 1);   
  expect(lms.courses.length, 1);    
});

//test add result
test('addResult valid and invalid cases', () {
  final lms = LmsSystem();
  lms.addStudent(studentId: 'S1', studentName: 'Ronan');
  lms.addCourse(courseId: 'C1', courseName: 'Mobile');

  expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 80), throwsException);

  lms.enrollStudent(studentId: 'S1', courseId: 'C1');
  expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 101), throwsException);
  expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: -1), throwsException);
  expect(() => lms.addResult(studentId: 'S9', courseId: 'C1', score: 50), throwsException);

  lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);
  expect(lms.results.length, 1);


  expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 90), throwsException);
});

//test remove
test('removeResult removes only that result', () {
  final lms = LmsSystem();
  lms.addStudent(studentId: 'S1', studentName: 'Ronan');
  lms.addStudent(studentId: 'S2', studentName: 'Sokha');
  lms.addCourse(courseId: 'C1', courseName: 'Mobile');
  lms.enrollStudent(studentId: 'S1', courseId: 'C1');
  lms.enrollStudent(studentId: 'S2', courseId: 'C1');
  final r1 = lms.addResult(studentId: 'S1', courseId: 'C1', score: 80);
  lms.addResult(studentId: 'S2', courseId: 'C1', score: 75);

  lms.removeResult(resultId: r1);

  expect(lms.results.length, 1);
  expect(lms.results.first.studentId, 'S2');
  expect(lms.students.length, 2);
  expect(() => lms.removeResult(resultId: 'R99'), throwsException);
});

 }
