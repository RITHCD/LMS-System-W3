class Course {
  final String id;
  final String name;
  final List<String> studentIds = [];

  Course({required this.id, required this.name});

  bool hasStudent(String studentId){
    return studentIds.contains(studentId);
  }

  
}
