import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/profile_entity.dart';
import 'package:mt/features/home/domain/usecases/get_user_profile.dart';
import 'package:mt/features/home/domain/usecases/update_user_profile.dart';
import 'package:mt/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _user = sl<SupabaseClient>().auth.currentUser;
  ProfileEntity? _profile;
  Uint8List? _avatarBytes;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final userId = _user?.id;
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _loadError = 'You need to sign in to edit your profile.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final profile = await sl<GetUserProfile>().call(userId);
      if (!mounted) return;
      _profile = profile;
      _displayNameController.text = profile.displayName;
      _storeNameController.text = profile.storeName ?? '';
      setState(() => _isLoading = false);
    } catch (error) {
      AppHelpers.logger().error(error);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'Could not load your profile. Please try again.';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _profile == null) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    try {
      await sl<UpdateUserProfile>().call(
        userId: _profile!.id,
        displayName: _displayNameController.text.trim(),
        storeName: _optionalValue(_storeNameController.text),
        avatarUrl: _profile!.avatarUrl,
        avatarBytes: _avatarBytes,
      );

      if (!mounted) return;
      AppHelpers.showSnackBar(
        context,
        'Profile updated',
        'Your changes have been saved.',
        ContentType.success,
      );
      context.pop(true);
    } catch (error) {
      AppHelpers.logger().error(error);
      if (!mounted) return;
      final message = error is PostgrestException && error.code == '23505'
          ? 'That store name is already in use.'
          : 'Could not save your profile. Please try again.';
      AppHelpers.showSnackBar(
        context,
        'Update failed',
        message,
        ContentType.failure,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? _optionalValue(String value) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? null : trimmedValue;
  }

  Future<void> _pickAvatar() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() => _avatarBytes = bytes);
    } catch (error) {
      AppHelpers.logger().error(error);
      if (!mounted) return;
      AppHelpers.showSnackBar(
        context,
        'Image unavailable',
        'Could not open the image picker.',
        ContentType.failure,
      );
    }
  }

  Widget _buildAvatarPreview() {
    final avatarBytes = _avatarBytes;
    final avatarUrl = _profile?.avatarUrl;

    return Center(
      child: Column(
        children: [
          SizedBox.square(
            dimension: 120,
            child: ClipOval(
              child: avatarBytes != null
                  ? Image.memory(avatarBytes, fit: BoxFit.cover)
                  : avatarUrl != null
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, url, error) =>
                          const Icon(Icons.person, size: 64),
                    )
                  : const ColoredBox(
                      color: Colors.black12,
                      child: Icon(Icons.person, size: 64),
                    ),
            ),
          ),
          const Gap(defaultPadding / 2),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: AppHelpers.primaryColor(context)),
            ),
            onPressed: _isSaving ? null : _pickAvatar,
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(
              avatarBytes == null ? 'Choose avatar' : 'Change avatar',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Edit profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_loadError!, textAlign: TextAlign.center),
                  const Gap(defaultPadding),
                  OutlinedButton.icon(
                    onPressed: _loadProfile,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(defaultPadding),
                children: [
                  _buildAvatarPreview(),
                  const Gap(defaultPadding),
                  TextFormField(
                    controller: _displayNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    maxLength: 80,
                    decoration: const InputDecoration(
                      labelText: 'Display name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Display name is required.'
                        : null,
                  ),
                  const Gap(defaultPadding / 2),
                  TextFormField(
                    controller: _storeNameController,
                    textInputAction: TextInputAction.next,
                    maxLength: 40,
                    decoration: const InputDecoration(
                      labelText: 'Store name',
                      hintText: 'Optional',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Gap(defaultPadding / 2),
                  const Gap(defaultPadding),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _saveProfile,
                    label: Text(_isSaving ? 'Saving...' : 'Save changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
