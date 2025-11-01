import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_link_plus/services/api_services.dart';
import 'package:health_link_plus/utils/app_urls.dart';

class AdminHomeController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) => selectedIndex.value = index;

  var pendingUsers = <Map<String, dynamic>>[].obs;
  var approvedUsers = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingUsers();
    fetchApprovedUsers();
  }

  // Fetch pending users
  Future<void> fetchPendingUsers() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        url: AppUrls.getPendingUsersList,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List fetchedUsersList = List.from(data['users'] ?? []);
        pendingUsers.value = fetchedUsersList
            .map(
              (u) => {
                'id': u['_id'] ?? 'N/A',
                'name': u['name'] ?? 'N/A',
                'email': u['email'] ?? 'N/A',
                'role': u['role'] ?? 'N/A',
                'approvalStatus': u['approvalStatus'] ?? 'N/A',
              },
            )
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching pending users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch approved users
  Future<void> fetchApprovedUsers() async {
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(
        url: AppUrls.getApprovedUsersList,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List fetchedUsersList = List.from(data['users'] ?? []);
        approvedUsers.value = fetchedUsersList
            .map(
              (u) => {
                'id': u['_id'] ?? 'N/A',
                'name': u['name'] ?? 'N/A',
                'email': u['email'] ?? 'N/A',
                'role': u['role'] ?? 'N/A',
                'approvalStatus': u['approvalStatus'] ?? 'N/A',
              },
            )
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching approved users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Approve user API call
  Future<void> approveUser(String userId) async {
    try {
      isLoading.value = true;
      final response = await ApiServices.postRequest(
        url: AppUrls.approveUser,
        payload: {"userId": userId},
      );

      if (response.statusCode == 200) {
        // Refresh lists after approval
        await fetchPendingUsers();
        await fetchApprovedUsers();
      } else {
        debugPrint("Failed to approve user: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error approving user: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
