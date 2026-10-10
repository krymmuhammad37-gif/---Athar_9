import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const AtharProApp());
}

class AtharProApp extends StatelessWidget {
  const AtharProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أَثَر | Athar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF1F6FEB),
        useMaterial3: true,
      ),
      home: const AtharHomeScreen(),
    );
  }
}

class AtharHomeScreen extends StatefulWidget {
  const AtharHomeScreen({super.key});

  @override
  State<AtharHomeScreen> createState() => _AtharHomeScreenState();
}

class _AtharHomeScreenState extends State<AtharHomeScreen> {
  bool _isRadioPlaying = false;
  late Timer _clockTimer;
  String _liveTimeString = '';
  String _dailyAyaOrZekr = '🌙 "ألا بذكر الله تطمئن قلوبغهم"';

  @override
  void initState() {
    super.initState();
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateClock();
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _updateClock() {
    final now = DateTime.now();
    int h = now.hour;
    int m = now.minute;
    int s = now.second;
    String period = h >= 12 ? 'مساءً' : 'صباحاً';
    int displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);

    setState(() {
      _liveTimeString = "${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')} $period";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق أَثَر الشامل 🌙', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // بطاقة الوقت الحي والترحيب
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1F6FEB), Color(0xFF238636)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الساعة الآن في وقتك المحلي', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(_liveTimeString, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(_dailyAyaOrZekr, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // زر إذاعة القرآن المباشرة
            GestureDetector(
              onTap: () {
                setState(() {
                  _isRadioPlaying = !_isRadioPlaying;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isRadioPlaying ? '🟢 تم بدء بث إذاعة أَثَر المباشرة' : '🔴 تم إيقاف الإذاعة'),
                    backgroundColor: _isRadioPlaying ? Colors.green.shade800 : Colors.red.shade800,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isRadioPlaying ? Colors.greenAccent : const Color(0xFF30363D),
                    width: _isRadioPlaying ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.radio, color: Colors.amberAccent, size: 28),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('إذاعة أَثَر المباشرة 📻', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 4),
                            Text('استمع للقرآن الكريم طوال اليوم', style: TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: _isRadioPlaying ? Colors.green : Colors.grey.shade800,
                      radius: 12,
                      child: Icon(_isRadioPlaying ? Icons.mic : Icons.play_arrow, size: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // أقسام التطبيق الرئيسية
            _buildNavCard(
              context,
              title: 'المصحف الشريف 📖',
              subtitle: 'تصفح سور القرآن الكريم بالرسم العثماني',
              icon: Icons.menu_book,
              color: const Color(0xFF1F6FEB),
              targetScreen: const QuranViewPage(),
            ),
            const SizedBox(height: 12),
            _buildNavCard(
              context,
              title: 'المكتبة الصوتية 🎧',
              subtitle: 'تلاوات خاشعة لأشهر القراء والمشايخ',
              icon: Icons.headset,
              color: const Color(0xFF238636),
              targetScreen: const AudioLibraryPage(),
            ),
            const SizedBox(height: 12),
            _buildNavCard(
              context,
              title: 'السبحة الرقمية الذكية 📿',
              subtitle: 'عداد تسبيح واستغفار تفاعلي متطور',
              icon: Icons.touch_app,
              color: const Color(0xFF9E6A03),
              targetScreen: const SebhaPage(),
            ),
            const SizedBox(height: 12),
            _buildNavCard(
              context,
              title: 'حصن المسلم (الأذكار) 🤲',
              subtitle: 'أذكار الصباح، المساء، النوم، وغيرها',
              icon: Icons.wb_sunny_outlined,
              color: const Color(0xFF8957E5),
              targetScreen: const AzkarPage(),
            ),
            const SizedBox(height: 12),
            _buildNavCard(
              context,
              title: 'مواقيت الصلاة والقبلة 🕌',
              subtitle: 'مواقيت الصلوات الخمس واتجاه القبلة',
              icon: Icons.access_alarm,
              color: const Color(0xFFDA3633),
              targetScreen: const PrayerTimesPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required Widget targetScreen}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        },
      ),
    );
  }
}

// صفحات التطبيق الفرعية المرتبة

class QuranViewPage extends StatelessWidget {
  const QuranViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المصحف الشريف 📖'), backgroundColor: const Color(0xFF161B22)),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(backgroundColor: const Color(0xFF1F6FEB), child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
            title: Text('سورة رقم ${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('الرسم العثماني - مكية / مدنية', style: TextStyle(color: Colors.white70, fontSize: 12)),
            trailing: const Icon(Icons.bookmark_border, color: Colors.amberAccent),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فتح سورة رقم ${index + 1}')));
            },
          );
        },
      ),
    );
  }
}

class AudioLibraryPage extends StatelessWidget {
  const AudioLibraryPage({super.key});
  final List<String> sheikhs = const [
    'الشيخ محمود خليل الحصري',
    'الشيخ عبد الباسط عبد الصمد',
    'الشيخ محمد صديق المنشاوي',
    'القارئ مشاري راشد العفاسي',
    'القارئ ماهر المعيقلي',
    'القارئ ياسر الدوسري'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المكتبة الصوتية 🎧'), backgroundColor: const Color(0xFF161B22)),
      body: ListView.builder(
        itemCount: sheikhs.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF161B22),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(sheikhs[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: const Text('المصحف المرتل كاملاً بجودة عالية', style: TextStyle(color: Colors.white70, fontSize: 12)),
              trailing: const Icon(Icons.play_circle_fill, color: Colors.greenAccent, size: 30),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تشغيل التلاوة لـ ${sheikhs[index]}')));
              },
            ),
          );
        },
      ),
    );
  }
}

class SebhaPage extends StatefulWidget {
  const SebhaPage({super.key});

  @override
  State<SebhaPage> createState() => _SebhaPageState();
}

class _SebhaPageState extends State<SebhaPage> {
  int count = 0;
  String zekr = 'سُبْحَانَ اللَّهِ';

  void _increment() {
    setState(() {
      count++;
      if (count == 33) {
        zekr = 'الْحَمْدُ لِلَّهِ';
      } else if (count == 66) {
        zekr = 'اللَّهُ أَكْبَرُ';
      } else if (count >= 100) {
        zekr = 'لَا إِلَهَ إِلَّا اللَّهُ';
      }
    });
  }

  void _reset() {
    setState(() {
      count = 0;
      zekr = 'سُبْحَانَ اللَّهِ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السبحة الرقمية الذكية 📿'), backgroundColor: const Color(0xFF161B22)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(zekr, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.amberAccent)),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _increment,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF161B22),
                  border: Border.all(color: const Color(0xFF9E6A03), width: 4),
                  boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.1), blurRadius: 15)],
                ),
                child: Center(
                  child: Text('$count', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text('تسبيح'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF238636), foregroundColor: Colors.white),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800, foregroundColor: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AzkarPage extends StatelessWidget {
  const AzkarPage({super.key});
  final List<String> categories = const ['أذكار الصباح 🌅', 'أذكار المساء 🌃', 'أذكار الاستيقاظ ☀️', 'أذكار النوم 🌙', 'أدعية نبوية جامعة 🤲'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حصن المسلم والأذكار 🤲'), backgroundColor: const Color(0xFF161B22)),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.bookmark_rounded, color: Colors.purpleAccent),
            title: Text(categories[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم اختيار: ${categories[index]}')));
            },
          );
        },
      ),
    );
  }
}

class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});
  final List<Map<String, String>> prayers = const [
    {'name': 'الفجر', 'time': '04:17 ص'},
    {'name': 'الشروق', 'time': '05:45 ص'},
    {'name': 'الظهر', 'time': '11:52 ص'},
    {'name': 'العصر', 'time': '03:15 م'},
    {'name': 'المغرب', 'time': '05:58 م'},
    {'name': 'العشاء', 'time': '07:15 م'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مواقيت الصلاة والقبلة 🕌'), backgroundColor: const Color(0xFF161B22)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: constيد EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🧭 اتجاه القبلة:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('مكة المكرمة (135°)', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: prayers.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color(0xFF161B22),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(prayers[index]['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      trailing: Text(prayers[index]['time']!, style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات ⚙️'), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('الإشعارات والتنبيهات', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          ListTile(
            title: Text('تنبيهات أوقات الصلاة'),
            subtitle: Text('مفعلة تلقائياً'),
            trailing: Icon(Icons.notifications_active, color: Colors.greenAccent),
          ),
          ListTile(
            title: Text('تنبيه أذكار الصباح والمساء'),
            subtitle: Text('مفعلة تلقائياً'),
            trailing: Icon(Icons.alarm, color: Colors.amberAccent),
          ),
          Divider(height: 30, color: Colors.white24),
          Text('حول التطبيق', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          ListTile(
            title: Text('اسم التطبيق'),
            subtitle: Text('أَثَر | Athar (الإصدار 1.0)'),
            trailing: Icon(Icons.info_outline, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}