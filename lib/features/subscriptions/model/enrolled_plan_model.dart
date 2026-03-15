class EnrolledPlanModel {
  final String? message;
  final List<EnrolledPlanData>? data;

  EnrolledPlanModel({
    this.message,
    this.data,
  });

  factory EnrolledPlanModel.fromJson(Map<String, dynamic> json) {
    return EnrolledPlanModel(
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => EnrolledPlanData.fromJson(e))
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

class EnrolledPlanData {
  final int? id;
  final String? title;
  final Plan? plan;
  final int? transactionId;
  final String? subscribedAt;
  final String? startsAt;
  final String? endsAt;
  final bool? status;
  final List<int>? courseIds;

  EnrolledPlanData({
    this.id,
    this.title,
    this.plan,
    this.transactionId,
    this.subscribedAt,
    this.startsAt,
    this.endsAt,
    this.status,
    this.courseIds,
  });

  factory EnrolledPlanData.fromJson(Map<String, dynamic> json) {
    return EnrolledPlanData(
      id: json['id'],
      title: json['title'],
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
      transactionId: json['transaction_id'],
      subscribedAt: json['subscribed_at'],
      startsAt: json['starts_at'],
      endsAt: json['ends_at'],
      status: json['status'],
      courseIds: (json['course_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'plan': plan?.toJson(),
      'transaction_id': transactionId,
      'subscribed_at': subscribedAt,
      'starts_at': startsAt,
      'ends_at': endsAt,
      'status': status,
      'course_ids': courseIds,
    };
  }
}

class Plan {
  final int? id;
  final String? title;
  final String? planType;
  final String? courseLimit;
  final String? duration;
  final String? price;
  final String? features;
  final String? description;
  final int? isActive;
  final int? isFeatured;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Plan({
    this.id,
    this.title,
    this.planType,
    this.courseLimit,
    this.duration,
    this.price,
    this.features,
    this.description,
    this.isActive,
    this.isFeatured,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      title: json['title'],
      planType: json['plan_type'],
      courseLimit: json['course_limit'],
      duration: json['duration'],
      price: json['price'],
      features: json['features'],
      description: json['description'],
      isActive: json['is_active'],
      isFeatured: json['is_featured'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'plan_type': planType,
      'course_limit': courseLimit,
      'duration': duration,
      'price': price,
      'features': features,
      'description': description,
      'is_active': isActive,
      'is_featured': isFeatured,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
