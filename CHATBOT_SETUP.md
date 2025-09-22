# Chatbot Setup Guide

## Overview
Your Choghel app now includes a powerful AI chatbot that supports both Mistral AI and Hugging Face models. The chatbot can help users with questions about workspaces, reservations, and general inquiries.

## Features
- 🤖 **Mistral AI Integration** - High-quality conversational AI
- 🧠 **Hugging Face Support** - Alternative free models
- 🔄 **Provider Switching** - Switch between AI providers on the fly
- 💬 **Conversation Memory** - Maintains context throughout the chat
- ⚡ **Real-time Responses** - Fast, streaming-like experience
- 🎨 **Beautiful UI** - Modern, responsive chat interface

## Setup Instructions

### Option 1: Mistral AI (Recommended)
1. **Get a free API key:**
   - Visit [Mistral AI Console](https://console.mistral.ai/)
   - Create a free account
   - Generate an API key

2. **Configure the app:**
   - Open `lib/config/api_config.dart`
   - Replace `null` with your API key:
   ```dart
   static const String? MISTRAL_API_KEY = 'your-api-key-here';
   ```

3. **Benefits:**
   - Higher rate limits
   - Better response quality
   - More reliable service

### Option 2: Hugging Face (Free, No API Key Required)
1. **No setup required** - works out of the box
2. **Optional:** Get a token for higher limits:
   - Visit [Hugging Face Settings](https://huggingface.co/settings/tokens)
   - Create a token
   - Add it to `api_config.dart`

## Usage

### Switching Providers
- Tap the settings icon (⚙️) in the chat screen
- Select between "Mistral AI" or "Hugging Face"
- The change takes effect immediately

### Available Models

#### Mistral AI Models:
- `mistral-tiny` - Free tier, fast responses
- `mistral-small` - Paid tier, better quality
- `mistral-medium` - Paid tier, high quality
- `mistral-large` - Paid tier, best quality

#### Hugging Face Models:
- `microsoft/DialoGPT-medium` - Conversational AI
- `facebook/blenderbot-400M-distill` - Chatbot model
- `microsoft/DialoGPT-small` - Lightweight option

## Configuration

### Changing Models
To use different models, edit `lib/config/api_config.dart`:

```dart
// For Mistral
static const String DEFAULT_MISTRAL_MODEL = 'mistral-small';

// For Hugging Face
static const String DEFAULT_HUGGING_FACE_MODEL = 'facebook/blenderbot-400M-distill';
```

### Customizing Responses
The system prompt can be modified in `lib/services/llm_service.dart`:

```dart
messages.add({
  'role': 'system',
  'content': 'Your custom system prompt here...'
});
```

## Troubleshooting

### Common Issues:

1. **"API Key missing" error:**
   - Ensure your API key is correctly set in `api_config.dart`
   - Check that the key is valid and active

2. **Rate limit exceeded:**
   - Wait a few minutes before trying again
   - Consider upgrading to a paid plan for higher limits

3. **Slow responses:**
   - Mistral AI is generally faster than Hugging Face
   - Check your internet connection
   - Try switching providers

4. **Poor response quality:**
   - Try switching to a different model
   - Mistral models generally provide better quality
   - Ensure your system prompt is clear

### Error Messages:
- **"Clé API Mistral manquante"** - Mistral API key not configured
- **"Limite de taux atteinte"** - Rate limit exceeded
- **"Modèle en cours de chargement"** - Model is loading (Hugging Face)

## Development

### Adding New Providers:
1. Create a new method in `LLMService`
2. Add provider to `getAvailableProviders()`
3. Update the UI in `chatbot.dart`

### Testing:
```bash
flutter pub get
flutter run
```

## Support
For issues or questions:
1. Check the console logs for detailed error messages
2. Verify your API keys are correct
3. Test with different providers/models
4. Check your internet connection

## Cost Information
- **Mistral AI**: Free tier available, paid plans for higher usage
- **Hugging Face**: Completely free for basic usage
- **Data Usage**: Minimal - only text is sent to APIs

Enjoy your new AI-powered chatbot! 🚀
