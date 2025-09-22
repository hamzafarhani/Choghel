// API Configuration for LLM Services
// 
// To use Mistral AI with higher rate limits:
// 1. Go to https://console.mistral.ai/
// 2. Create an account and get your API key
// 3. Replace the null value below with your API key
// 4. Uncomment the line in llm_service.dart

// To use Hugging Face with higher rate limits:
// 1. Go to https://huggingface.co/settings/tokens
// 2. Create a token
// 3. Replace the null value below with your token
// 4. Uncomment the line in llm_service.dart

class APIConfig {
  // Mistral AI API Key
  // Get your free API key from: https://console.mistral.ai/
  static const String? MISTRAL_API_KEY = null;
  
  // Hugging Face API Token
  // Get your free token from: https://huggingface.co/settings/tokens
  static const String? HUGGING_FACE_TOKEN = null;
  
  // Available Mistral models (in order of capability and cost)
  static const List<String> MISTRAL_MODELS = [
    'mistral-tiny',    // Free tier - fastest, basic responses
    'mistral-small',   // Paid tier - better quality
    'mistral-medium',  // Paid tier - high quality
    'mistral-large',   // Paid tier - best quality
  ];
  
  // Available Hugging Face models for conversation
  static const List<String> HUGGING_FACE_MODELS = [
    'microsoft/DialoGPT-medium',
    'facebook/blenderbot-400M-distill',
    'microsoft/DialoGPT-small',
  ];
  
  // Default settings
  static const String DEFAULT_PROVIDER = 'mistral';
  static const String DEFAULT_MISTRAL_MODEL = 'mistral-tiny';
  static const String DEFAULT_HUGGING_FACE_MODEL = 'microsoft/DialoGPT-medium';
}
