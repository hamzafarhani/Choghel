import 'package:flutter/material.dart';
import '../services/llm_service.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<String> _conversationHistory = [];
  String _currentProvider = 'mistral';

  @override
  void initState() {
    super.initState();
    _currentProvider = LLMService.getCurrentProvider();
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Bonjour! Je suis votre assistant virtuel pour l'application Choghel. Je peux vous aider avec des questions sur les espaces de travail, les réservations, et bien plus encore. Comment puis-je vous aider aujourd'hui?",
          isUser: false,
        ));
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    String userMessage = text.trim();
    _messageController.clear();
    
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
      ));
      _conversationHistory.add(userMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Get response from LLM API
      String botResponse = await LLMService.generateResponse(userMessage, _conversationHistory);
      
      setState(() {
        _messages.add(ChatMessage(
          text: botResponse,
          isUser: false,
        ));
        _conversationHistory.add(botResponse);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Désolé, je rencontre des difficultés techniques. Pouvez-vous réessayer?",
          isUser: false,
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistant Virtuel'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings, color: Colors.white),
            onSelected: (String provider) {
              setState(() {
                _currentProvider = provider;
                LLMService.setProvider(provider);
              });
            },
            itemBuilder: (BuildContext context) {
              return LLMService.getAvailableProviders().map((String provider) {
                return PopupMenuItem<String>(
                  value: provider,
                  child: Row(
                    children: [
                      Icon(
                        provider == 'mistral' ? Icons.psychology : Icons.auto_awesome,
                        color: provider == _currentProvider ? Colors.blue[900] : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        provider == 'mistral' ? 'Mistral AI' : 'Hugging Face',
                        style: TextStyle(
                          color: provider == _currentProvider ? Colors.blue[900] : Colors.black,
                          fontWeight: provider == _currentProvider ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (provider == _currentProvider)
                        Icon(Icons.check, color: Colors.blue[900], size: 16),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Provider indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(
                  _currentProvider == 'mistral' ? Icons.psychology : Icons.auto_awesome,
                  color: Colors.blue[900],
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Powered by ${_currentProvider == 'mistral' ? 'Mistral AI' : 'Hugging Face'}',
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(8.0),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return _buildLoadingMessage();
                  }
                  return _messages[index];
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _messageController,
              onSubmitted: _isLoading ? null : _handleSubmitted,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: _isLoading ? 'Assistant en train de répondre...' : 'Envoyer un message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: _isLoading ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900]!),
                ),
              ) : Icon(Icons.send),
              color: _isLoading ? Colors.grey : Colors.blue[900],
              onPressed: _isLoading ? null : () => _handleSubmitted(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue[900],
              child: Icon(Icons.assistant, color: Colors.white),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900]!),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Assistant en train de réfléchir...',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue[900],
                child: Icon(Icons.assistant, color: Colors.white),
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue[900] : Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16.0,
              ),
            ),
          ),
          if (isUser)
            Container(
              margin: EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.blue[900]),
              ),
            ),
        ],
      ),
    );
  }
}


