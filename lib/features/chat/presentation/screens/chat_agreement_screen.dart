import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';

/// Customer-Labour Chat & Scope Agreement screen faithfully following Stitch design `13ffa801c24942c28a43aa4c30a1642a`.
class ChatAgreementScreen extends ConsumerStatefulWidget {
  final String? workerName;
  final String? bookingCode;
  final int? totalAmount;

  const ChatAgreementScreen({
    super.key,
    this.workerName,
    this.bookingCode,
    this.totalAmount,
  });

  @override
  ConsumerState<ChatAgreementScreen> createState() => _ChatAgreementScreenState();
}

class _ChatAgreementScreenState extends ConsumerState<ChatAgreementScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'worker',
      'name': 'রফিকুল ইসলাম',
      'nameEn': 'Rafiqul Islam',
      'time': '২:১৮ PM',
      'timeEn': '2:18 PM',
      'text': 'আসসালামু আলাইকুম স্যার। আমি ৩টার মধ্যে মিরপুর ১০ এ পৌঁছাব। প্রয়োজনীয় তার ও টেস্টার সাথে আছে।',
      'textEn': 'Assalamu Alaikum sir. I will arrive at Mirpur 10 by 3:00 PM. I have necessary wires and testers with me.',
    },
    {
      'sender': 'customer',
      'name': 'আপনি',
      'nameEn': 'You',
      'time': '২:২২ PM',
      'timeEn': '2:22 PM',
      'text': 'ওয়ালাইকুম আসসালাম। মেইন সুইচের পাশের ফ্যান রেগুলেটরটাও একটু চেক করে দিয়েন।',
      'textEn': 'Walaikum Assalam. Please also check the fan regulator next to the main switch.',
    },
    {
      'sender': 'agreement', // Digital Agreement Card
    },
    {
      'sender': 'worker',
      'name': 'রফিকুল ইসলাম',
      'nameEn': 'Rafiqul Islam',
      'time': '২:২৫ PM',
      'timeEn': '2:25 PM',
      'text': 'অবশ্যই স্যার, রেগুলেটর ফ্রি চেক করে ঠিক করে দেব। আমি রওয়ানা হয়েছি।',
      'textEn': 'Certainly sir, I will check and fix the regulator without extra charge. I am on the way.',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showPreviewOnlySnackBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.previewOnlyMessage),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.onSurface,
      ),
    );
  }

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    final isBangla = Localizations.localeOf(context).languageCode == 'bn';
    setState(() {
      _messages.add({
        'sender': 'customer',
        'name': isBangla ? 'আপনি' : 'You',
        'nameEn': 'You',
        'time': isBangla ? 'এখন' : 'Just now',
        'timeEn': 'Just now',
        'text': text,
        'textEn': text,
      });
    });

    if (presetText == null) {
      _messageController.clear();
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';

    final effectiveWorkerName = widget.workerName ?? (isBangla ? 'রফিকুল ইসলাম' : 'Rafiqul Islam');
    final effectiveBookingCode = widget.bookingCode ?? 'KL-849204';
    final effectiveAmount = widget.totalAmount ?? 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.directChatTitle,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: LanguageTogglePill(),
          ),
          SizedBox(width: 8),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.person, size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Worker Sub-Header Bar (pinned at top)
          _buildWorkerHeaderBar(
            isBangla: isBangla,
            workerName: effectiveWorkerName,
          ),

          // 2. Scrollable Chat Stream (includes Booking Context, Notice, Messages, Agreement)
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + 2, // +2 for context card and security notice
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildBookingContextCard(
                      isBangla: isBangla,
                      l10n: l10n,
                      bookingCode: effectiveBookingCode,
                      totalAmount: effectiveAmount,
                    ),
                  );
                }

                if (index == 1) {
                  return Column(
                    children: [
                      _buildSecurityNotice(l10n),
                      const SizedBox(height: 12),
                      _buildTimestampDivider(isBangla ? 'আজ, দুপুর ২:১৫' : 'Today, 2:15 PM'),
                      const SizedBox(height: 12),
                    ],
                  );
                }

                final item = _messages[index - 2];
                final sender = item['sender'] as String;

                if (sender == 'agreement') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildDigitalAgreementCard(
                      isBangla: isBangla,
                      l10n: l10n,
                      totalAmount: effectiveAmount,
                    ),
                  );
                }

                final isCustomer = sender == 'customer';
                final messageText = isBangla ? item['text'] as String : (item['textEn'] ?? item['text']) as String;
                final senderName = isBangla ? item['name'] as String : (item['nameEn'] ?? item['name']) as String;
                final messageTime = isBangla ? item['time'] as String : (item['timeEn'] ?? item['time']) as String;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMessageBubble(
                    isCustomer: isCustomer,
                    senderName: senderName,
                    time: messageTime,
                    text: messageText,
                  ),
                );
              },
            ),
          ),

          // 3. Quick Actions & Text Input Bar
          _buildBottomInputArea(l10n: l10n, isBangla: isBangla),
        ],
      ),
    );
  }

  Widget _buildWorkerHeaderBar({
    required bool isBangla,
    required String workerName,
  }) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.outline,
                child: Icon(Icons.person, size: 24, color: AppColors.onSurfaceVariant),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(1.5),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified, size: 11, color: AppColors.onSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      workerName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedChipBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isBangla ? 'NID ভেরিফাইড' : 'NID Verified',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.verifiedChipText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      isBangla ? 'ইলেকট্রিশিয়ান' : 'Electrician',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Wrap(
                      spacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(Icons.star, size: 12, color: AppColors.tertiary),
                        Text(
                          isBangla ? '৪.৯ (১২৪+)' : '4.9 (124+)',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: AppColors.secondary, size: 20),
            onPressed: () => _showPreviewOnlySnackBar(context),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  isBangla ? 'লাইভ বুকিং' : 'Live Booking',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingContextCard({
    required bool isBangla,
    required AppLocalizations l10n,
    required String bookingCode,
    required int totalAmount,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.bookingCodeLabel(bookingCode),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.outline.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.confirmedStatus,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isBangla ? 'সিলিং ফ্যান ও সুইচ বোর্ড মেরামত' : 'Ceiling Fan & Switch Board Repair',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isBangla
                        ? '৳${NumberFormatter.toBengaliDigits(totalAmount)}'
                        : '৳$totalAmount',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    l10n.totalRateHourly(isBangla ? NumberFormatter.toBengaliDigits(350) : '350'),
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 9.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  const Icon(Icons.schedule, size: 14, color: AppColors.primary),
                  Text(
                    isBangla ? 'আজ ৩:০০ PM - ৫:০০ PM' : 'Today 3:00 PM - 5:00 PM',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                  ),
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  const Icon(Icons.location_on, size: 14, color: AppColors.secondary),
                  Text(
                    isBangla ? 'মিরপুর ১০, ঢাকা' : 'Mirpur 10, Dhaka',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${l10n.safetyNoticeTitle}: ${l10n.safetyNoticeDesc}',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestampDivider(String label) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.outline.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required bool isCustomer,
    required String senderName,
    required String time,
    required String text,
  }) {
    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Column(
          crossAxisAlignment: isCustomer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                '$senderName • $time',
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 9.5,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isCustomer ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isCustomer ? 16 : 4),
                  bottomRight: Radius.circular(isCustomer ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isCustomer ? AppColors.onPrimary : AppColors.onSurface,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
            if (isCustomer)
              Padding(
                padding: const EdgeInsets.only(top: 2, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.done_all, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 2),
                    Text(
                      'পঠিত',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 9.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalAgreementCard({
    required bool isBangla,
    required AppLocalizations l10n,
    required int totalAmount,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.handshake, size: 18, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.digitalAgreementTitle.toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 9.5,
                              color: AppColors.textMuted,
                              letterSpacing: 0.6,
                            ),
                          ),
                          Text(
                            l10n.scopeConfirmationSubtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.agreedBadge,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildAgreementRow(
            icon: Icons.timelapse,
            iconColor: AppColors.primary,
            label: l10n.workDurationLabel,
            value: isBangla ? '২ ঘণ্টা (৩:০০ PM - ৫:০০ PM)' : '2 hrs (3:00 PM - 5:00 PM)',
          ),
          const SizedBox(height: 6),
          _buildAgreementRow(
            icon: Icons.coffee,
            iconColor: AppColors.tertiary,
            label: l10n.breakAndPerksLabel,
            value: isBangla ? '১৫ মিনিট চা বিরতি' : '15 min tea break',
          ),
          const SizedBox(height: 6),
          _buildAgreementRow(
            icon: Icons.payments,
            iconColor: AppColors.secondary,
            label: l10n.totalRemunerationLabel,
            value: isBangla
                ? '৳${NumberFormatter.toBengaliDigits(totalAmount)}'
                : '৳$totalAmount',
            subValue: l10n.noHiddenCharges,
          ),
          const Divider(height: 18, color: AppColors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.lock, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        l10n.securedByKaajlagbe,
                        style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showPreviewOnlySnackBar(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.viewFullTerms,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    String? subValue,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subValue != null)
                  Text(
                    subValue,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 9,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputArea({
    required AppLocalizations l10n,
    required bool isBangla,
  }) {
    final quickChips = [
      {'icon': Icons.more_time, 'color': AppColors.primary, 'text': l10n.quickExtendDuration},
      {'icon': Icons.inventory_2, 'color': AppColors.tertiary, 'text': l10n.quickMaterialsCost},
      {'icon': Icons.pin_drop, 'color': AppColors.secondary, 'text': l10n.quickShareAddress},
      {'icon': Icons.add_a_photo, 'color': AppColors.primary, 'text': l10n.quickSendPhoto},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick reply chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: quickChips.map((chip) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => _sendMessage(chip['text'] as String),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.outline.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(chip['icon'] as IconData, size: 14, color: chip['color'] as Color),
                            const SizedBox(width: 4),
                            Text(
                              chip['text'] as String,
                              style: AppTextStyles.labelSmall.copyWith(
                                fontSize: 11,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Text input line
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file, size: 20, color: AppColors.textMuted),
                          onPressed: () => _showPreviewOnlySnackBar(context),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: AppTextStyles.bodyMedium,
                            decoration: InputDecoration(
                              hintText: l10n.typeMessagePlaceholder,
                              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.mic, size: 20, color: AppColors.textMuted),
                          onPressed: () => _showPreviewOnlySnackBar(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  key: const Key('chat_send_btn'),
                  onTap: () => _sendMessage(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, size: 20, color: AppColors.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
