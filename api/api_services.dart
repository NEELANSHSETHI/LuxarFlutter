//import 'dart:async';
//import 'package:http/http.dart' as http;
//import 'dart:io';
//
//String token = '';
//String HOST_URL = '';
//String PHP_HOST_URL = '';
//
//Future<Bookings> getKeylessBookingsHistory(int count, int pageNo) async{
//
//  getKeys();
//  HOST_URL = apiKeysMap["baseUrl"];
//  print(HOST_URL);
//  String endpoint = 'mytrip2';
//  String url = "${HOST_URL}/api/app/$endpoint?count=$count&page=$pageNo";
//
//
//  try{
//
//    final response = await http.get(url,
//      headers: {
//        HttpHeaders.contentTypeHeader: 'application/json',
////        'AppToken': APP_TOKEN,
//        'token': '$token'
//      },
//    );
//    print(response.statusCode.toString() + "-mytrip PAGENO : $pageNo $token");
////    return bookingsFromJson(response.body);
//  }
//  catch(e){
//    print('EXCEPTION: $e');
//    return null;
//  }
//}
//
//Future<HourlyRentals> getBookingsHourlyRentals() async{
//  PHP_HOST_URL = apiKeysMap["legacyBaseUrl"];
//  PHP_HOST_URL = PHP_HOST_URL.trim();
//  String endpoint = '/api/me/booking-history-new';
//  String url = "${PHP_HOST_URL}$endpoint?limit=10&page=1";
//  url = url.trim();
//  print('URL PHP : $url');
//  readApiKeys();
//  try{
//    final response = await http.get(url,
//      headers: {
//        HttpHeaders.contentTypeHeader : 'application/json;charset=UTF-8',
//        HttpHeaders.acceptCharsetHeader : 'utf-8',
//        'AppToken': APP_TOKEN,
//        'Authorization': 'Bearer $token'
//      },
//    );
//    print(response.statusCode.toString() + "hourlyRental");
//    return hourlyRentalsFromJson(response.body);
//  }catch(e){
//    print('EXCEPTION: $e');
//    return null;
//  }
//}
//
//Future<FuelReceipt> getFuelReceipt(int bookingId) async{
//  HOST_URL = apiKeysMap["baseUrl"];
//  String endpoint = 'get_fuel_receipts';
//  String url = "${HOST_URL}/api/app/$endpoint?booking_id=$bookingId";
//  print(url);
//  readApiKeys();
//  final response = await http.get(url,
//    headers: {
//      HttpHeaders.contentTypeHeader : 'application/json',
//      'AppToken': APP_TOKEN,
//      'token': '$token'
//    },
//  );
//  print(response.statusCode.toString() + "fuelreceipt");
//  return fuelReceiptFromJson(response.body);
//}