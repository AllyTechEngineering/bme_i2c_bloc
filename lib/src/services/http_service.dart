import 'dart:convert';
import 'dart:io';
import 'package:bme_i2c/src/bloc/repositories/data_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class HttpService {
  HttpServer? _server; // Store server instance for future control

  // "currentTemperature": currentTemperature,
  // "currentHumidity": currentHumidity,
  // "currentPressure": currentPressure,
  // "setpointHumidity": setpointHumidity,
  // "setpointTemperature": setpointTemperature,
  final Map<String, dynamic> _variables = {
    "setpointTemperature": 0.0,
    "setpointHumidity": 0.0,
    "currentTemperature": 0.0,
    "currentHumidity": 0.0,
    "currentPressure": 0.0,
    "fanSpeed": 0,
    "systemOnOff": false,
    "doughLevel": false,
  };

  final DataRepository dataRepository =
      DataRepository(); // Connect DataRepository

  HttpService() {
    debugPrint("HttpService Constructor Called");
    // 🔹 Listen for sensor data updates
    dataRepository.dataStream.listen((sensorData) {
      debugPrint("Received Sensor Data: $sensorData");
      sensorData.forEach((key, value) {
        if (_variables.containsKey(key)) {
          _variables[key] = value; // Update local variables
        }
      });

      debugPrint("Updated Variables from Sensor: $_variables");
    });
  }

  void startServer() async {
    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(_handleRequest);

    // Start the HTTP server
    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);
    debugPrint(
        'Server running on ${_server?.address.address}:${_server?.port}');

    // Advertise the service using Avahi
    advertiseMdnsService();
  }

  void advertiseMdnsService() {
    debugPrint("Advertising service using Avahi...");
    Process.run(
      'avahi-publish-service',
      ['doughproofer', '_http._tcp', '8080'],
    ).then((ProcessResult results) {
      debugPrint("Service advertised: \${results.stdout}");
    }).catchError((e) {
      debugPrint("Failed to advertise service: \$e");
    });
  }

  Future<Response> _handleRequest(Request request) async {
    try {
      if (request.method == "GET") {
        return Response.ok(jsonEncode(_variables),
            headers: {'Content-Type': 'application/json'});
      } else if (request.method == "POST") {
        final payload = await request.readAsString();
        final Map<String, dynamic> data = jsonDecode(payload);

        data.forEach((key, value) {
          if (_variables.containsKey(key)) {
            _variables[key] = value;
          }
        });

        // Send updated data to DataRepository
        dataRepository.updateData(Map<String, dynamic>.from(_variables));

        return Response.ok("Data updated successfully");
      } else {
        return Response.notFound("Unsupported request method");
      }
    } catch (e) {
      return Response.internalServerError(
          body: "Error processing request: \$e");
    }
  }
}
