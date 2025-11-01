import 'package:get/get.dart';

class DoctorHomeController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) => selectedIndex.value = index;

  // Profile data
  var name = ''.obs;
  var specialization = ''.obs;
  var phone = ''.obs;

  // Clinic data
  var clinicName = ''.obs;
  var clinicAddress = ''.obs;
  var clinicTimings = ''.obs;

  // Dummy appointment data
  var appointments = [
    {
      'patient': 'Ali Raza',
      'date': '2025-11-01',
      'time': '11:00 AM',
      'status': 'Pending',
    },
    {
      'patient': 'Sara Khan',
      'date': '2025-11-02',
      'time': '02:00 PM',
      'status': 'Accepted',
    },
  ].obs;

  void acceptAppointment(int index) {
    appointments[index]['status'] = 'Accepted';
    appointments.refresh();
  }
}
