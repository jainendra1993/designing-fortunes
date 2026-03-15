class FeaturedInstructorModel {
  final String? message;
  final Data? data;

  FeaturedInstructorModel({
      this.message,
      this.data,
  });

  factory FeaturedInstructorModel.fromJson(Map<String, dynamic> json) {
    return FeaturedInstructorModel(
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}

class Data {
  final List<Instructor> instructors;
  final int totalItems;

  Data({
    required this.instructors,
    required this.totalItems,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    var instructorsList = <Instructor>[];
    if (json['instructors'] != null) {
      instructorsList = List<Instructor>.from(
        json['instructors'].map((x) => Instructor.fromJson(x)),
      );
    }
    return Data(
      instructors: instructorsList,
      totalItems: json['total_items'] ?? 0,
    );
  }
}

class Instructor {
  final int id;
  final String name;
  final String profilePicture;
  final String title;
  final String? about;
  final int isFeatured;
  final String joiningDate;
  final String averageRating;
  final int reviewsCount;
  final int courseCount;
  final int studentCount;
  final List<dynamic> experiences;
  final List<dynamic> educations;

  Instructor({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.title,
    this.about,
    required this.isFeatured,
    required this.joiningDate,
    required this.averageRating,
    required this.reviewsCount,
    required this.courseCount,
    required this.studentCount,
    required this.experiences,
    required this.educations,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      title: json['title'] ?? '',
      about: json['about'],
      isFeatured: json['is_featured'] ?? 0,
      joiningDate: json['joining_date'] ?? '',
      averageRating: json['average_rating'] ?? '0.0',
      reviewsCount: json['reviews_count'] ?? 0,
      courseCount: json['course_count'] ?? 0,
      studentCount: json['student_count'] ?? 0,
      experiences: json['experiences'] ?? [],
      educations: json['educations'] ?? [],
    );
  }
}
