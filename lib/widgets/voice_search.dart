import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceSearchModal extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const VoiceSearchModal({
    Key? key,
    required this.searchController,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<VoiceSearchModal> createState() => _VoiceSearchModalState();
}

class _VoiceSearchModalState extends State<VoiceSearchModal> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        print("Speech status: $status");
        if (status == 'done') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) => print("Speech error: $error"),
    );

    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
    }
  }

  void _startListening() async {
    if (!_isListening && _isInitialized) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            if (result.finalResult) {
              widget.searchController.text = _text;
              widget.onSearch(_text);
              // Add a small delay before popping to ensure the search is processed
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.pop(context);
              });
            }
          });
        },
      );
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _text.isEmpty ? 'Tap to speak' : _text,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          AvatarGlow(
            animate: _isListening,
            glowColor: Theme.of(context).primaryColor,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            child: GestureDetector(
              onTapDown: (_) => _startListening(),
              onTapUp: (_) => _stopListening(),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}