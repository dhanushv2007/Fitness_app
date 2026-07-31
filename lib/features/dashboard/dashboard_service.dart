import '../profile/profile_model.dart';
import '../profile/profile_service.dart';

class DashboardService {
  final ProfileService _profileService = ProfileService();

  Future<UserProfile?> getUserProfile() async {
    return await _profileService.getProfile();
  }
}