class AppUrls {
  // static const String baseUrl = 'http://127.0.0.1:3000/api/';
  static const String baseUrl =
      'https://health-link-plus-backend.vercel.app/api/';
  // static const String baseUrl = 'http://192.168.62.234:3000/api/';

  static const String signup = '${baseUrl}users/signup';
  static const String login = '${baseUrl}users/login';
  static const String sendOtp = '${baseUrl}otp/send';
  static const String verifyOtp = '${baseUrl}otp/verify';
  static const String getPendingUsersList =
      '${baseUrl}users/get-pending-users-list';
  static const String getApprovedUsersList =
      '${baseUrl}users/get-approved-users-list';
  static const String approveUser = '${baseUrl}users/approve-user';
  static const String getDoctorsList = '${baseUrl}users/get-doctors-list';
  static const String getPatientsList = '${baseUrl}users/get-patients-list';
  static const String completeDoctorProfile =
      "${baseUrl}doctor/complete-doctor-profile";
  static const String getDoctorProfile = "${baseUrl}doctor/get-doctor-profile";
  static const String getClinicData = "${baseUrl}doctor/get-clinic-data";
  static const String saveClinicData = "${baseUrl}doctor/save-clinic-data";
  static const String getAllDoctorsListForPatient =
      "${baseUrl}patient/get-all-doctors-list-for-patient";
  static const String requestAnAppointment =
      "${baseUrl}patient/request-an-appointment";
  static const String getPatientAppointmentsList =
      "${baseUrl}patient/get-patient-appointments";
  static const String getDoctorAppointmentsList =
      "${baseUrl}doctor/get-doctor-appointments";
  static const String acceptAppointment = "${baseUrl}doctor/accept-appointment";
  static const String createMeeting = '${baseUrl}zoom/create';
  static const String generateSignature = '${baseUrl}zoom/signature';
  static const String getMeetingDetails =
      '${baseUrl}patient/get-meeting-details';
}
