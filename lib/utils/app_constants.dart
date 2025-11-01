class AppConstants {
  static final Roles roles = Roles();
  static final ApprovalStatus approvalStatus = ApprovalStatus();
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
