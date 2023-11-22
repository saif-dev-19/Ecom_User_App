const String currencySymbol = "৳";

const cities = ["Dhaka", "Chittagong", "Rajshahi", "Sylhet", "Khulna", "Borishal",];

abstract final class orderStatus {
  static const String pending = "Pending";
  static const String delivered = "Delivered";
  static const String processing = "Processing";
  static const String cancelled = "Cancelled";
}