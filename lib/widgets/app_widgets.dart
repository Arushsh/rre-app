import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/app_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Background with refined #64FFDA teal / #8892B0 slate glow orbs on #0A192F canvas
// ─────────────────────────────────────────────────────────────────────────────
class CosmicBackground extends StatelessWidget {
  const CosmicBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.background),

        // Top-left — #64FFDA teal halo
        Positioned(
          top: -100,
          left: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.teal.withValues(alpha: 0.22),
                  AppColors.tealLight.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Center-right — #8892B0 slate/ice glow
        Positioned(
          top: 280,
          right: -90,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.slate.withValues(alpha: 0.18),
                  AppColors.iceWhite.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom-left — subtle teal undertone
        Positioned(
          bottom: 40,
          left: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.teal.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Glass Card
// ─────────────────────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // #172A45 elevated surface
              color: backgroundColor ?? AppColors.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? AppColors.teal.withValues(alpha: 0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.06),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Glass Icon Button
// ─────────────────────────────────────────────────────────────────────────────
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.teal.withValues(alpha: 0.25),
            ),
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor ?? AppColors.teal, size: 20),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Gradient Pill Button  (#64FFDA → deep mint teal, #0A192F label for high contrast)
// ─────────────────────────────────────────────────────────────────────────────
class GradientPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final List<Color>? gradientColors;
  final double height;
  final double fontSize;
  final bool isLoading;

  const GradientPillButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.gradientColors,
    this.height = 54,
    this.fontSize = 14,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? AppColors.primaryGradient;
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(colors: colors),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.38),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isLoading ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Color(0xFF0A192F), strokeWidth: 2.5),
                ),
                const SizedBox(width: 10),
              ] else if (icon != null) ...[
                Icon(icon, color: const Color(0xFF0A192F), size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                isLoading ? 'PROCESSING...' : label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0A192F),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Glass Chip Filter
// ─────────────────────────────────────────────────────────────────────────────
class GlassChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const GlassChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.teal.withValues(alpha: 0.18)
              : AppColors.surface.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.teal
                : AppColors.teal.withValues(alpha: 0.2),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  color: isSelected ? AppColors.teal : AppColors.slate,
                  size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.teal : AppColors.slateLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Search Bar
// ─────────────────────────────────────────────────────────────────────────────
class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search events, artists, services...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.teal.withValues(alpha: 0.22),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.iceWhite, fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          icon: const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(Icons.search_rounded,
                color: AppColors.teal, size: 20),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
              color: AppColors.slate, fontSize: 13),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.tune_rounded,
                color: AppColors.teal.withValues(alpha: 0.7), size: 18),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Banner Slider Card
// ─────────────────────────────────────────────────────────────────────────────
class BannerSliderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final VoidCallback onTap;

  const BannerSliderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      borderColor: AppColors.teal.withValues(alpha: 0.35),
      backgroundColor: AppColors.surface.withValues(alpha: 0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.teal.withValues(alpha: 0.15),
              border: Border.all(
                  color: AppColors.teal.withValues(alpha: 0.5)),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.teal,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.iceWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.slate),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 130,
              child: GradientPillButton(
                label: 'BOOK NOW',
                icon: Icons.arrow_forward_rounded,
                onPressed: onTap,
                height: 36,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Event Card
// ─────────────────────────────────────────────────────────────────────────────
class EventCardWidget extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    AppColors.teal.withValues(alpha: 0.18),
                    AppColors.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.event_seat_outlined,
                        color: AppColors.teal.withValues(alpha: 0.45),
                        size: 40),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GlassChip(label: event.category),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.iceWhite,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: AppColors.teal.withValues(alpha: 0.6),
                    size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppColors.slate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.priceRange,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teal,
                  ),
                ),
                Icon(Icons.photo_library_outlined,
                    color: AppColors.slate.withValues(alpha: 0.7), size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Artist Card
// ─────────────────────────────────────────────────────────────────────────────
class ArtistCardWidget extends StatelessWidget {
  final ArtistModel artist;
  final VoidCallback onTap;

  const ArtistCardWidget({
    super.key,
    required this.artist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        borderRadius: 20,
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                border: Border.all(
                    color: AppColors.teal.withValues(alpha: 0.6),
                    width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Color(0xFF0A192F), size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.iceWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${artist.category} • ${artist.location}',
                    style: const TextStyle(fontSize: 12, color: AppColors.slate),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.teal, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${artist.rating}  (${artist.reviewCount} reviews)',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.teal.withValues(alpha: 0.7), size: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Glassmorphic Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.space_dashboard_outlined, 'activeIcon': Icons.space_dashboard_rounded, 'label': 'Home'},
      {'icon': Icons.event_available_outlined, 'activeIcon': Icons.event_available_rounded, 'label': 'Events'},
      {'icon': Icons.qr_code_scanner_rounded, 'activeIcon': Icons.qr_code_scanner_rounded, 'label': 'AI Scan'},
      {'icon': Icons.star_outline_rounded, 'activeIcon': Icons.star_rounded, 'label': 'Artists'},
      {'icon': Icons.person_outline_rounded, 'activeIcon': Icons.person_rounded, 'label': 'Profile'},
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.teal.withValues(alpha: 0.25),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              final item = items[index];
              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.teal.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: isSelected
                        ? Border.all(
                            color: AppColors.teal.withValues(alpha: 0.5),
                            width: 1.2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? (item['activeIcon'] as IconData)
                            : (item['icon'] as IconData),
                        color: isSelected
                            ? AppColors.teal
                            : AppColors.slate,
                        size: 20,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.teal,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
