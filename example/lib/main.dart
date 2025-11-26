import 'package:flutter/material.dart';
import 'package:flutter_core/core/extensions/string_extensions.dart';
import 'package:flutter_core/core/extensions/double_extensions.dart';
import 'package:flutter_core/core/extensions/duration_utils.dart';
import 'package:flutter_core/core/logic/throttler.dart';
import 'package:flutter_core/core/logic/http_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _throttler = Throttler(const Duration(seconds: 1));
  String _throttleStatus = 'Ready';
  String _networkStatus = 'Idle';

  void _testThrottler() {
    setState(() => _throttleStatus = 'Throttled...');
    _throttler(() {
      setState(() => _throttleStatus = 'Executed!');
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _throttleStatus = 'Ready');
      });
    });
  }

  Future<void> _testNetwork() async {
    setState(() => _networkStatus = 'Fetching...');
    final client = HttpClient();
    // Using a public API for demonstration
    final response = await client.get(
      'https://jsonplaceholder.typicode.com/todos/1',
    );

    if (mounted) {
      setState(() {
        if (response.success) {
          _networkStatus = 'Success: ${response.statusCode}';
        } else {
          _networkStatus = 'Error: ${response.errorType}';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Core Example')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('String Extensions', [
              Text('Original: "hello world"'),
              Text('Capitalized: ${"hello world".toCapitalized()}'),
              const SizedBox(height: 8),
              Text('Original: "1234567890"'),
              Text(
                'Masked: ${"1234567890".masker(true, mask: "*", omit: ["1", "0"])}',
              ),
            ]),
            _buildSection('Double Extensions', [
              Text('Value: 1234.5678'),
              Text('Comma Formatted: ${1234.5678.commaFormattedDecimal}'),
              Text(
                'Minutes to Hours (90m): ${90.0.minutesToHoursDisplayString}',
              ),
            ]),
            _buildSection('Duration Extensions', [
              Text('1000 seconds to DateTime: ${1000.toDateTimeFromSeconds}'),
            ]),
            _buildSection('Throttler Logic', [
              Text('Status: $_throttleStatus'),
              ElevatedButton(
                onPressed: _testThrottler,
                child: const Text('Press me fast! (1s throttle)'),
              ),
            ]),
            _buildSection('Network Logic', [
              Text('Status: $_networkStatus'),
              ElevatedButton(
                onPressed: _testNetwork,
                child: const Text('Test Network Request'),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
