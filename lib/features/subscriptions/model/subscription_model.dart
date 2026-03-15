class SubscriptionPlanModel {
  final String? message;
  final List<PlanData>? data;

  SubscriptionPlanModel({
    this.message,
    this.data,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PlanData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanData {
  final int? id;
  final String? title;
  final String? planType;
  final String? price;
  final String? duration;
  final String? courseLimit;
  final String? description;
  final List<String>? features;
  final bool? isActive;
  final bool? isFeatured;
  final List<Course>? courses;

  PlanData({
    this.id,
    this.title,
    this.planType,
    this.price,
    this.duration,
    this.courseLimit,
    this.description,
    this.features,
    this.isActive,
    this.isFeatured,
    this.courses,
  });

  factory PlanData.fromJson(Map<String, dynamic> json) {
    return PlanData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      planType: json['plan_type'] as String?,
      price: json['price'] as String?,
      duration: json['duration'] as String?,
      courseLimit: json['course_limit'] as String?,
      description: json['description'] as String?,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isActive: json['is_active'] as bool?,
      isFeatured: json['is_featured'] as bool?,
      courses: (json['courses'] as List<dynamic>?)
          ?.map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'plan_type': planType,
      'price': price,
      'duration': duration,
      'course_limit': courseLimit,
      'description': description,
      'features': features,
      'is_active': isActive,
      'is_featured': isFeatured,
      'courses': courses?.map((e) => e.toJson()).toList(),
    };
  }
}

class Course {
  final int? id;
  final String? title;
  final String? thumbnail;
  final double? price;
  final double? regularPrice;
  final Instructor? instructor;

  Course({
    this.id,
    this.title,
    this.thumbnail,
    this.price,
    this.regularPrice,
    this.instructor,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      title: json['title'] as String?,
      thumbnail: json['thumbnail'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      regularPrice: (json['regular_price'] as num?)?.toDouble(),
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'price': price,
      'regular_price': regularPrice,
      'instructor': instructor?.toJson(),
    };
  }
}

class Instructor {
  final int? id;
  final String? title;
  final User? user;

  Instructor({
    this.id,
    this.title,
    this.user,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] as int?,
      title: json['title'] as String?,
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'user': user?.toJson(),
    };
  }
}

class User {
  final int? id;
  final String? phone;
  final String? email;
  final String? name;
  final String? profilePicture;
  final int? isActive;
  final int? isAdmin;
  final bool? emailVerified;

  User({
    this.id,
    this.phone,
    this.email,
    this.name,
    this.profilePicture,
    this.isActive,
    this.isAdmin,
    this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      profilePicture: json['profile_picture'] as String?,
      isActive: json['is_active'] as int?,
      isAdmin: json['is_admin'] as int?,
      emailVerified: json['email_verified'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'name': name,
      'profile_picture': profilePicture,
      'is_active': isActive,
      'is_admin': isAdmin,
      'email_verified': emailVerified,
    };
  }
}
