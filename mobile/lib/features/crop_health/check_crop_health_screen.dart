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
  String? _selectedSampleName;
  bool _isAnalyzing = false;
  bool _forceLowConfidence = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setPickedImage(null, null);
      _retrieveLostData();
    });
  }

  Future<void> _retrieveLostData() async {
    try {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.isEmpty || response.file == null) return;
      final file = response.file!;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setPickedImage(bytes, file.name);
      setState(() {
        _selectedSampleName = file.name;
        _forceLowConfidence = false;
      });
    } catch (_) {}
  }

  void _clearImage() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setPickedImage(null, null);
    setState(() {
      _selectedSampleName = null;
      _forceLowConfidence = false;
    });
  }

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
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.pickedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture or select a leaf photo first.'),
          backgroundColor: AppColors.dangerRed,
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

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
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: _clearImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.65),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                                    ),
                                  ),
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
                                            _selectedSampleName ?? appState.pickedImageName ?? 'Leaf Image Captured',
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

            // AI Auto-Detection Information Card (No disease selection required)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.stone),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.auto_awesome, color: AppColors.harvestGold, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Automated AI Foliar Diagnosis',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.charcoal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Farmers do not need to guess or select diseases. Simply photograph or upload a leaf photo; our PyTorch EfficientNet model scans foliar lesions and predicts disease and severity automatically.',
                    style: TextStyle(fontSize: 11.5, color: AppColors.muted, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  // Test toggle for Hackathon Judges to demo doctor review flow
                  InkWell(
                    onTap: () => setState(() => _forceLowConfidence = !_forceLowConfidence),
                    child: Row(
                      children: [
                        Icon(
                          _forceLowConfidence ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 18,
                          color: _forceLowConfidence ? AppColors.harvestGold : AppColors.muted,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Simulate Low AI Confidence (<70%) -> Triggers Doctor Review',
                            style: TextStyle(fontSize: 11, color: AppColors.charcoal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Main Analyze Button
            ElevatedButton(
              onPressed: _isAnalyzing
                  ? null
                  : (appState.pickedImageBytes == null
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please capture or choose a leaf photo above first.'),
                              backgroundColor: AppColors.warning,
                            ),
                          );
                        }
                      : _runAnalysis),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: appState.pickedImageBytes == null
                    ? Colors.grey.shade400
                    : AppColors.primaryGreen,
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
                        Icon(
                          appState.pickedImageBytes == null
                              ? Icons.camera_alt_outlined
                              : Icons.check_circle_outline,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          appState.pickedImageBytes == null
                              ? 'Take or Upload Leaf Photo First'
                              : loc.tr('check_crop_health'),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
