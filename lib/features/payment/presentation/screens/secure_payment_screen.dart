import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/language_toggle_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../l10n/app_localizations.dart';

/// Secure Payment (Sandbox) screen faithfully implementing Stitch design `8b253ff604f843e792997a43105b0ed5`.
/// Strictly enforces zero occurrences of the forbidden word (replaced by Secure Payment / ডিজিটাল সুরক্ষা).
class SecurePaymentScreen extends ConsumerStatefulWidget {
  final String? bookingId;
  final String? workerName;
  final int? wageAmount;
  final int? feeAmount;

  const SecurePaymentScreen({
    super.key,
    this.bookingId,
    this.workerName,
    this.wageAmount,
    this.feeAmount,
  });

  @override
  ConsumerState<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends ConsumerState<SecurePaymentScreen> {
  String _selectedMethod = 'bkash';
  bool _termsAccepted = true;

  void _handlePayment(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.securePaymentTitle}: Preview only (Sandbox mode - no real transaction)',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isBangla = Localizations.localeOf(context).languageCode == 'bn';
    final langCode = isBangla ? 'bn' : 'en';

    final bookingId = widget.bookingId ?? '#KL-849204';
    final workerName = widget.workerName ?? (isBangla ? 'রফিকুল ইসলাম' : 'Rafiqul Islam');
    final wage = widget.wageAmount ?? 700;
    final fee = widget.feeAmount ?? 35;
    final total = wage + fee;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.securePaymentTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: LanguageTogglePill(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        key: const Key('secure_payment_scroll_view'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sandbox disclaimer alert banner
            _buildSandboxDisclaimer(l10n),
            const SizedBox(height: 12),

            // Secure Payment Guarantee Shield Banner
            _buildSecurityShieldBanner(isBangla),
            const SizedBox(height: 16),

            // Order Summary Card
            _buildOrderSummaryCard(
              isBangla: isBangla,
              langCode: langCode,
              bookingId: bookingId,
              workerName: workerName,
              wage: wage,
              fee: fee,
              total: total,
            ),
            const SizedBox(height: 16),

            // Payment Methods Selection Section
            _buildPaymentMethodsSection(l10n, isBangla),
            const SizedBox(height: 16),

            // Terms & Conditions Checkbox
            _buildTermsRow(isBangla),
            const SizedBox(height: 20),

            // Bottom Pay Button
            _buildCheckoutButton(context, l10n, isBangla, langCode, total),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSandboxDisclaimer(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.science_rounded, color: AppColors.tertiary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.sandboxNotice,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityShieldBanner(bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          isBangla ? 'কাজলাগবে নিরাপদ পেমেন্ট (স্যান্ডবক্স সিমুলেশন)' : 'KaajLagbe Secure Payment (Sandbox Simulation)',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isBangla ? 'সিমুলেশন' : 'Simulation',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBangla
                          ? 'এই ডেমোতে কোন আসল টাকা জমা বা লেনদেন হয় না। কাজ সম্পন্ন হওয়া সাপেক্ষে সিমুলেটেড পে-আউট যাচাই করুন।'
                          : 'No real money is held or moved in this demo. Experience the simulated payment and payout flow.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTrustStep(
                    Icons.payment_rounded,
                    isBangla ? '১. পেমেন্ট (সিমুলেটেড)' : '1. Pay (simulated)',
                    AppColors.secondary,
                  ),
                ),
                Container(width: 1, height: 24, color: AppColors.divider),
                Expanded(
                  child: _buildTrustStep(
                    Icons.task_alt_rounded,
                    isBangla ? '২. কাজ সম্পন্ন' : '2. Work completed',
                    AppColors.tertiary,
                  ),
                ),
                Container(width: 1, height: 24, color: AppColors.divider),
                Expanded(
                  child: _buildTrustStep(
                    Icons.account_balance_wallet_rounded,
                    isBangla ? '৩. পে-আউট (সিমুলেটেড)' : '3. Payout (simulated)',
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustStep(IconData icon, String title, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryCard({
    required bool isBangla,
    required String langCode,
    required String bookingId,
    required String workerName,
    required int wage,
    required int fee,
    required int total,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Order Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Wrap(
                spacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    isBangla ? 'অর্ডার বিবরণ' : 'Order Summary',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Text(
                      bookingId,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isBangla ? 'অধিবেশন সম্পন্ন' : 'Session Completed',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Worker Mini Card
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workerName,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        isBangla ? 'মাস্টার ইলেকট্রিশিয়ান • ৪.৯ (১২০+ কাজ)' : 'Master Electrician • 4.9 (120+ jobs)',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isBangla ? 'সময়কাল' : 'Duration',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      isBangla ? '২ ঘণ্টা' : '2 Hours',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Line Items
          _buildBillRow(
            isBangla ? 'মূল মজুরি (২ ঘণ্টা নির্ধারিত কাজ)' : 'Base Service Wage (2 Hours)',
            NumberFormatter.formatCurrency(wage, languageCode: langCode),
          ),
          const SizedBox(height: 6),
          _buildBillRow(
            isBangla ? 'প্ল্যাটফর্ম সুরক্ষা ও বীমা ফি (৫%)' : 'Platform Protection & Insurance (5%)',
            NumberFormatter.formatCurrency(fee, languageCode: langCode),
          ),
          const SizedBox(height: 6),
          _buildBillRow(
            isBangla ? '১৫ মিনিট চা বিরতি ফি' : '15m Tea Break Fee',
            isBangla ? '৳০ (বিনামূল্যে)' : '৳0 (Complimentary)',
            isGreen: true,
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          // Total Row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isBangla ? 'সর্বমোট প্রদেয়' : 'Total Payable',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        isBangla ? 'ভ্যাট ও প্ল্যাটফর্ম চার্জ অন্তর্ভুক্ত' : 'VAT & platform charge included',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  NumberFormatter.formatCurrency(total, languageCode: langCode),
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isGreen = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodySmall.copyWith(
              color: isGreen ? AppColors.secondary : AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection(AppLocalizations l10n, bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                l10n.selectPaymentMethod,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Wrap(
                spacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(Icons.lock_rounded, color: AppColors.secondary, size: 14),
                  Text(
                    isBangla ? '২৫৬-বিট এনক্রিপশন' : '256-bit SSL',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Methods list
          _buildMethodTile(
            keyId: 'bkash',
            title: l10n.bkashPayment,
            badge: isBangla ? '৳২৫ ক্যাশব্যাক' : '৳25 Cashback',
            subtitle: isBangla ? 'ইনস্ট্যান্ট সিমুলেটেড ডিপোজিট ও ওটিপি ভেরিফিকেশন' : 'Instant simulated deposit & OTP verification',
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFFD12053),
          ),
          const SizedBox(height: 8),
          _buildMethodTile(
            keyId: 'nagad',
            title: l10n.nagadPayment,
            badge: isBangla ? 'দ্রুত পেমেন্ট' : 'Fast Pay',
            subtitle: isBangla ? 'জিরো কনভেনিয়েন্স চার্জে নিরাপদ ট্রান্সফার' : 'Zero convenience charge transfer',
            icon: Icons.phone_android_rounded,
            iconColor: const Color(0xFFE65100),
          ),
          const SizedBox(height: 8),
          _buildMethodTile(
            keyId: 'card',
            title: l10n.cardPayment,
            badge: null,
            subtitle: isBangla ? 'ভিসা, মাস্টারকার্ড ও ৩ডি-সিকিউর সুরক্ষা' : 'Visa, Mastercard & 3D Secure protection',
            icon: Icons.credit_card_rounded,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: 8),
          _buildMethodTile(
            keyId: 'cash',
            title: l10n.cashOnCompletion,
            badge: null,
            subtitle: isBangla
                ? 'কাজ শতভাগ নিশ্চিত করে ওটিপি দিয়ে কর্মীকে নগদ হস্তান্তর'
                : 'Inspect work and release with OTP before paying cash',
            icon: Icons.payments_rounded,
            iconColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile({
    required String keyId,
    required String title,
    required String? badge,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = _selectedMethod == keyId;

    return InkWell(
      key: Key('payment_method_$keyId'),
      onTap: () {
        setState(() {
          _selectedMethod = keyId;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.15) : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outline),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
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

  Widget _buildTermsRow(bool isBangla) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            key: const Key('terms_checkbox'),
            value: _termsAccepted,
            onChanged: (val) {
              setState(() {
                _termsAccepted = val ?? false;
              });
            },
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isBangla
                  ? 'আমি কাজলাগবে সেবা নীতি ও নিরাপদ পেমেন্ট শর্ত মেনে নিচ্ছি। এই ডেমোতে কোন আসল টাকা জমা বা লেনদেন হয় না।'
                  : 'I agree to the KaajLagbe Service Policy and Secure Payment terms. No real money is held or moved in this demo.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(
    BuildContext context,
    AppLocalizations l10n,
    bool isBangla,
    String langCode,
    int total,
  ) {
    final formattedTotal = NumberFormatter.formatCurrency(total, languageCode: langCode);

    return Column(
      children: [
        Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.shield_rounded, color: AppColors.secondary, size: 14),
            Text(
              isBangla ? 'নিরাপদ পেমেন্ট (স্যান্ডবক্স) • ডেমো মোড' : 'Secure Payment (Sandbox) • Demo Simulation',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          key: const Key('pay_securely_button'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
          onPressed: _termsAccepted ? () => _handlePayment(context, l10n) : null,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  '$formattedTotal ${l10n.paySecurelyCta}',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
