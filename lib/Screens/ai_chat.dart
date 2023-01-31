import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String apiKey = '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';
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        title: const Text('Chat with AI'),
        automaticallyImplyLeading: true,
        flexibleSpace: isLoaded
            ? null
            : const LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    //textfield for api key
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your API key',
                          ),
                          onChanged: (value) {
                            apiKey = value;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: ListView.separated(
                    reverse: true,
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: _messages[index].startsWith('AI')
                                ? const LinearGradient(
                                    colors: [Colors.amber, Colors.deepPurple],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)
                                : const LinearGradient(
                                    colors: [Colors.blue, Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                            color: Colors.grey[900]),
                        child: ListTile(
                          title: Text(
                            _messages[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            const Divider(height: 40.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: (s) => _handleSubmitted(_textController.text, apiKey),
              decoration:
                  const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text, apiKey),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text, String apiKey) async {
    setState(() {
      isLoaded = false;
    });

    _messages.insert(0, 'You: $text');
    _scrollDown();
    aiRequest(_textController.text, apiKey).then((value) => setState(() {
          isLoaded = true;
          _messages.insert(0, 'AI: ${value.trim()}');
          _scrollDown();
        }));
    _textController.clear();
    _scrollDown();

    setState(() {});
  }

  void _scrollDown() {
    // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
  }

// Create a completion request
  Future<String> aiRequest(String text, String apiKey) async {
    String endpoint = 'https://api.openai.com/v1/completions';
    var key = apiKey;
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(endpoint));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer $key');

    String payload = jsonEncode({
      'prompt': text,
      "model": "text-davinci-003",
      'max_tokens': 200,
      "temperature": 0.7,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0
    });
    request.add(utf8.encode(payload));
    HttpClientResponse response = await request.close();
    httpClient.close();
    String responseBody = await response.transform(utf8.decoder).join();
    print(responseBody);
    final decoded = jsonDecode(responseBody);

    return decoded['choices'][0]['text'];
  }
}
