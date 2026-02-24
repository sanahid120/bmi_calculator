import 'package:flutter/material.dart';

enum HeightType { cm, feetInch }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class BMIResult {
  final Color color;
  final IconData icon;
  final String status;

  BMIResult({required this.color, required this.icon, required this.status});
}

class _MyHomePageState extends State<MyHomePage> {
  HeightType? heightType = HeightType.cm;
  final weightKg = TextEditingController();
  final heightCM = TextEditingController();
  final heightFt = TextEditingController();
  final heightInch = TextEditingController();
  double bmiResult = 0;
  String? category;

  BMIResult categoryFinder(double bmi) {
    if (bmi < 16) {
      return BMIResult(
        color: const Color(0xFF1E88E5),
        icon: Icons.arrow_downward_outlined,
        status: 'You\'re Severely Thin',
      );
    }
    if (bmi >= 16 && bmi <= 17) {
      return BMIResult(
        color: const Color(0xFF42A5F5),
        icon: Icons.trending_down,
        status: 'You\'re Moderately Thin',
      );
    }
    if (bmi > 17 && bmi < 18.5) {
      return BMIResult(
        color: const Color(0xFF66BB6A),
        icon: Icons.trending_down,
        status: 'You\'re Mildly Thin',
      );
    }
    if (bmi > 18.5 && bmi <= 25) {
      return BMIResult(
        color: const Color(0xFF43A047),
        icon: Icons.favorite,
        status: 'You\'re Healthy',
      );
    }
    if (bmi > 25 && bmi <= 30) {
      return BMIResult(
        color: const Color(0xFFFDD835),
        icon: Icons.trending_up,
        status: 'You\'re Overweight',
      );
    }
    if (bmi > 30 && bmi <= 35) {
      return BMIResult(
        color: const Color(0xFFFB8C00),
        icon: Icons.warning_outlined,
        status: 'You\'re Obese ClassI',
      );
    }
    if (bmi > 35 && bmi <= 40) {
      return BMIResult(
        color: const Color(0xFFF4511E),
        icon: Icons.error_outline,
        status: 'You\'re Obese ClassII',
      );
    }
    return BMIResult(
      color: const Color(0xFFE53935),
      icon: Icons.error,
      status: 'You\'re Obese ClassIII',
    );
  }

  double? cmToMeter() {
    final cm = double.tryParse(heightCM.text.trim());
    if (cm == null || cm <= 0) {
      return null;
    } else {
      return cm / 100;
    }
  }

  double? feetInchToMeter() {
    final feet = double.tryParse(heightFt.text.trim());
    final inch = double.tryParse(heightInch.text.trim());

    if (feet == null || feet <= 0 || inch == null || inch <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Input')));
      return null;
    }
    double totalInch = (feet * 12 + inch);
    if (totalInch <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Input', style: TextStyle(color: Colors.red)),
        ),
      );
      return null;
    }
    return totalInch * 0.0254;
  }

  void calculation() {
    final weight = double.tryParse(weightKg.text.trim());
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid weight input')));
      return;
    }
    final heightValue = heightType == HeightType.cm
        ? cmToMeter()
        : feetInchToMeter();
    if (heightValue == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid height input')));
      return;
    }
    final double bmi = weight / (heightValue * heightValue);

    setState(() {
      bmiResult = double.parse(bmi.toStringAsFixed(1));
      final result = categoryFinder(bmi);
      category = result.status;
    });
  }

  @override
  void dispose() {
    weightKg.dispose();
    heightCM.dispose();
    heightFt.dispose();
    heightInch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BMIResult? currentResult = bmiResult > 0
        ? categoryFinder(bmiResult)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.orange[200],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.grey[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: ListView(
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Your Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Weight Input
                      TextField(
                        controller: weightKg,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)',
                          hintText: 'Enter weight',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixText: 'kg',
                          labelStyle: const TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF6366F1),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Height Unit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF424242),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SegmentedButton<HeightType>(
                        segments: const [
                          ButtonSegment(
                            value: HeightType.cm,
                            label: Text(
                              'Centimeters',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          ButtonSegment(
                            value: HeightType.feetInch,
                            label: Text(
                              'Feet & Inch',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                        selected: {heightType!},
                        onSelectionChanged: (value) =>
                            setState(() => heightType = value.first),
                      ),
                      const SizedBox(height: 24),
                      // Height Input
                      if (heightType == HeightType.cm) ...[
                        TextField(
                          controller: heightCM,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Height (cm)',
                            hintText: 'Enter height',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            suffixText: 'cm',
                            labelStyle: const TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF6366F1),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ] else ...[
                        Column(
                          children: [
                            TextField(
                              controller: heightFt,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Feet(\')',
                                hintText: 'Feet',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                suffixText: 'ft',
                                labelStyle: const TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6366F1),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: heightInch,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Inches(")',
                                hintText: 'Inches',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                suffixText: 'in',
                                labelStyle: const TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF6366F1),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Action Buttons
              ElevatedButton(
                onPressed: calculation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Calculate BMI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    heightCM.clear();
                    weightKg.clear();
                    heightFt.clear();
                    heightInch.clear();
                    bmiResult = 0;
                    category = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0),
                  foregroundColor: const Color(0xFF424242),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(
                  Icons.refresh,
                  size: 24,
                  color: Color(0xFF424242),
                ),
              ),
              const SizedBox(height: 28),
              if (bmiResult > 0 && currentResult != null)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border(
                        left: BorderSide(color: currentResult.color, width: 6),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            currentResult.icon,
                            size: 56,
                            color: currentResult.color,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Your BMI',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            bmiResult.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: currentResult.color,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: currentResult.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              currentResult.status,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: currentResult.color,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Enter your information and calculate your BMI',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
