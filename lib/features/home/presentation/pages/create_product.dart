import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/category_entity.dart';
import 'package:mt/features/home/domain/entities/create_product_input.dart';
import 'package:mt/features/home/domain/usecases/get_categories.dart';
import 'package:mt/features/home/domain/usecases/submit_product.dart';
import 'package:mt/features/home/presentation/widgets/create_product_picked_image.dart';
import 'package:mt/features/home/presentation/widgets/create_product_section_heading.dart';
import 'package:mt/features/home/presentation/widgets/create_product_variant_fields.dart';
import 'package:mt/injection_container.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<CreateProductVariantFields> _variants = [
    CreateProductVariantFields(),
  ];

  List<CategoryEntity> _categories = [];
  int? _categoryId;
  CreateProductPickedImage? _mainImage;
  bool _isLoadingCategories = true;
  bool _isSubmitting = false;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final variant in _variants) {
      variant.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoryError = null;
    });

    try {
      final categories = await sl<GetCategories>().call();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _categoryError = 'Categories could not be loaded.';
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _pickMainImage() async {
    final image = await _pickImage();
    if (image == null || !mounted) return;
    setState(() => _mainImage = image);
  }

  Future<void> _pickVariantImage(CreateProductVariantFields variant) async {
    final image = await _pickImage();
    if (image == null || !mounted) return;
    setState(() => variant.image = image);
  }

  void _clearMainImage() {
    setState(() => _mainImage = null);
  }

  void _clearVariantImage(CreateProductVariantFields variant) {
    setState(() => variant.image = null);
  }

  Future<CreateProductPickedImage?> _pickImage() async {
    try {
      final file = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (file == null) return null;
      return CreateProductPickedImage(
        file: file,
        bytes: await file.readAsBytes(),
      );
    } catch (_) {
      if (!mounted) return null;
      _showMessage('Error', 'Could not open the image picker.');
      return null;
    }
  }

  void _addVariant() {
    setState(() => _variants.add(CreateProductVariantFields()));
  }

  void _removeVariant(int index) {
    if (_variants.length == 1) return;
    setState(() {
      _variants.removeAt(index).dispose();
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await sl<SubmitProduct>().call(
        input: CreateProductInput(
          title: _titleController.text.trim(),
          categoryId: _categoryId!,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          mainImageBytes: _mainImage?.bytes,
          variants: _variants
              .map(
                (variant) => CreateProductVariantInput(
                  name: variant.nameController.text.trim(),
                  price: double.parse(variant.priceController.text.trim()),
                  stockQuantity: int.parse(variant.stockController.text.trim()),
                  imageBytes: variant.image?.bytes,
                ),
              )
              .toList(growable: false),
        ),
      );
      if (mounted) {
        _showMessage(
          'Success',
          'Product submitted successfully.',
          contentType: ContentType.success,
        );
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Error', 'Product could not be submitted. Try again.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showMessage(
    String title,
    String message, {
    contentType = ContentType.failure,
  }) {
    AppHelpers.showSnackBar(context, title, message, contentType);
  }

  String? _validatePrice(String? value) {
    final input = value?.trim() ?? '';
    final price = double.tryParse(input);
    if (input.isEmpty) return 'Enter a price';
    if (price == null || !price.isFinite || price < 0) {
      return 'Enter a valid non-negative price';
    }
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(input) || price > 99999999.99) {
      return 'Use up to 2 decimals (max 99,999,999.99)';
    }
    return null;
  }

  String? _validateStock(String? value) {
    final input = value?.trim() ?? '';
    final quantity = int.tryParse(input);
    if (input.isEmpty) return 'Enter stock';
    if (quantity == null || quantity < 0) {
      return 'Enter a whole number of 0 or more';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create product')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  const CreateProductSectionHeading(
                    title: 'Product details',
                    subtitle: 'Add the information customers will see.',
                  ),
                  const Gap(defaultPadding),
                  _formSection(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 120,
                        decoration: const InputDecoration(
                          labelText: 'Product title *',
                          hintText: 'For example, Cotton shirt',
                          counterText: '',
                        ),
                        validator: (value) {
                          final title = value?.trim() ?? '';
                          if (title.runes.length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const Gap(defaultPadding),
                      _categoryField(),
                      const Gap(defaultPadding),
                      TextFormField(
                        controller: _descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 3,
                        maxLines: 6,
                        maxLength: 2000,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Describe the product',
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                  const Gap(defaultPadding * 2),
                  const CreateProductSectionHeading(
                    title: 'Product image',
                    subtitle: 'Choose a main image for the product listing.',
                  ),
                  const Gap(defaultPadding),
                  _formSection(children: [_mainImagePicker()]),
                  const Gap(defaultPadding * 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: CreateProductSectionHeading(
                          title: 'Variants',
                          subtitle:
                              'Add at least one option with price and stock.',
                        ),
                      ),
                      const Gap(defaultPadding - 4),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: _addVariant,
                        tooltip: 'Add variant',
                        icon: Icon(
                          Icons.add,
                          color: AppHelpers.primaryColor(context),
                        ),
                      ),
                    ],
                  ),
                  const Gap(defaultPadding),
                  for (var index = 0; index < _variants.length; index++) ...[
                    _variantCard(index),
                    if (index < _variants.length - 1) const Gap(12),
                  ],
                  const Gap(24),
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _isSubmitting ? null : _submit,
                      label: Text(
                        _isSubmitting ? 'Submitting...' : 'Submit product',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryField() {
    if (_isLoadingCategories) {
      return const InputDecorator(
        decoration: InputDecoration(labelText: 'Category *'),
        child: LinearProgressIndicator(minHeight: 2),
      );
    }

    if (_categoryError != null) {
      return InputDecorator(
        decoration: const InputDecoration(labelText: 'Category *'),
        child: Row(
          children: [
            Expanded(child: Text(_categoryError!)),
            TextButton(onPressed: _loadCategories, child: const Text('Retry')),
          ],
        ),
      );
    }

    return DropdownButtonFormField<int>(
      initialValue: _categoryId,
      decoration: const InputDecoration(labelText: 'Category *'),
      items: _categories
          .map(
            (category) => DropdownMenuItem<int>(
              value: category.id,
              child: Text(category.name),
            ),
          )
          .toList(growable: false),
      onChanged: (value) => setState(() => _categoryId = value),
      validator: (value) => value == null ? 'Select a category' : null,
    );
  }

  Widget _mainImagePicker() {
    final image = _mainImage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null) ...[
          _imagePreview(image, onRemove: _clearMainImage),
          const Gap(12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppHelpers.primaryColor(context)),
            ),
            onPressed: _pickMainImage,
            icon: Icon(
              image == null
                  ? Icons.add_photo_alternate_outlined
                  : Icons.edit_outlined,
            ),
            label: Text(image == null ? 'Choose image' : 'Change image'),
          ),
        ),
      ],
    );
  }

  Widget _variantCard(int index) {
    final variant = _variants[index];
    return _formSection(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Variant ${index + 1}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (_variants.length > 1)
              IconButton(
                onPressed: () => _removeVariant(index),
                tooltip: 'Remove variant',
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
        const Gap(defaultPadding - 4),
        TextFormField(
          controller: variant.nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Variant name *',
            hintText: 'For example, Standard or Small',
          ),
          validator: (value) =>
              value?.trim().isEmpty ?? true ? 'Enter a variant name' : null,
        ),
        const Gap(defaultPadding - 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 420;
            final priceField = TextFormField(
              controller: variant.priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Price *',
                prefixText: '₱',
              ),
              validator: _validatePrice,
            );
            final stockField = TextFormField(
              controller: variant.stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock *'),
              validator: _validateStock,
            );

            if (stacked) {
              return Column(
                children: [
                  priceField,
                  const Gap(defaultPadding - 4),
                  stockField,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: priceField),
                const Gap(defaultPadding - 4),
                Expanded(child: stockField),
              ],
            );
          },
        ),
        const Gap(defaultPadding - 4),
        if (variant.image != null) ...[
          _imagePreview(
            variant.image!,
            onRemove: () => _clearVariantImage(variant),
          ),
          const Gap(defaultPadding - 4),
        ],
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppHelpers.primaryColor(context)),
          ),
          onPressed: () => _pickVariantImage(variant),
          icon: Icon(
            variant.image == null
                ? Icons.add_photo_alternate_outlined
                : Icons.edit_outlined,
          ),
          label: Text(
            variant.image == null ? 'Add variant image' : 'Change image',
          ),
        ),
      ],
    );
  }

  Widget _imagePreview(
    CreateProductPickedImage image, {
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            image.bytes,
            height: 190,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox(
              height: 120,
              child: Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton.filled(
            onPressed: onRemove,
            tooltip: 'Remove image',
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  Widget _formSection({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
