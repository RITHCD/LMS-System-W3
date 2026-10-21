import '../model/student.dart';
import '../model/course_result.dart';
import '../model/course.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];
  int _resultCounter = 0;


  Student? _findStudentOrNull(String id) {
    for (final s in students) {
      if (s.id == id) return s;
    }
    return null;
  }
  Course? _findCourseOrNull(String id) {
    for (final c in courses) {
      if (c.id == id) return c;
    }
    return null;
  }

  Student _findStudent(String id) {
    final s = _findStudentOrNull(id);
    if (s == null) throw Exception('Student $id not found');
    return s;
  }

  Course _findCourse(String id) {
    final c = _findCourseOrNull(id);
    if (c == null) throw Exception('Course $id not found');
    return c;
  }




 // add course & remove
 void addCourse({
  required String courseId,
  required String courseName,
 }){
  if(_findCourseOrNull(courseId) != null){
    throw Exception('Coures $courseId already exits');
  }
  courses.add(Course(id: courseId, name: courseName));
 }

 void removeCourse({
  required String courseId,
 }){
  final course = _findCourse(courseId);
  if(course.studentIds.isNotEmpty){
    throw Exception('Course $courseId cannot be removed: student enrolled' );
  }
  if(results.any((r) => r.courseId == courseId)) {
    throw Exception('Course $courseId cannot be removed: results recorded');
  }
  courses.remove(course);


  }

  //!enroll a student

  void enrollStudent({
    required String studentId, required String courseId
  }){
    _findStudent(studentId);
    final course = _findCourse(courseId);
    if(course.hasStudent(studentId)){
      throw Exception('Student $studentId already enrolled in $courseId');
    }
      course.studentIds.add(studentId);
  }

  //!remove student from course
  void discardStudentFromCourse(
    {required String studentId, required String courseId}) {
  _findStudent(studentId);
  final course = _findCourse(courseId);

  if (!course.hasStudent(studentId)) {
    throw Exception('Student $studentId is not enrolled in $courseId');
  }
  course.studentIds.remove(studentId);
  results.removeWhere((r) => r.studentId == studentId && r.courseId == courseId);
}


///!add result
String addResult({
  required String studentId,
  required String courseId,
  required int score,
}) {
  _findStudent(studentId);
  final course = _findCourse(courseId);

  if (!course.hasStudent(studentId)) {
    throw Exception('Student $studentId is not enrolled in $courseId');
  }
  if (score < 0 || score > 100) {
    throw Exception('Score $score is invalid (must be 0-100)');
  }
  if (results.any((r) => r.studentId == studentId && r.courseId == courseId)) {
    throw Exception('Result already exists for $studentId in $courseId');
  }

  final id = 'R${++_resultCounter}';
  results.add(CourseResult(
      id: id, studentId: studentId, courseId: courseId, score: score));
  return id;
}

//!remove
void removeResult({required String resultId}) {
  final result = results.where((r) => r.id == resultId).firstOrNull;
  if (result == null) {
    throw Exception('Result $resultId not found');
  }
  results.remove(result);
}




  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
 
  }

  
}
