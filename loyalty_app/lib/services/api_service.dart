import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:loyalty_app/models/reward_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../models/wishlist_model.dart';

class ApiService {
  // Replace with your actual API base URL
  static const String baseUrl = 'http://10.0.2.2:3000'; // or your server IP

  // Store the JWT token (you might want to use secure storage in production)
  static String? _authToken;

  // Set the auth token after login
  static void setAuthToken(String token) {
    _authToken = token;
  }

  static void clearAuthToken() {
    _authToken = null;
  }

  // Get auth headers
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // Login method
  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (jsonMap['success']) {
          return LoginResponse.fromJson(jsonMap['data']);
        } else {
          throw Exception(jsonMap['error'] ?? 'Login failed');
        }
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Invalid credentials');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Error during login: $e');
    }
  }

  static Future<int> usePoints(int pointsToUse) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/use-points'),
        headers: _headers,
        body: json.encode({'pointsToUse': pointsToUse}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (jsonMap['success']) {
          // Return updated point balance
          return jsonMap['data']['points'];
        } else {
          throw Exception(jsonMap['error'] ?? 'Failed to use points');
        }
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Insufficient points or bad request');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to use points');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Error using points: $e');
    }
  }


  // Register method
  // static Future<Map<String, dynamic>> register({
  //   required String firstname,
  //   required String lastname,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/register'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'firstname': firstname,
  //         'lastname': lastname,
  //         'email': email,
  //         'password': password,
  //       }),
  //     );
  //
  //     if (response.statusCode == 201) {
  //       final data = json.decode(response.body);
  //       if (data['success']) {
  //         // Store the token
  //         setAuthToken(data['data']['token']);
  //         return data['data'];
  //       } else {
  //         throw Exception(data['error'] ?? 'Registration failed');
  //       }
  //     } else {
  //       final error = json.decode(response.body);
  //       throw Exception(error['error'] ?? 'Registration failed');
  //     }
  //   } catch (e) {
  //     throw Exception('Network error: $e');
  //   }
  // }

  // Fetch all rewards from real database
  static Future<List<Reward>> fetchRewards() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rewards'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (jsonMap['success']) {
          final List<dynamic> jsonList = jsonMap['data'];
          return jsonList.map((e) => Reward.fromJson(e)).toList();
        } else {
          throw Exception(jsonMap['error'] ?? 'Failed to fetch rewards');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to fetch rewards');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Error fetching rewards: $e');
    }
  }

  // Fetch single reward by ID
  static Future<Reward> fetchRewardById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rewards/$id'),
        headers: _headers,
      );


      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (jsonMap['success']) {
          return Reward.fromJson(jsonMap['data']);
        } else {
          throw Exception(jsonMap['error'] ?? 'Failed to fetch reward');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Reward not found');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to fetch reward');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Error fetching reward: $e');
    }
  }

  // Get user profile
  // static Future<User> fetchUserProfile() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/profile'),
  //       headers: _headers,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonMap = json.decode(response.body);
  //
  //       if (jsonMap['success']) {
  //         return jsonMap['data'];
  //       } else {
  //         throw Exception(jsonMap['error'] ?? 'Failed to fetch profile');
  //       }
  //     } else if (response.statusCode == 401) {
  //       throw Exception('Authentication required. Please login again.');
  //     } else {
  //       final error = json.decode(response.body);
  //       throw Exception(error['error'] ?? 'Failed to fetch profile');
  //     }
  //   } catch (e) {
  //     if (e.toString().contains('SocketException')) {
  //       throw Exception('Network error: Unable to connect to server');
  //     }
  //     throw Exception('Error fetching profile: $e');
  //   }
  // }

  static Future<List<Wishlist>> fetchWishlist() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (jsonMap['success']) {
          final List<dynamic> jsonList = jsonMap['data'];
          return jsonList.map((e) => Wishlist.fromJson(e)).toList();
        } else {
          throw Exception(jsonMap['error'] ?? 'Failed to fetch wishlist');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to fetch wishlist');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Error fetching wishlist: $e');
    }
  }

  static Future<Wishlist> addToWishlist(String rewardId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wishlist'),
        headers: _headers,
        body: json.encode({'reward_id': rewardId}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (jsonMap['success']) {
          return Wishlist.fromJson(jsonMap['data']);
        } else {
          throw Exception(jsonMap['error'] ?? 'Failed to add to wishlist');
        }
      } else if (response.statusCode == 400) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Reward already in wishlist');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else if (response.statusCode == 404) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Reward not found');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to add to wishlist');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Error adding to wishlist: $e');
    }
  }

  static Future<void> removeFromWishlist(String rewardId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/wishlist/$rewardId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        if (!jsonMap['success']) {
          throw Exception(jsonMap['error'] ?? 'Failed to remove from wishlist');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else if (response.statusCode == 404) {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Reward not found in wishlist');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to remove from wishlist');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Unable to connect to server');
      }
      throw Exception('Error removing from wishlist: $e');
    }
  }



  // Clear auth token (logout)
  static void logout() {
    _authToken = null;
  }
}

class LoginResponse {
  final String token;
  final User user;

  const LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}