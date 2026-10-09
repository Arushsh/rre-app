import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/app_models.dart';
import '../widgets/app_widgets.dart';
import '../services/auth_service.dart';
import '../widgets/security_dashboard_widget.dart';
import 'auth_screen.dart';

// --- GLOBAL AUTHENTICATION STATE & SESSIONS ---
class AuthState {
  static bool isLoggedIn = true;
  static UserModel currentUser = UserModel(
    id: 'usr_101',
    name: 'Arush Sharma',
    email: 'arush@rre.com',
    phone: '+91 98765 43210',
    profilePic: '',
    rewardPoints: 450,
    referralCode: 'RRE-ARUSH-2026',
  );
}

// --- MOCK DATA SOURCE ---
final List<EventModel> mockEvents = [
  EventModel(
    id: 'e1',
    title: 'Amalfi Grand Gala 2026',
    category: 'Wedding',
    location: 'Amalfi Coast, Italy',
    date: '14 Oct 2026',
    imageUrl: '',
    totalPhotos: 142,
    isFeatured: true,
    priceRange: '₹1,50,000+',
  ),
  EventModel(
    id: 'e2',
    title: 'Royal Heritage Reception',
    category: 'Wedding',
    location: 'Udaipur Palace, RJ',
    date: '20 Nov 2026',
    imageUrl: '',
    totalPhotos: 320,
    isFeatured: true,
    priceRange: '₹3,00,000+',
  ),
  EventModel(
    id: 'e3',
    title: 'TechCorp Annual Summit',
    category: 'Corporate',
    location: 'Bangalore, KA',
    date: '05 Dec 2026',
    imageUrl: '',
    totalPhotos: 98,
    isFeatured: false,
    priceRange: '₹80,000+',
  ),
  EventModel(
    id: 'e4',
    title: 'Neon Nights DJ Concert',
    category: 'DJ Event',
    location: 'Goa Beach Resort',
    date: '31 Dec 2026',
    imageUrl: '',
    totalPhotos: 540,
    isFeatured: true,
    priceRange: '₹2,00,000+',
  ),
];

final List<ArtistModel> mockArtists = [
  ArtistModel(
    id: 'a1',
    name: 'DJ RRE Electra',
    category: 'DJ & EDM',
    rating: 4.9,
    reviewCount: 128,
    location: 'Mumbai, MH',
    startingPrice: '₹45,000 / event',
    bio: 'Premier Bollywood & Commercial EDM DJ with 10+ years performing live.',
    tags: ['Bollywood', 'EDM', 'Visual FX'],
  ),
  ArtistModel(
    id: 'a2',
    name: 'Symphony Strings Orchestra',
    category: 'Orchestra',
    rating: 4.8,
    reviewCount: 94,
    location: 'Delhi NCR',
    startingPrice: '₹1,20,000 / event',
    bio: '15-piece live classical & fusion musical orchestra.',
    tags: ['Live Band', 'Violin', 'Fusion'],
  ),
  ArtistModel(
    id: 'a3',
    name: 'Anchor Ananya V.',
    category: 'Anchor / Emcee',
    rating: 5.0,
    reviewCount: 210,
    location: 'Mumbai & International',
    startingPrice: '₹35,000 / event',
    bio: 'Celebrity anchor specialized in high-energy corporate galas & royal weddings.',
    tags: ['Host', 'Multilingual', 'Gala'],
  ),
];

// --- 1. HOME DASHBOARD MODULE ---
class HomeDashboardScreen extends StatelessWidget {
  final Function(int) onNavigateTab;
  final VoidCallback onOpenBooking;

  const HomeDashboardScreen({
    super.key,
    required this.onNavigateTab,
    required this.onOpenBooking,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSearchBar(onChanged: (val) {}),
          const SizedBox(height: 18),
          SizedBox(
            height: 185,
            child: PageView(
              children: [
                BannerSliderCard(
                  tag: 'SPECIAL OFFER 2026',
                  title: 'Grand Wedding & DJ Spectacle',
                  subtitle: 'Book complete sound, stage, and AI photography package with 20% cashback.',
                  onTap: onOpenBooking,
                ),
                BannerSliderCard(
                  tag: 'FEATURED ARTIST',
                  title: 'Symphony Strings Orchestra',
                  subtitle: '15-piece live classical fusion orchestra available for bookings.',
                  onTap: () => onNavigateTab(3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GradientPillButton(
                  label: 'QUICK EVENT BOOKING',
                  icon: Icons.flash_on_rounded,
                  onPressed: onOpenBooking,
                  height: 48,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 10),
              GlassIconButton(
                icon: Icons.qr_code_scanner_rounded,
                onPressed: () => onNavigateTab(2),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Events',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => onNavigateTab(1),
                child: const Text('View All', style: TextStyle(color: AppColors.goldLight, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.82,
            ),
            itemCount: mockEvents.length,
            itemBuilder: (context, index) {
              return EventCardWidget(
                event: mockEvents[index],
                onTap: () => onNavigateTab(1),
              );
            },
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top RRE Artists',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => onNavigateTab(3),
                child: const Text('Explore', style: TextStyle(color: AppColors.goldLight, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockArtists.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return ArtistCardWidget(
                artist: mockArtists[index],
                onTap: () => onNavigateTab(3),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- SCREEN VIEWS ---
class EventsScreenView extends StatelessWidget {
  const EventsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Portfolio & Packages',
            style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore high-end royal weddings, corporate galas, and concert experiences.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockEvents.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return EventCardWidget(
                event: mockEvents[index],
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}

class ScanTabManager extends StatelessWidget {
  const ScanTabManager({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.qr_code_scanner_rounded, color: AppColors.goldPrimary, size: 54),
                const SizedBox(height: 14),
                const Text(
                  'AI Photo Finder & Face Match',
                  style: TextStyle(fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Take a selfie or scan QR code to automatically locate all photos of you across RRE events.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                GradientPillButton(
                  label: 'TAKE SELFIE / SCAN FACE',
                  icon: Icons.camera_alt_rounded,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArtistsScreenView extends StatelessWidget {
  const ArtistsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Artists & Emcees',
            style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Verified celebrity DJs, live bands, anchors, and performers.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockArtists.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return ArtistCardWidget(
                artist: mockArtists[index],
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}

class GalleryScreenView extends StatelessWidget {
  const GalleryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Gallery',
            style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'High-definition captures from recent RRE spectacles.',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: List.generate(4, (index) {
              return GlassCard(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.collections_rounded, color: AppColors.goldPrimary, size: 36),
                    const SizedBox(height: 8),
                    Text('Album #${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AuthScreenModal extends StatelessWidget {
  final VoidCallback onSuccess;

  const AuthScreenModal({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return AuthModalDialog(onSuccess: onSuccess);
  }
}

// --- 3. EVENT BOOKING ENGINE MODAL ---
class EventBookingModal extends StatefulWidget {
  final VoidCallback onCompleted;

  const EventBookingModal({super.key, required this.onCompleted});

  @override
  State<EventBookingModal> createState() => _EventBookingModalState();
}

class _EventBookingModalState extends State<EventBookingModal> {
  int step = 1;
  String selectedType = 'Royal Wedding';
  String budget = '₹1,50,000 - ₹3,00,000';
  DateTime selectedDate = DateTime.now().add(const Duration(days: 30));
  final venueController = TextEditingController(text: 'Palace Resort, Udaipur');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(22),
        borderRadius: 28,
        borderColor: AppColors.teal.withValues(alpha: 0.5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step $step of 3: Event Details',
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.teal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (step == 1) ...[
                const Text('Select Event Type:', style: TextStyle(fontSize: 13, color: Colors.white)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    'Royal Wedding',
                    'Corporate Gala',
                    'DJ Concert',
                    'Birthday Celebration',
                    'Cultural Show',
                  ].map((type) {
                    final isSel = selectedType == type;
                    return GlassChip(
                      label: type,
                      isSelected: isSel,
                      onTap: () => setState(() => selectedType = type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text('Venue / Location:', style: TextStyle(fontSize: 13, color: Colors.white)),
                const SizedBox(height: 8),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  borderRadius: 16,
                  child: TextField(
                    controller: venueController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.location_on_outlined, color: AppColors.teal),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GradientPillButton(
                  label: 'NEXT: BUDGET & DATE',
                  onPressed: () => setState(() => step = 2),
                ),
              ] else if (step == 2) ...[
                const Text('Selected Event Date:', style: TextStyle(fontSize: 13, color: Colors.white)),
                const SizedBox(height: 8),
                GlassCard(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(color: AppColors.teal, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.calendar_month_rounded, color: AppColors.teal),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text('Budget Tier:', style: TextStyle(fontSize: 13, color: Colors.white)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: budget,
                  dropdownColor: AppColors.surface,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  items: [
                    '₹50,000 - ₹1,00,000',
                    '₹1,50,000 - ₹3,00,000',
                    '₹5,00,000+',
                  ].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (v) => setState(() => budget = v!),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => setState(() => step = 1),
                        child: const Text('Back', style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    Expanded(
                      child: GradientPillButton(
                        label: 'CONFIRM & BOOK',
                        onPressed: () => setState(() => step = 3),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const Center(
                  child: Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 60),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Booking Request Received!',
                    style: TextStyle(fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Your Booking ID #BK-9021 is under review by RRE Team.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ),
                const SizedBox(height: 24),
                GradientPillButton(
                  label: 'DONE',
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onCompleted();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// --- 4. SERVICES MODULE SCREEN ---
class ServicesScreenView extends StatelessWidget {
  const ServicesScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      ServiceModel(id: 's1', title: 'Sound System & Acoustics', description: 'Line array JBL/RCF professional concert audio setup.', iconName: 'speaker', price: 'from ₹25,000'),
      ServiceModel(id: 's2', title: 'DJ & Visual FX', description: 'Celebrity DJs, CO2 jets, cold pyros & laser show.', iconName: 'dj', price: 'from ₹35,000'),
      ServiceModel(id: 's3', title: 'Live Orchestra Band', description: '10 to 25 piece symphonic live orchestra.', iconName: 'music', price: 'from ₹80,000'),
      ServiceModel(id: 's4', title: '4K Drone Photography & Video', description: 'Cinematic drone shots & AI instant face delivery.', iconName: 'camera', price: 'from ₹40,000'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RRE Services',
            style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Book standalone specialized sound, lighting, stage & artist services.',
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final s = services[index];
              return GlassCard(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.teal.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.teal.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: AppColors.teal, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                          const SizedBox(height: 2),
                          Text(s.description, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
                          const SizedBox(height: 6),
                          Text(s.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.teal)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.teal, size: 16),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- 5. SUPPORT & CONTACT MODULE ---
class SupportScreenView extends StatelessWidget {
  const SupportScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact & Support',
            style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            '24/7 dedicated customer support for event bookings & queries.',
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Icon(Icons.chat_bubble_outline_rounded, color: AppColors.teal, size: 28),
                      SizedBox(height: 8),
                      Text('WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      Icon(Icons.call_outlined, color: AppColors.teal, size: 28),
                      SizedBox(height: 8),
                      Text('Direct Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Send Us a Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 14),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  borderRadius: 14,
                  child: const TextField(
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(hintText: 'Your Name', border: InputBorder.none),
                  ),
                ),
                const SizedBox(height: 10),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  borderRadius: 14,
                  child: const TextField(
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(hintText: 'Event requirements / Message', border: InputBorder.none),
                  ),
                ),
                const SizedBox(height: 16),
                GradientPillButton(
                  label: 'SUBMIT INQUIRY',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 6. ADMIN DASHBOARD & ANALYTICS MODULE ---
class AdminDashboardScreenView extends StatelessWidget {
  const AdminDashboardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Admin Console',
                style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              GlassChip(label: 'Super Admin', icon: Icons.verified_user_rounded),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: const [
              GlassCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total Revenue', style: TextStyle(fontSize: 11, color: Colors.white60)),
                    SizedBox(height: 4),
                    Text('₹48,50,000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  ],
                ),
              ),
              GlassCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Active Bookings', style: TextStyle(fontSize: 11, color: Colors.white60)),
                    SizedBox(height: 4),
                    Text('34 Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  ],
                ),
              ),
              GlassCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Registered Artists', style: TextStyle(fontSize: 11, color: Colors.white60)),
                    SizedBox(height: 4),
                    Text('158 Verified', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  ],
                ),
              ),
              GlassCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('AI Photos Scanned', style: TextStyle(fontSize: 11, color: Colors.white60)),
                    SizedBox(height: 4),
                    Text('1,24,000+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- 7. PROFILE & USER REWARDS MODULE (WITH SECURITY CONTROL CENTER) ---
class ProfileScreenView extends StatefulWidget {
  final VoidCallback? onToggleAuth;

  const ProfileScreenView({super.key, this.onToggleAuth});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        final isLoggedIn = authService.isLoggedIn;
        final user = authService.currentUser;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: AppColors.primaryGradient),
                      ),
                      child: Icon(
                        isLoggedIn ? Icons.person : Icons.person_outline,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLoggedIn ? (user?.name ?? 'Arush Sharma') : 'Guest User',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isLoggedIn
                                ? '${user?.phone ?? "+91 98765 43210"} • ${user?.email ?? "arush@rre.com"}'
                                : 'Tap Login to access profile & bookings',
                            style: const TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (isLoggedIn && user != null) ...[
                // REWARD POINTS CARD
                GlassCard(
                  borderColor: AppColors.goldPrimary.withValues(alpha: 0.4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('RRE Reward Points', style: TextStyle(fontSize: 12, color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text('${user.rewardPoints} Points', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.goldLight)),
                            ],
                          ),
                          GlassChip(label: 'Referral: ${user.referralCode}'),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Role: ${user.role.name.toUpperCase()} Member',
                            style: const TextStyle(fontSize: 11, color: AppColors.goldLight, fontWeight: FontWeight.w600),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              authService.logout();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged out successfully.'), backgroundColor: Colors.redAccent),
                              );
                            },
                            icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 16),
                            label: const Text('LOGOUT', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // SECURITY & PRIVACY DASHBOARD WIDGET
                const SecurityDashboardWidget(),
              ] else ...[
                GlassCard(
                  borderColor: AppColors.pinkAccent.withValues(alpha: 0.4),
                  child: Column(
                    children: [
                      const Icon(Icons.lock_person_outlined, color: AppColors.pinkAccent, size: 44),
                      const SizedBox(height: 10),
                      const Text(
                        'Authentication Required',
                        style: TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Log in with your mobile number to view saved events & bookings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                      ),
                      const SizedBox(height: 18),
                      GradientPillButton(
                        label: 'LOGIN / REGISTER NOW',
                        onPressed: () {
                          if (widget.onToggleAuth != null) {
                            widget.onToggleAuth!();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
