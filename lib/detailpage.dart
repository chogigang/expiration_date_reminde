import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:expiration_date/data/database.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:expiration_date/module/local_push_notification.dart';
import 'package:expiration_date/module/notification.dart';
import 'package:expiration_date/recipepage.dart';

class DetailPage extends StatefulWidget {
  final FooddbData foodItem;

  const DetailPage({Key? key, required this.foodItem}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    listenNotifications();
    super.initState();
  }

  void listenNotifications() {
    LocalPushNotifications.notificationStream.stream.listen((String? payload) {
      if (payload != null) {
        print('Received payload: $payload');
        Navigator.pushNamed(context, '/message', arguments: payload);
      }
    });
  }

  Future<void> _showRecipes(BuildContext context, String searchQuery) async {
    final apiKey = '856346fdbba3479482aa';
    final url = Uri.parse(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/COOKRCP01/json/1/5/RCP_NM=$searchQuery');
    try {
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('JSON Response: $jsonResponse');

        final recipes = jsonResponse['COOKRCP01']?['row'];

        if (recipes != null && recipes is List) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(
                  initialRecipes: recipes, initialSearchQuery: searchQuery),
            ),
          );
        } else {
          print('No recipes found');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No recipes found')),
          );
        }
      } else {
        print('Failed to load recipes');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load recipes')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching recipes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodItem.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () => FlutterLocalNotification.showNotification(),
              child: const Text("Send Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                LocalPushNotifications.showSimpleNotification(
                    title: "Regular Notification Title",
                    body: "Regular Notification Body",
                    payload: "Regular Notification Data");
              },
              child: const Text('Regular Notification'),
            ),
            if (widget.foodItem.image_data != null)
              Image.memory(widget.foodItem.image_data!),
            if (widget.foodItem.image_url != null &&
                widget.foodItem.image_url!.isNotEmpty)
              Image.network(widget.foodItem.image_url!),
            const SizedBox(height: 10),
            Text(
              'Food Name: ${widget.foodItem.name}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Expiry Date: ${widget.foodItem.expiry_date.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Type: ${widget.foodItem.type}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Alarm Cycle: ${widget.foodItem.alarm_cycle ?? 'Not set'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Registration Date: ${widget.foodItem.createdAt.toIso8601String().split('T')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showRecipes(context, widget.foodItem.name),
              child: const Text('View Recipes'),
            ),
          ],
        ),
      ),
    );
  }
}
