// Mute unused import warning
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../services/ai_api_service.dart';
import '../../theme/app_theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final bool standalone;
  const ChatScreen({super.key, this.standalone = true});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _aiService = AiApiService();
  bool _isTyping = false;
  final List<_Message> _messages = [];

  static const _suggestions = [
    'ما هو أفضل تخصص لي؟',
    'ما هي فجوات مهاراتي؟',
    'كيف أجد تربص؟',
  ];

  @override
  void initState() {
    super.initState();
    // Seed first AI message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(onboardingProvider);
      final name = (profile.fullName ?? '').split(' ').first;
      final domain = profile.interestDomains.isNotEmpty ? profile.interestDomains.first : 'مجالك';
      final domainAr = {
        'technology': 'التكنولوجيا', 'business': 'الأعمال', 'engineering': 'الهندسة',
        'science': 'العلوم', 'medicine': 'الطب', 'law': 'القانون',
      }[domain] ?? domain;

      setState(() {
        _messages.add(_Message(
          isAi: true,
          text: 'أهلاً ${name.isEmpty ? 'بك' : name} 👋\n\nأنا مسار+، مساعدك الذكي للتوجيه المهني. بناءً على ملفك الشخصي، يبدو أنك مهتم بـ$domainAr — وهذا مجال رائع!\n\nكيف يمكنني مساعدتك اليوم؟',
        ));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _controller.clear();
    setState(() {
      _messages.add(_Message(isAi: false, text: text.trim()));
      _isTyping = true;
    });
    _scrollToBottom();

    // Small delay so typing indicator shows smoothly
    await Future.delayed(const Duration(milliseconds: 300));

    String replyText;
    try {
      // 1. Try real backend
      replyText = await _aiService.sendMessage(text);
    } catch (_) {
      // 2. Fallback to offline mock if Auth fails or backend is unreachable (Render spin down)
      await Future.delayed(const Duration(milliseconds: 1200));
      replyText = _mockReply(text);
    }

    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add(_Message(isAi: true, text: replyText));
    });
    _scrollToBottom();
  }

  String _mockReply(String q) {
    final lq = q.toLowerCase();
    if (lq.contains('تخصص') || lq.contains('شعبة')) {
      return 'بناءً على اهتماماتك وبياناتك الأكاديمية، أنصحك بالنظر في تخصصات هندسة البرمجيات أو إعلام آلي أو علوم البيانات.\n\nهل تريد تفاصيل عن واحد منها؟ 🎯';
    } else if (lq.contains('مهارات') || lq.contains('فجوة')) {
      return 'من أبرز المهارات التي تحتاج تطويرها:\n• Git & GitHub\n• مشاريع عملية\n• اللغة الإنجليزية التقنية\n\nيمكنني اقتراح دورات مجانية لكل واحدة 📚';
    } else if (lq.contains('تربص') || lq.contains('عمل')) {
      return 'للبحث عن تربص في الجزائر:\n1. موقع ANEM\n2. LinkedIn (ابدأ بالشبكة المحلية)\n3. مجموعات Facebook المتخصصة\n\nهل تريد قالب CV احترافي؟ 💼';
    } else {
      return 'سؤال ممتاز! للإجابة بدقة، أحتاج مزيداً من التفاصيل.\n\nيمكنني مساعدتك في:\n• اختيار التخصص المناسب\n• تحديد فجوات مهاراتك\n• إيجاد فرص تربص وعمل\n\nما الذي يشغل تفكيرك أكثر؟ 🤔';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg1 = isDark ? AppColors.background1 : const Color(0xFFF2F5FB);
    final bg2 = isDark ? AppColors.background2 : const Color(0xFFE8EEF8);
    final textPrimary = isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A);
    final textSecondary = isDark ? AppColors.textSecondary : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg1,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [bg1, bg2]),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      if (widget.standalone) ...[
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.glassFill : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: textSecondary, size: 16),
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                      Container(
                        width: 38, height: 38,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.black, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('مسار+ AI', style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                          const Text('متاح الآن', style: TextStyle(color: AppColors.accent, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 12),

                // Messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (_isTyping && i == _messages.length) {
                        return _TypingBubble(isDark: isDark);
                      }
                      return _MessageBubble(message: _messages[i], isDark: isDark);
                    },
                  ),
                ),

                // Suggestion chips
                if (_messages.length <= 2)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: _suggestions.map((s) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => _send(s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.glassFill : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
                              ),
                              child: Text(s, style: TextStyle(color: textSecondary, fontSize: 12)),
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                  ).animate().fadeIn(),

                // Composer
                Container(
                  margin: EdgeInsets.fromLTRB(16, 4, 16, widget.standalone ? 12 : 110),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.glassFill : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black.withAlpha(18)),
                    boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'اكتب سؤالك...',
                            hintStyle: TextStyle(color: textSecondary, fontSize: 14),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: _send,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _send(_controller.text),
                        child: Container(
                          width: 38, height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.black, size: 18),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final bool isAi;
  final String text;
  const _Message({required this.isAi, required this.text});
}

class _MessageBubble extends StatelessWidget {
  final _Message message;
  final bool isDark;
  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isAi = message.isAi;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isAi) ...[
            Container(
              width: 28, height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.black, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isAi
                    ? (isDark ? AppColors.glassFill : Colors.white)
                    : AppColors.accent.withAlpha(isDark ? 50 : 40),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isAi ? 4 : 18),
                  bottomRight: Radius.circular(isAi ? 18 : 4),
                ),
                border: Border.all(
                  color: isAi
                      ? (isDark ? AppColors.glassBorder : Colors.black.withAlpha(15))
                      : AppColors.accent.withAlpha(80),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : const Color(0xFF0A0E1A),
                  fontSize: 14, height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.04, end: 0);
  }
}

class _TypingBubble extends StatefulWidget {
  final bool isDark;
  const _TypingBubble({required this.isDark});

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFF00D68F), Color(0xFF00B87A)]),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.black, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.glassFill : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4), bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: widget.isDark ? AppColors.glassBorder : Colors.black.withAlpha(15)),
            ),
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Row(
                children: List.generate(3, (i) {
                  final delay = i * 0.25;
                  final progress = (_ctrl.value - delay).clamp(0.0, 1.0);
                  final opacity = (progress < 0.5 ? progress * 2 : (1 - progress) * 2).clamp(0.3, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 7, height: 7,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.accent),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}
