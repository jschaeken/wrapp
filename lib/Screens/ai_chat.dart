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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 123, 93, 0),
      appBar: AppBar(
        title: const Text('Chat with AI'),
        automaticallyImplyLeading: true,
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
              onSubmitted: _handleSubmitted,
              decoration:
                  const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    _messages.insert(0, 'You: $text');
    _scrollDown();
    aiRequest(_textController.text).then((value) => setState(() {
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
  Future<String> aiRequest(String text) async {
    String endpoint = 'https://api.openai.com/v1/completions';
    const key = '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';
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
