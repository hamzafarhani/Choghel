import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class LLMService {
  // Hugging Face Inference API - free tier available
  static const String _huggingFaceBaseUrl = 'https://api-inference.huggingface.co/models';
  static const String _huggingFaceModel = APIConfig.DEFAULT_HUGGING_FACE_MODEL;
  static const String? _huggingFaceApiToken = APIConfig.HUGGING_FACE_TOKEN;
  
  // Mistral AI API - free tier available
  static const String _mistralBaseUrl = 'https://api.mistral.ai/v1';
  static const String _mistralModel = APIConfig.DEFAULT_MISTRAL_MODEL;
  static const String? _mistralApiKey = APIConfig.MISTRAL_API_KEY;
  
  // Current provider (can be 'huggingface' or 'mistral')
  static String _currentProvider = APIConfig.DEFAULT_PROVIDER;
  
  static Future<String> generateResponse(String userMessage, List<String> conversationHistory) async {
    if (_currentProvider == 'mistral') {
      return await _generateWithMistral(userMessage, conversationHistory);
    } else {
      return await _generateWithHuggingFace(userMessage, conversationHistory);
    }
  }
  
  // Mistral AI implementation
  static Future<String> _generateWithMistral(String userMessage, List<String> conversationHistory) async {
    try {
      // Prepare headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (_mistralApiKey != null) {
        headers['Authorization'] = 'Bearer $_mistralApiKey';
      }
      
      // Build conversation messages for Mistral
      List<Map<String, String>> messages = [];
      
      // Add system message
      messages.add({
        'role': 'system',
        'content': 'Tu es un assistant virtuel pour l\'application Choghel, une plateforme de réservation d\'espaces de travail. Tu peux aider les utilisateurs avec des questions sur les espaces de travail, les réservations, les catégories, et tout ce qui concerne l\'application. Réponds toujours en français de manière utile et amicale.'
      });
      
      // Add conversation history
      for (int i = 0; i < conversationHistory.length; i += 2) {
        if (i < conversationHistory.length) {
          messages.add({
            'role': 'user',
            'content': conversationHistory[i]
          });
        }
        if (i + 1 < conversationHistory.length) {
          messages.add({
            'role': 'assistant',
            'content': conversationHistory[i + 1]
          });
        }
      }
      
      // Add current user message
      messages.add({
        'role': 'user',
        'content': userMessage
      });
      
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'model': _mistralModel,
        'messages': messages,
        'max_tokens': 200,
        'temperature': 0.7,
        'stream': false,
      };
      
      // Make the API request
      final response = await http.post(
        Uri.parse('$_mistralBaseUrl/chat/completions'),
        headers: headers,
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['choices'] != null && responseData['choices'].isNotEmpty) {
          String generatedText = responseData['choices'][0]['message']['content'] ?? '';
          return _cleanResponse(generatedText);
        } else {
          return "Désolé, je n'ai pas pu générer de réponse. Pouvez-vous reformuler votre question?";
        }
      } else if (response.statusCode == 401) {
        return "Clé API Mistral manquante ou invalide. Veuillez configurer votre clé API.";
      } else if (response.statusCode == 429) {
        return "Limite de taux atteinte. Veuillez patienter avant de réessayer.";
      } else {
        print('Mistral API Error: ${response.statusCode} - ${response.body}');
        return "Désolé, une erreur s'est produite avec Mistral. Veuillez réessayer.";
      }
    } catch (e) {
      print('Mistral Service Error: $e');
      return "Désolé, je rencontre des difficultés techniques avec Mistral. Pouvez-vous réessayer?";
    }
  }
  
  // Hugging Face implementation (existing code)
  static Future<String> _generateWithHuggingFace(String userMessage, List<String> conversationHistory) async {
    try {
      // Prepare the conversation context
      String context = _buildContext(conversationHistory);
      String fullPrompt = context + userMessage;
      
      // Prepare headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (_huggingFaceApiToken != null) {
        headers['Authorization'] = 'Bearer $_huggingFaceApiToken';
      }
      
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'inputs': fullPrompt,
        'parameters': {
          'max_length': 150,
          'temperature': 0.7,
          'do_sample': true,
          'return_full_text': false,
        }
      };
      
      // Make the API request
      final response = await http.post(
        Uri.parse('$_huggingFaceBaseUrl/$_huggingFaceModel'),
        headers: headers,
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData is List && responseData.isNotEmpty) {
          String generatedText = responseData[0]['generated_text'] ?? '';
          
          // Clean up the response
          return _cleanResponse(generatedText);
        } else {
          return "Désolé, je n'ai pas pu générer de réponse. Pouvez-vous reformuler votre question?";
        }
      } else if (response.statusCode == 503) {
        // Model is loading
        return "Le modèle est en cours de chargement. Veuillez patienter quelques instants et réessayez.";
      } else {
        print('Hugging Face API Error: ${response.statusCode} - ${response.body}');
        return "Désolé, une erreur s'est produite. Veuillez réessayer.";
      }
    } catch (e) {
      print('Hugging Face Service Error: $e');
      return "Désolé, je rencontre des difficultés techniques. Pouvez-vous réessayer?";
    }
  }
  
  static String _buildContext(List<String> conversationHistory) {
    if (conversationHistory.isEmpty) {
      return "Human: Bonjour! Je suis votre assistant virtuel pour l'application Choghel. Comment puis-je vous aider aujourd'hui?\n";
    }
    
    String context = "";
    for (int i = 0; i < conversationHistory.length; i++) {
      if (i % 2 == 0) {
        context += "Human: ${conversationHistory[i]}\n";
      } else {
        context += "Assistant: ${conversationHistory[i]}\n";
      }
    }
    return context;
  }
  
  static String _cleanResponse(String response) {
    // Remove any unwanted prefixes or suffixes
    response = response.trim();
    
    // Remove "Assistant:" prefix if present
    if (response.startsWith('Assistant:')) {
      response = response.substring(10).trim();
    }
    
    // Remove "Human:" prefix if present (shouldn't happen but just in case)
    if (response.startsWith('Human:')) {
      response = response.substring(6).trim();
    }
    
    // If response is empty or too short, provide a fallback
    if (response.isEmpty || response.length < 3) {
      return "Je comprends votre message. Pouvez-vous me donner plus de détails?";
    }
    
    return response;
  }
  
  // Provider management methods
  static void setProvider(String provider) {
    if (provider == 'mistral' || provider == 'huggingface') {
      _currentProvider = provider;
    }
  }
  
  static String getCurrentProvider() {
    return _currentProvider;
  }
  
  static List<String> getAvailableProviders() {
    return ['mistral', 'huggingface'];
  }
  
  static List<String> getAvailableMistralModels() {
    return ['mistral-tiny', 'mistral-small', 'mistral-medium', 'mistral-large'];
  }
  
  static void setMistralModel(String model) {
    if (getAvailableMistralModels().contains(model)) {
      // Note: This would require making the model variable mutable
      // For now, you can manually change the _mistralModel constant
    }
  }
  
  // Alternative method using a different free model
  static Future<String> generateResponseWithBlenderbot(String userMessage) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      
      if (_huggingFaceApiToken != null) {
        headers['Authorization'] = 'Bearer $_huggingFaceApiToken';
      }
      
      Map<String, dynamic> requestBody = {
        'inputs': {
          'text': userMessage,
          'past_user_inputs': [],
          'generated_responses': [],
        }
      };
      
      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill'),
        headers: headers,
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['generated_text'] ?? "Je n'ai pas pu générer de réponse appropriée.";
      } else {
        return "Désolé, une erreur s'est produite. Veuillez réessayer.";
      }
    } catch (e) {
      print('Blenderbot Error: $e');
      return "Désolé, je rencontre des difficultés techniques. Pouvez-vous réessayer?";
    }
  }
}
