import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../common/custom_app_bar.dart';

class PestTrapScreen extends StatefulWidget {
  const PestTrapScreen({super.key});

  @override
  State<PestTrapScreen> createState() => _PestTrapScreenState();
}

class _PestTrapScreenState extends State<PestTrapScreen> {
  bool _isAnalyzing = false;
  bool _showResult = true; // Show preloaded demo observation
  Uint8List? _trapImageBytes;
  String? _trapImageName;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickTrapImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        setState(() {
          _trapImageBytes = bytes;
          _trapImageName = image.name;
          _isAnalyzing = true;
          _showResult = false;
        });
        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted) return;
          setState(() {
            _isAnalyzing = false;
            _showResult = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sticky trap photo analyzed! Prototype detections plotted.'),
              backgroundColor: AppColors.deepPine,
            ),
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick trap image: $e')),
      );
    }
  }

  void _clearTrapImage() {
    setState(() {
      _trapImageBytes = null;
      _trapImageName = null;
    });
  }

  void _analyzeNewTrap() {
    setState(() => _isAnalyzing = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _showResult = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sticky trap analyzed successfully!'),
          backgroundColor: AppColors.deepPine,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('pest_trap'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Guidance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline, size: 18, color: AppColors.harvestGold),
                      SizedBox(width: 8),
                      Text(
                        'Sticky Trap Surveillance',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload 1–3 clear photos of field yellow sticky traps or pheromone delta traps to estimate vector count and calculate threshold surge risk.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Note: Prototype engine with simulated insect detection. Architecture is modular and ready for YOLOv8 model integration.',
                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.forest),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Image Upload / Preview Area
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.warmSand,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.stone, width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_trapImageBytes != null) ...[
                      Image.memory(
                        _trapImageBytes!,
                        fit: BoxFit.cover,
                      ),
                      // Semi-transparent overlay to ensure bboxes stand out
                      Container(color: Colors.black.withOpacity(0.15)),
                    ] else ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.crop_original, size: 48, color: AppColors.harvestGold),
                          SizedBox(height: 8),
                          Text(
                            'Yellow Sticky Trap #01 (South Plot)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                          ),
                          Text(
                            'Take a photo or choose from gallery to run AI scan',
                            style: TextStyle(fontSize: 11, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ],

                    // Simulated bounding boxes overlay
                    if (_showResult) ...[
                      Positioned(
                        left: 45,
                        top: 35,
                        child: _buildBBox(28, 28, 'Whitefly #1'),
                      ),
                      Positioned(
                        left: 130,
                        top: 60,
                        child: _buildBBox(30, 30, 'Whitefly #2'),
                      ),
                      Positioned(
                        right: 70,
                        top: 45,
                        child: _buildBBox(26, 26, 'Thrips #1'),
                      ),
                      Positioned(
                        right: 120,
                        bottom: 40,
                        child: _buildBBox(32, 32, 'Whitefly #3'),
                      ),
                      Positioned(
                        left: 80,
                        bottom: 30,
                        child: _buildBBox(28, 28, 'Aphid #1'),
                      ),
                    ],

                    // Status / Name chip
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _trapImageName ?? 'Sticky Trap Demo Feed',
                          style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    // Clear photo button if image uploaded
                    if (_trapImageBytes != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: _clearTrapImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Camera and Gallery buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isAnalyzing ? null : () => _pickTrapImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, color: AppColors.forest, size: 18),
                    label: const Text('Camera', style: TextStyle(color: AppColors.forest, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.forest),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isAnalyzing ? null : () => _pickTrapImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, color: AppColors.forest, size: 18),
                    label: const Text('Gallery', style: TextStyle(color: AppColors.forest, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.forest),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeNewTrap,
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.analytics_outlined),
              label: Text(_isAnalyzing ? 'Analyzing Trap...' : 'Analyze Sticky Trap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepPine,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            if (_showResult) ...[
              // Analysis Results Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.ivory,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.stone),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pest Trap Intelligence Result',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.harvestGold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Prototype Analysis',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.harvestGold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetric('Detected Pest', 'Whitefly\n(Bemisia tabaci)'),
                        _buildMetric('Estimated Count', '18\ninsects / trap'),
                        _buildMetric('Pest Pressure', 'Moderate\n(Threshold Active)'),
                        _buildMetric('Trap Risk', 'MODERATE\n(IPM Action)'),
                      ],
                    ),
                    const Divider(height: 24, color: AppColors.stone),

                    const Text(
                      'Integrated Pest Management (IPM) Advisory:',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.forest),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '• Count has reached 18 insects/trap; close to vector economic threshold (20/trap).\n'
                      '• Maintain 10-12 yellow sticky traps per hectare at crop canopy height.\n'
                      '• Apply 5% Neem Seed Kernel Extract (NSKE) or approved bio-repellent spray to deter oviposition.\n'
                      '• Clean and replace trap sheets within 7 days to monitor population surge.',
                      style: TextStyle(fontSize: 12, height: 1.45, color: AppColors.charcoal),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBBox(double width, double height, [String? label]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.critical,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.critical, width: 1.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.charcoal),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
      ],
    );
  }
}
