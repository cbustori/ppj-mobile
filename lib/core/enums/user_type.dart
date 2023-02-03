enum UserType { ADMIN, MANAGER, CONTRIBUTOR, SUBSCRIBER }

class UserTypeHelper {
  static UserType getValue(String role) {
    switch (role) {
      case "ADMIN":
        return UserType.ADMIN;
      case "MANAGER":
        return UserType.MANAGER;
      case "CONTRIBUTOR":
        return UserType.CONTRIBUTOR;
      case "SUBSCRIBER":
        return UserType.SUBSCRIBER;
      default:
        return UserType.SUBSCRIBER;
    }
  }

  static String getValueToString(UserType type) {
    switch (type) {
      case UserType.ADMIN:
        return "ADMIN";
      case UserType.MANAGER:
        return "MANAGER";
      case UserType.CONTRIBUTOR:
        return "CONTRIBUTOR";
      case UserType.SUBSCRIBER:
        return "SUBSCRIBER";
      default:
        return "SUBSCRIBER";
    }
  }
}
