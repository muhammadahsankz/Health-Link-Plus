class AppConstants {
  static final Roles roles = Roles();
  static final ApprovalStatus approvalStatus = ApprovalStatus();
  static final AppointmentStatus appointmentStatus = AppointmentStatus();
}

class Roles {
  final String admin = "Admin";
  final String doctor = "Doctor";
  final String patient = "Patient";
}

class ApprovalStatus {
  final String pending = "Pending";
  final String approved = "Approved";
}

class AppointmentStatus {
  final String pending = "Pending";
  final String approved = "Accepted";
  final String rejected = "Rejected";
  final String completed = "Completed";
}
