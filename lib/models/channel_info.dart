import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChannelsInfo {
  final String title;
  final String description;
  final String thumbnailUrl;
  final String subscriberCount;
  final String videoCount;

  ChannelsInfo({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.subscriberCount,
    required this.videoCount,
  });

  factory ChannelsInfo.fromJson(Map<String, dynamic> json) {
    return ChannelsInfo(
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      thumbnailUrl: json['snippet']['thumbnails']['default']['url'],
      subscriberCount: json['statistics']['subscriberCount'],
      videoCount: json['statistics']['videoCount'],
    );
  }
}

Future<String> searchChannel(String apiKey, String channelName) async {
  final url =
      'https://www.googleapis.com/youtube/v3/search?part=snippet&type=channel&q=$channelName&key=$apiKey';
  print('Request URL: $url');

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    if (json['items'].isNotEmpty) {
      return json['items'][0]['id']['channelId'];
    } else {
      print('No channels found for the search term.');
      throw Exception('Channel not found');
    }
  } else {
    print('Failed to search for channel. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to search for channel');
  }
}

Future<ChannelsInfo> fetchChannelInfo(String apiKey, String channelId) async {
  final url =
      'https://www.googleapis.com/youtube/v3/channels?part=snippet,statistics&id=$channelId&key=$apiKey';
  print('Request URL: $url');

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return ChannelsInfo.fromJson(json['items'][0]);
  } else {
    print(
        'Failed to load channel information. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load channel information');
  }
}
