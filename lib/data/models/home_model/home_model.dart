import '../api_response_model.dart';

/// `GET /client/home` → `data` payload.
class HomeModel extends Serializable {
  String? bookingId;
  String? znCode;
  String? status;
  String? clientName;
  String? packageName;
  int? partySize;
  int? guests;
  String? arrivalDate;
  String? departureDate;
  int? daysLeft;
  bool? isVip;
  HomeBalance? balance;
  List<TodayProgramItem> todayProgram;
  HomeDriver? driver;
  HomeAssignment? assignment;

  HomeModel({
    this.bookingId,
    this.znCode,
    this.status,
    this.clientName,
    this.packageName,
    this.partySize,
    this.guests,
    this.arrivalDate,
    this.departureDate,
    this.daysLeft,
    this.isVip,
    this.balance,
    this.todayProgram = const [],
    this.driver,
    this.assignment,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        bookingId: json['bookingId']?.toString(),
        znCode: json['znCode']?.toString(),
        status: json['status']?.toString(),
        clientName: json['clientName']?.toString(),
        packageName: json['packageName']?.toString(),
        partySize: _asInt(json['partySize']),
        guests: _asInt(json['guests']),
        arrivalDate: json['arrivalDate']?.toString(),
        departureDate: json['departureDate']?.toString(),
        daysLeft: _asInt(json['daysLeft']),
        isVip: json['isVip'] == true,
        balance: json['balance'] is Map<String, dynamic>
            ? HomeBalance.fromJson(json['balance'] as Map<String, dynamic>)
            : null,
        todayProgram: json['todayProgram'] is List
            ? (json['todayProgram'] as List)
                .whereType<Map>()
                .map(
                  (e) => TodayProgramItem.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
            : const [],
        driver: json['driver'] is Map<String, dynamic>
            ? HomeDriver.fromJson(json['driver'] as Map<String, dynamic>)
            : null,
        assignment: json['assignment'] is Map<String, dynamic>
            ? HomeAssignment.fromJson(
                json['assignment'] as Map<String, dynamic>,
              )
            : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'znCode': znCode,
        'status': status,
        'clientName': clientName,
        'packageName': packageName,
        'partySize': partySize,
        'guests': guests,
        'arrivalDate': arrivalDate,
        'departureDate': departureDate,
        'daysLeft': daysLeft,
        'isVip': isVip,
        'balance': balance?.toJson(),
        'todayProgram': todayProgram.map((e) => e.toJson()).toList(),
        'driver': driver?.toJson(),
        'assignment': assignment?.toJson(),
      };

  int get displayGuests => guests ?? partySize ?? 0;

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class HomeBalance extends Serializable {
  num? total;
  num? paid;
  num? due;

  HomeBalance({this.total, this.paid, this.due});

  factory HomeBalance.fromJson(Map<String, dynamic> json) => HomeBalance(
        total: _asNum(json['total']),
        paid: _asNum(json['paid']),
        due: _asNum(json['due']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'total': total,
        'paid': paid,
        'due': due,
      };

  static num? _asNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }
}

class TodayProgramItem extends Serializable {
  String? id;
  String? bookingId;
  int? dayNumber;
  String? itemDate;
  String? startTime;
  String? title;
  String? description;
  String? locationName;
  num? lat;
  num? lng;
  String? status;
  int? sortOrder;

  TodayProgramItem({
    this.id,
    this.bookingId,
    this.dayNumber,
    this.itemDate,
    this.startTime,
    this.title,
    this.description,
    this.locationName,
    this.lat,
    this.lng,
    this.status,
    this.sortOrder,
  });

  factory TodayProgramItem.fromJson(Map<String, dynamic> json) =>
      TodayProgramItem(
        id: json['id']?.toString(),
        bookingId: json['bookingId']?.toString(),
        dayNumber: HomeModel._asInt(json['dayNumber']),
        itemDate: json['itemDate']?.toString(),
        startTime: json['startTime']?.toString(),
        title: json['title']?.toString(),
        description: json['description']?.toString(),
        locationName: json['locationName']?.toString() ??
            json['location']?.toString() ??
            json['place']?.toString(),
        lat: json['lat'] is num
            ? json['lat'] as num
            : num.tryParse(json['lat']?.toString() ?? ''),
        lng: json['lng'] is num
            ? json['lng'] as num
            : num.tryParse(json['lng']?.toString() ?? ''),
        status: json['status']?.toString(),
        sortOrder: HomeModel._asInt(json['sortOrder']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingId': bookingId,
        'dayNumber': dayNumber,
        'itemDate': itemDate,
        'startTime': startTime,
        'title': title,
        'description': description,
        'locationName': locationName,
        'lat': lat,
        'lng': lng,
        'status': status,
        'sortOrder': sortOrder,
      };

  String get displayTime {
    final raw = startTime?.trim() ?? '';
    if (raw.isEmpty) return '';
    // "HH:mm:ss" → "HH:mm"
    if (raw.length >= 5) return raw.substring(0, 5);
    return raw;
  }
}

class HomeDriver extends Serializable {
  String? name;
  String? phone;
  String? vehicle;

  HomeDriver({this.name, this.phone, this.vehicle});

  factory HomeDriver.fromJson(Map<String, dynamic> json) => HomeDriver(
        name: json['name']?.toString(),
        phone: json['phone']?.toString(),
        vehicle: json['vehicle']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'vehicle': vehicle,
      };
}

class HomeAssignment extends Serializable {
  String? id;
  String? status;

  HomeAssignment({this.id, this.status});

  factory HomeAssignment.fromJson(Map<String, dynamic> json) => HomeAssignment(
        id: json['id']?.toString(),
        status: json['status']?.toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
      };
}
