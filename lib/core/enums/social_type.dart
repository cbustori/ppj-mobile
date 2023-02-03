enum SocialType { GOOGLE, FACEBOOK, LOCAL }

class SocialTypeHelper {
  static SocialType getValue(String type) {
    switch (type) {
      case "GOOGLE":
        return SocialType.GOOGLE;
      case "FACEBOOK":
        return SocialType.FACEBOOK;
      default:
        return SocialType.LOCAL;
    }
  }

  static String getValueToString(SocialType type) {
    switch (type) {
      case SocialType.GOOGLE:
        return "google";
      case SocialType.FACEBOOK:
        return "facebook";
      default:
        return 'local';
    }
  }
}
