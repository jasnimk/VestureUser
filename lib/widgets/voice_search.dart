// // import 'package:flutter/material.dart';
// // import 'package:avatar_glow/avatar_glow.dart';
// // import 'package:speech_to_text/speech_to_text.dart' as stt;

// // class VoiceSearchModal extends StatefulWidget {
// //   final Function(String) onSearchComplete;

// //   const VoiceSearchModal({Key? key, required this.onSearchComplete})
// //       : super(key: key);

// //   @override
// //   State<VoiceSearchModal> createState() => _VoiceSearchModalState();
// // }

// // class _VoiceSearchModalState extends State<VoiceSearchModal> {
// //   final stt.SpeechToText _speech = stt.SpeechToText();
// //   bool _isListening = false;
// //   String _text = '';

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initSpeech();
// //   }

// //   void _initSpeech() async {
// //     _isListening = await _speech.initialize(
// //       onStatus: (status) {
// //         if (status == 'done') {
// //           setState(() => _isListening = false);
// //           if (_text.isNotEmpty) {
// //             widget.onSearchComplete(_text);
// //             Navigator.pop(context);
// //           }
// //         }
// //       },
// //     );
// //     setState(() {});
// //   }

// //   void _startListening() async {
// //     if (!_isListening) {
// //       _text = '';
// //       setState(() => _isListening = true);
// //       _speech.listen(
// //         onResult: (result) {
// //           setState(() => _text = result.recognizedWords);
// //         },
// //       );
// //     }
// //   }

// //   void _stopListening() {
// //     _speech.stop();
// //     setState(() => _isListening = false);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: MediaQuery.of(context).size.width,
// //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).scaffoldBackgroundColor,
// //         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(
// //             _text.isEmpty ? 'Tap the microphone to start' : _text,
// //             textAlign: TextAlign.center,
// //             style: const TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           AvatarGlow(
// //             animate: _isListening,
// //             // endRadius: 75,
// //             glowColor: Theme.of(context).primaryColor,
// //             duration: const Duration(milliseconds: 2000),
// //             //repeatPauseDuration: const Duration(milliseconds: 100),
// //             repeat: true,
// //             child: GestureDetector(
// //               onTapDown: (_) => _startListening(),
// //               onTapUp: (_) => _stopListening(),
// //               child: CircleAvatar(
// //                 radius: 35,
// //                 backgroundColor: Theme.of(context).primaryColor,
// //                 child: Icon(
// //                   _isListening ? Icons.mic : Icons.mic_none,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _speech.stop();
// //     super.dispose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class VoiceSearchModal extends StatefulWidget {
//   final Function(String) onSearchComplete;
//   final String? initialPrompt;

//   const VoiceSearchModal({
//     Key? key,
//     required this.onSearchComplete,
//     this.initialPrompt,
//   }) : super(key: key);

//   @override
//   State<VoiceSearchModal> createState() => _VoiceSearchModalState();
// }

// class _VoiceSearchModalState extends State<VoiceSearchModal> {
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   bool _isListening = false;
//   String _text = '';
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   void _initSpeech() async {
//     try {
//       _isInitialized = await _speech.initialize(
//         onStatus: (status) {
//           if (status == 'done') {
//             setState(() => _isListening = false);
//             _handleSearchComplete();
//           }
//         },
//         onError: (error) {
//           print('Speech recognition error: $error');
//           setState(() => _isListening = false);
//           _showError('Failed to recognize speech. Please try again.');
//         },
//       );
//       setState(() {});
//     } catch (e) {
//       print('Speech initialization error: $e');
//       _showError('Failed to initialize speech recognition.');
//     }
//   }

//   void _handleSearchComplete() {
//     if (_text.isNotEmpty) {
//       widget.onSearchComplete(_text);
//       Navigator.pop(context);
//     } else {
//       _showError('No speech detected. Please try again.');
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _startListening() async {
//     if (!_isInitialized) {
//       _showError('Speech recognition not initialized. Please try again.');
//       return;
//     }

//     if (!_isListening) {
//       _text = '';
//       setState(() => _isListening = true);
//       try {
//         await _speech.listen(
//           onResult: (result) {
//             setState(() => _text = result.recognizedWords);
//           },
//           cancelOnError: true,
//           listenMode: stt.ListenMode.confirmation,
//         );
//       } catch (e) {
//         print('Listen error: $e');
//         setState(() => _isListening = false);
//         _showError('Failed to start listening. Please try again.');
//       }
//     }
//   }

//   void _stopListening() {
//     if (_isListening) {
//       _speech.stop();
//       setState(() => _isListening = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             _text.isEmpty
//                 ? (widget.initialPrompt ??
//                     'Tap and hold the microphone to speak')
//                 : _text,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 20),
//           AvatarGlow(
//             animate: _isListening,
//             glowColor: Theme.of(context).primaryColor,
//             duration: const Duration(milliseconds: 2000),
//             repeat: true,
//             child: GestureDetector(
//               onTapDown: (_) => _startListening(),
//               onTapUp: (_) => _stopListening(),
//               onTapCancel: _stopListening,
//               child: CircleAvatar(
//                 radius: 35,
//                 backgroundColor: Theme.of(context).primaryColor,
//                 child: Icon(
//                   _isListening ? Icons.mic : Icons.mic_none,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _speech.stop();
//     super.dispose();
//   }
// }
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

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print("Speech status: $status");
        if (status == 'done') {
          setState(() => _isListening = false);
          if (_text.isNotEmpty) {
            widget.searchController.text = _text;
            widget.onSearch(_text);
            Navigator.pop(context);
          }
        }
      },
      onError: (error) => print("Speech error: $error"),
    );

    setState(() {
      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
    });
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
              if (result.finalResult) {
                widget.searchController.text = _text;
                widget.onSearch(_text);
                Navigator.pop(context);
              }
            });
          },
        );
      }
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
