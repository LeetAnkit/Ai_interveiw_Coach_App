import 'package:flutter/material.dart';
import '../../../config/app_config.dart';

class AnswerInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isVoiceMode;
  final bool isListening;

  const AnswerInput({
    super.key,
    required this.controller,
    required this.isVoiceMode,
    required this.isListening,
  });

  @override
  State<AnswerInput> createState() => _AnswerInputState();
}

class _AnswerInputState extends State<AnswerInput> {
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCharacterCount);
    _characterCount = widget.controller.text.length;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCharacterCount);
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = widget.controller.text.length;
    });
  }

  Color get _borderColor {
    if (widget.isListening) {
      return Theme.of(context).colorScheme.primary;
    }
    if (_characterCount < AppConfig.minAnswerLength) {
      return Theme.of(context).colorScheme.outline;
    }
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Answer',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _borderColor,
              width: widget.isListening ? 2 : 1,
            ),
            boxShadow: widget.isListening
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: 8,
            minLines: 6,
            maxLength: AppConfig.maxAnswerLength,
            decoration: InputDecoration(
              hintText: widget.isVoiceMode
                  ? 'Tap the microphone button to start recording...'
                  : 'Type your answer here...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
              suffixIcon: widget.isListening
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : null,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            readOnly: widget.isVoiceMode && widget.isListening,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: ${AppConfig.minAnswerLength} characters',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _characterCount >= AppConfig.minAnswerLength
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
            Text(
              '$_characterCount / ${AppConfig.maxAnswerLength}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _characterCount > AppConfig.maxAnswerLength * 0.9
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        
        if (_characterCount > 0 && _characterCount < AppConfig.minAnswerLength) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Add more details to get better feedback',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}