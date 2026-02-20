import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:device_preview/device_preview.dart';

const String API_KEY = "14b18b722bbf621b57ae8a25f71f391e";

const List<String> UZBEK_REGIONS = [
  "Tashkent",
  "Samarkand",
  "Bukhara",
  "Khiva",
  "Urgench",
  "Namangan",
  "Andijan",
  "Fergana",
  "Jizzakh",
  "Karshi",
  "Nukus",
  "Termez",
  "Navoiy",
  "Guliston",
  "Qarshi",
  "Kokand",
  "Margilan"
];

class MountainArea {
  final String name;
  final String temperature;
  final String condition;
  final IconData icon;

  MountainArea(this.name, this.temperature, this.condition, this.icon);
}

final List<MountainArea> MOCK_MOUNTAIN_AREAS = [
  MountainArea("Qamchiq dovoni", "+9°", "Ochiq", Icons.wb_sunny_rounded),
  MountainArea("Shahriston dovoni", "+12°", "Ochiq", Icons.wb_sunny_rounded),
  MountainArea("Taxtaqoracha dovoni", "+10°", "Ochiq", Icons.wb_sunny_rounded),
  MountainArea("G'uzar dovoni", "+15°", "Yomg'ir", Icons.beach_access_rounded),
  MountainArea("Kitob dovoni", "+12°", "Bulutli", Icons.cloud_rounded),
  MountainArea("Chimyon", "+5°", "Yog'ingarchilik", Icons.ac_unit_rounded),
];

class MockForecast {
  final String timeOrDay;
  final IconData icon;
  final String tempMax;
  final String tempMin;
  final String description;
  final bool isHourly;

  MockForecast(
      this.timeOrDay, this.icon, this.tempMax, this.tempMin, this.description,
      {this.isHourly = false});

  String get tempString => isHourly ? "$tempMax°" : "$tempMax° $tempMin°";
}


void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: ' Ob-havosi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WeatherDetailScreen(city: "Tashkent"),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC3F7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_queue_rounded,
                size: 120,
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]),
            const SizedBox(height: 30),
            const Text(
              "O'zbekiston Ob-havo",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ma'lumotlar yuklanmoqda...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
                color: Colors.white, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}


class WeatherDetailScreen extends StatefulWidget {
  final String city;

  const WeatherDetailScreen({required this.city, super.key});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  late final WeatherFactory _wf;
  Weather? _currentWeather;
  List<Weather> _forecasts = [];

  bool _isLoading = true;

  late List<MockForecast> _hourlyForecast;
  late List<MockForecast> _dailyForecast;

  @override
  void initState() {
    super.initState();
    _wf = WeatherFactory(API_KEY, language: Language.RUSSIAN);
    _fetchCurrentWeather(widget.city);
  }

  @override
  void didUpdateWidget(covariant WeatherDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.city != widget.city) {
      _fetchCurrentWeather(widget.city);
    }
  }

  void _generateForecastsFromData() {
    if (_forecasts.isEmpty) {
      _hourlyForecast = [];
      _dailyForecast = [
        MockForecast("Bugun", Icons.wb_sunny_rounded, "+23", "+8", "Ochiq"),
      ];
      return;
    }

    _hourlyForecast = [];

    final hourlyData = _forecasts.take(12).toList();

    int currentHourIndex = -1;
    final now = DateTime.now().toLocal();

    for (int i = 0; i < hourlyData.length; i++) {
      final forecastDate = hourlyData[i].date?.toLocal();

      if (forecastDate != null && forecastDate.isAfter(now.subtract(const Duration(hours: 3, minutes: 30)))) {
        currentHourIndex = i;
        break;
      }
    }

    for (int i = 0; i < hourlyData.length; i++) {
      final w = hourlyData[i];
      final dateTime = w.date?.toLocal();
      final tempMax = w.temperature?.celsius?.toStringAsFixed(0) ?? 'N/A';

      final timeString = i == currentHourIndex ? "Hozir" : "${dateTime?.hour.toString().padLeft(2, '0')}:00";

      _hourlyForecast.add(
          MockForecast(
              timeString,
              _getWeatherIcon(w.weatherMain),
              tempMax,
              tempMax,
              w.weatherDescription ?? "N/A",
              isHourly: true
          )
      );
    }

    _dailyForecast = [];

    Map<int, List<Weather>> dailyGroupedData = {};
    for (var weather in _forecasts) {
      int day = weather.date!.toLocal().day;
      if (!dailyGroupedData.containsKey(day)) {
        dailyGroupedData[day] = [];
      }
      dailyGroupedData[day]!.add(weather);
    }

    int index = 0;
    dailyGroupedData.forEach((day, forecasts) {
      if (index > 6) return;

      double? minTemp = forecasts.map((w) => w.tempMin?.celsius).where((t) => t != null).cast<double>().reduce((a, b) => a < b ? a : b);
      double? maxTemp = forecasts.map((w) => w.tempMax?.celsius).where((t) => t != null).cast<double>().reduce((a, b) => a > b ? a : b);

      String mainCondition = forecasts.map((w) => w.weatherMain).fold<Map<String, int>>({}, (map, weatherMain) {
        map[weatherMain!] = (map[weatherMain] ?? 0) + 1;
        return map;
      }).entries.reduce((a, b) => a.value > b.value ? a : b).key;

      String dayName = "N/A";
      if (index == 0) {
        dayName = "Bugun";
      } else if (index == 1) {
        dayName = "Ertaga";
      } else {
        DateTime date = forecasts.first.date!.toLocal();
        switch (date.weekday) {
          case 1: dayName = "Dush."; break;
          case 2: dayName = "Sesh."; break;
          case 3: dayName = "Chor."; break;
          case 4: dayName = "Pay."; break;
          case 5: dayName = "Juma"; break;
          case 6: dayName = "Shan."; break;
          case 7: dayName = "Yak."; break;
        }
      }

      _dailyForecast.add(
          MockForecast(
            dayName,
            _getWeatherIcon(mainCondition),
            maxTemp?.toStringAsFixed(0) ?? 'N/A',
            minTemp?.toStringAsFixed(0) ?? 'N/A',
            forecasts.first.weatherDescription ?? "N/A",
          )
      );
      index++;
    });
  }

  Future<void> _fetchCurrentWeather(String city) async {
    if (_currentWeather == null) {
      setState(() => _isLoading = true);
    }

    try {
      Weather weather = await _wf.currentWeatherByCityName(city);
      _currentWeather = weather;

      List<Weather> forecastList = await _wf.fiveDayForecastByCityName(city);

      _forecasts = forecastList.where((w) => w.date!.toLocal().isAfter(DateTime.now().toLocal().subtract(const Duration(hours: 3)))).toList();

      _generateForecastsFromData();

    } catch (e) {
      _currentWeather = null;
      _forecasts = [];
      print("Xato: $city shahri uchun ma'lumot yuklanmadi: $e");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _refreshData() async {
    await _fetchCurrentWeather(widget.city);
  }

  IconData _getWeatherIcon(String? weatherMain) {
    final main = weatherMain ?? 'Clear';
    if (main == 'Clear') return Icons.wb_sunny_rounded;
    if (main == 'Clouds') return Icons.cloud_rounded;
    if (main == 'Rain' || main == 'Drizzle') return Icons.beach_access_rounded;
    if (main == 'Thunderstorm') return Icons.flash_on_rounded;
    if (main == 'Snow') return Icons.ac_unit_rounded;
    return Icons.wb_cloudy_rounded;
  }

  String _getCityImagePath(String city) {
    String fileName = city.toLowerCase();

    if (city == "Bukhara") return "assets/images/buhoro.jpg";
    if (city == "Fergana") return "assets/images/fargona.jpg";
    if (city == "Khiva") return "assets/images/Khiva.jpg";
    if (city == "Urgench") return "assets/images/urganch.jpg";
    if (city == "Samarkand") return "assets/images/samarqand.jpg";
    if (city == "Termez") return "assets/images/termiz.jpg";
    if (city == "Karshi" || city == "Qarshi") return "assets/images/karshi.jpg";
    if (city == "Navoiy") return "assets/images/navoiy.jpg";
    if (city == "Nukus") return "assets/images/nukus.jpg";
    if (city == "Guliston") return "assets/images/guliston.jpg";
    if (city == "Jizzakh") return "assets/images/jizzax.jpg";
    if (city == "Andijan") return "assets/images/andijon.jpg";
    if (city == "Namangan") return "assets/images/namangan.jpg";
    if (city == "Tashkent") return "assets/images/tashkent.jpg";

    return "assets/images/${fileName}.jpg";
  }

  Widget _buildTopImageSection(Weather weather) {
    final temp = weather.temperature?.celsius?.toStringAsFixed(0) ?? 'N/A';
    final feelsLike =
        weather.tempFeelsLike?.celsius?.toStringAsFixed(0) ?? 'N/A';
    final description = weather.weatherDescription ?? "Ma'lumotsiz";
    final icon = _getWeatherIcon(weather.weatherMain);
    final imagePath = _getCityImagePath(widget.city);

    return Container(
      height: 400,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            print("Rasm yuklanmadi: $imagePath. Xato: $exception");
          },
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(30)),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.5)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48),
                      Text(
                        widget.city,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_on_outlined,
                            color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                                builder: (context) => const JoylashuvScreen()),
                          )
                              .then((selectedCity) {
                            if (selectedCity is String) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => WeatherDetailScreen(
                                          city: selectedCity)));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        'His qilish +$feelsLike°',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                          shadows: const [
                            Shadow(blurRadius: 5, color: Colors.black)
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+$temp',
                            style: const TextStyle(
                              fontSize: 90,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 4),
                            child:
                            Icon(icon, size: 60, color: Colors.amberAccent),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.3,
                          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return _buildSectionCard(
        title: "Soatlik ob-havo (24 soat)",
        child: Column(
          children: [
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _hourlyForecast.length,
                itemBuilder: (context, index) {
                  final item = _hourlyForecast[index];
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
                    child: _buildHourlyItem(item),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white54, height: 20),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ForecastDetailScreen(
                        city: widget.city,
                        title: "Soatlik ob-havo",
                        forecasts: _hourlyForecast,
                      ),
                    ),
                  );
                },
                child: const Text("Ko'proq ma'lumot",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        ));
  }

  Widget _buildHourlyItem(MockForecast item) {
    final isNow = item.timeOrDay == "Hozir";

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: isNow ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.15),
        border: isNow ? Border.all(color: Colors.white, width: 2) : null,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(item.timeOrDay,
              style: TextStyle(color: isNow ? Colors.white : Colors.white70,
                  fontSize: 14,
                  fontWeight: isNow ? FontWeight.bold : FontWeight.normal
              )),
          Icon(item.icon, color: Colors.white, size: 30),
          Text(
            item.tempString.replaceAll('++', '+'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecast() {
    return _buildSectionCard(
      title: "Kunlik ob-havo (7 kun)",
      child: Column(
        children: [
          ..._dailyForecast.map((item) => _buildDailyItem(item)).toList(),
          const Divider(color: Colors.white54, height: 20),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ForecastDetailScreen(
                      city: widget.city,
                      title: "Kunlik ob-havo",
                      forecasts: _dailyForecast,
                    ),
                  ),
                );
              },
              child: const Text("Ko'proq ma'lumot",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildDailyItem(MockForecast item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              item.timeOrDay,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(item.icon, color: Colors.amberAccent, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              "+${item.tempMax}°",
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              "+${item.tempMin}°",
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics(Weather weather) {
    final humidity = weather.humidity ?? 0;
    final pressure = weather.pressure ?? 0;
    final windSpeed = weather.windSpeed?.toStringAsFixed(1) ?? 'N/A';
    final precipitationChance = 10;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricItem(
            Icons.water_drop_rounded, "$humidity%", "Havo namligi"),
        _buildMetricItem(
            Icons.cloudy_snowing, "$precipitationChance%", "Yog'ingarchilik"),
        _buildMetricItem(Icons.speed_rounded, "$pressure hPa", "Havo bosimi"),
        _buildMetricItem(
            Icons.wind_power_rounded, "$windSpeed m/s", "Shamol tezligi"),
      ],
    );
  }

  Widget _buildMetricItem(IconData icon, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMountainAreas() {
    return _buildSectionCard(
      title: "Tog'li hududlar",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Muhim dovon va tog'li hududlardagi ob-havo ma'lumotlari:",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 15),
          ...MOCK_MOUNTAIN_AREAS
              .map((area) => _buildMountainItem(area))
              .toList(),
          const Divider(color: Colors.white54, height: 20),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MountainAreaScreen()),
                );
              },
              child: const Text("Barcha tog'li hududlar",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildMountainItem(MountainArea area) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              area.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            children: [
              Icon(area.icon, color: Colors.amberAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                area.condition,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            width: 50,
            child: Text(
              area.temperature,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bottomBackgroundColor = Color(0xFF4FC3F7);

    return Scaffold(
      body: Container(
        color: bottomBackgroundColor,
        child: _isLoading
            ? const Center(
            child: CircularProgressIndicator(color: Colors.white))
            : (_currentWeather == null
            ? Center(
          child: Text(
            "${widget.city} shahri uchun ma'lumot topilmadi. Internet yoki API kalitini tekshiring.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
            : RefreshIndicator(
          onRefresh: _refreshData,
          color: bottomBackgroundColor,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildTopImageSection(_currentWeather!),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        bottomBackgroundColor,
                        Color(0xFF81D4FA)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildHourlyForecast(),
                      _buildDailyForecast(),
                      _buildMountainAreas(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child:
                        _buildDetailedMetrics(_currentWeather!),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}


class SideMenuScreen extends StatelessWidget {
  const SideMenuScreen({super.key});

  static const Color _menuItemColor = Color.fromARGB(41, 255, 255, 255);
  static const Color _backgroundColor = Color(0xFF4FC3F7);

  Widget _buildMenuItem(
      {required BuildContext context,
        required IconData icon,
        required String title,
        VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: _menuItemColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 15),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(blurRadius: 5, color: Colors.black26)],
              ),
            ),
          ),
          Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: item,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Ob-havo Menyu",
          style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 5, color: Colors.black26)]),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.location_on_outlined,
                  color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                      builder: (context) => const JoylashuvScreen()),
                )
                    .then((selectedCity) {
                  if (selectedCity is String) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            WeatherDetailScreen(city: selectedCity)));
                  }
                });
              },
            ),
          )
        ],
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategory(
                title: "Sozlamalar",
                items: [
                  _buildMenuItem(
                      context: context,
                      icon: Icons.language,
                      title: "Til",
                      onTap: () {}),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.location_city,
                    title: "Joylashuvni tanlash",
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                            builder: (context) => const JoylashuvScreen()),
                      )
                          .then((selectedCity) {
                        if (selectedCity is String) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WeatherDetailScreen(city: selectedCity)));
                        }
                      });
                    },
                  ),
                  _buildMenuItem(
                      context: context,
                      icon: Icons.notifications_none,
                      title: "Bildirishnomalar",
                      onTap: () {}),
                ],
              ),
              _buildCategory(
                title: "Boshqa",
                items: [
                  _buildMenuItem(
                      context: context,
                      icon: Icons.share,
                      title: "Ilovani ulashish",
                      onTap: () {}),
                  _buildMenuItem(
                      context: context,
                      icon: Icons.info_outline,
                      title: "Maxfiylik siyosati",
                      onTap: () {}),
                  _buildMenuItem(
                      context: context,
                      icon: Icons.send,
                      title: "Telegram kanal",
                      onTap: () {}),
                  _buildMenuItem(
                      context: context,
                      icon: Icons.help_outline,
                      title: "Qo'llab-quvvatlash",
                      onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class JoylashuvScreen extends StatefulWidget {
  const JoylashuvScreen({super.key});

  @override
  State<JoylashuvScreen> createState() => _JoylashuvScreenState();
}

class _JoylashuvScreenState extends State<JoylashuvScreen> {
  String _searchQuery = '';
  static const Color _backgroundColor = Color(0xFF4FC3F7);
  static const Color _cardColor = Color.fromARGB(41, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    final filteredRegions = UZBEK_REGIONS.where((region) {
      final regionLower = region.toLowerCase();
      final queryLower = _searchQuery.toLowerCase();
      return regionLower.contains(queryLower);
    }).toList();

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Joylashuvni tanlash",
          style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 5, color: Colors.black26)]),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Manzilni izlash",
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: _cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRegions.length,
                itemBuilder: (context, index) {
                  final region = filteredRegions[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(region);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 10),
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  region.replaceAll(' viloyati', ''),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Text(
                                  "O'zbekiston",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 14),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.white70, size: 16),
                          ],
                        ),
                      ),
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


class ForecastDetailScreen extends StatelessWidget {
  final String city;
  final String title;
  final List<MockForecast> forecasts;

  const ForecastDetailScreen(
      {required this.city,
        required this.title,
        required this.forecasts,
        super.key});

  static const Color _cardColor = Color.fromARGB(41, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC3F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "$city - $title",
          style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 5, color: Colors.black26)]),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: forecasts.length,
          itemBuilder: (context, index) {
            final item = forecasts[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        item.timeOrDay,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(item.icon, color: Colors.amberAccent, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.description,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        item.tempMax.replaceAll('++', '+') + "°",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                    if (!item.isHourly)
                      SizedBox(
                        width: 40,
                        child: Text(
                          item.tempMin.replaceAll('++', '+') + "°",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 18),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class MountainAreaScreen extends StatelessWidget {
  const MountainAreaScreen({super.key});

  static const Color _cardColor = Color.fromARGB(41, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC3F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Tog'li hududlar",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 5, color: Colors.black26)]),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFF4FC3F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: MOCK_MOUNTAIN_AREAS.length,
          itemBuilder: (context, index) {
            final area = MOCK_MOUNTAIN_AREAS[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        area.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(area.icon, color: Colors.amberAccent, size: 30),
                        const SizedBox(width: 8),
                        Text(
                          area.condition,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        area.temperature.replaceAll('++', '+'),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}