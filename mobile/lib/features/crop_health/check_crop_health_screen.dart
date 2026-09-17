import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/state/app_state.dart';
import '../../services/sync/sync_service.dart';
import '../common/custom_app_bar.dart';

class CheckCropHealthScreen extends StatefulWidget {
  const CheckCropHealthScreen({super.key});

  @override
  State<CheckCropHealthScreen> createState() => _CheckCropHealthScreenState();
}

class _CheckCropHealthScreenState extends State<CheckCropHealthScreen> {
  String _selectedCrop = 'Tomato';
  String _selectedSampleName = 'Tomato Leaf Sample';
  bool _isAnalyzing = false;
  bool _forceLowConfidence = false;
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _quickSamplePresets = [
    {
      'title': 'Tomato Blight (Spot Pattern)',
      'crop': 'Tomato',
      'lowConf': false,
      'desc': 'Brown concentric spots on leaf blade',
    },
    {
      'title': 'Tomato Blight (Doctor Review Case)',
      'crop': 'Tomato',
      'lowConf': true,
      'desc': 'Early stage (54% confidence) -> Sent to Agri Doctor',
    },
    {
      'title': 'Potato Early Blight',
      'crop': 'Potato',
      'lowConf': false,
      'desc': 'Foliar dark brown lesions on potato leaf',
    },
    {
      'title': 'Healthy Green Leaf',
      'crop': 'Tomato',
      'lowConf': false,
      'desc': 'Clean vibrant foliage with zero disease',
    },
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setPickedImage(bytes, image.name);
        setState(() {
          _selectedSampleName = image.name;
          _forceLowConfidence = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Leaf image loaded: ${image.name}'),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open camera/gallery: $e'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
    }
  }

  void _runAnalysis() async {
    setState(() => _isAnalyzing = true);
    final appState = Provider.of<AppState>(context, listen: false);

    await appState.runAnalysis(
      cropHint: _selectedCrop,
      forceLowConfidence: _forceLowConfidence,
    );

    if (!mounted) return;
    setState(() => _isAnalyzing = false);
    Navigator.of(context).pushReplacementNamed('/diagnosis-result');
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final syncService = Provider.of<SyncService>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: FasalAppBar(
        title: loc.tr('crop_doctor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Crop Selector Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.eco, color: AppColors.primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '1. Select Crop / फसल चुनें',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCrop,
                          isExpanded: true,
                          items: AppConstants.supportedCrops
                              .map((crop) => DropdownMenuItem(
                                    value: crop,
                                    child: Text(crop, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCrop = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Image Capture Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.camera_alt, color: AppColors.primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Text(
                          '2. Upload Leaf Photo / पत्ती का फोटो',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Leaf Preview Box
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.lightMint.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: appState.pickedImageBytes != null
                              ? AppColors.primaryGreen
                              : AppColors.border,
                          width: appState.pickedImageBytes != null ? 2 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: appState.pickedImageBytes != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(
                                  appState.pickedImageBytes!,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            _selectedSampleName,
                                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.primaryGreen.withOpacity(0.8)),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tap below to take or choose photo',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Clear leaf image gives best diagnosis',
                                  style: TextStyle(fontSize: 11, color: AppColors.muted),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 12),

                    // Two Upload Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt, size: 18),
                            label: Text(loc.tr('take_photo')),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library, size: 18),
                            label: Text(loc.tr('choose_gallery')),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppColors.primaryGreen),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Quick Demo Samples Card (For Fast Demo & Testing)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.science_outlined, color: AppColors.primaryGreen, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          loc.tr('or_test_sample'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ..._quickSamplePresets.map((preset) {
                      final isSelected = _selectedSampleName == preset['title'];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedSampleName = preset['title'];
                            _selectedCrop = preset['crop'];
                            _forceLowConfidence = preset['lowConf'];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.lightMint : AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.primaryGreen : AppColors.border,
                              width: isSelected ? 1.8 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                size: 18,
                                color: isSelected ? AppColors.primaryGreen : Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      preset['title'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppColors.primaryGreen : AppColors.charcoal,
                                      ),
                                    ),
                                    Text(
                                      preset['desc'],
                                      style: const TextStyle(fontSize: 11, color: AppColors.muted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Main Analyze Button
            ElevatedButton(
              onPressed: _isAnalyzing ? null : _runAnalysis,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _isAnalyzing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          syncService.isOfflineMode
                              ? loc.tr('analyzing_on_device')
                              : loc.tr('analyzing_crop'),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          loc.tr('check_crop_health'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
