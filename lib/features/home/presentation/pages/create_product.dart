import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mt/core/constants/constants.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/category_entity.dart';
import 'package:mt/features/home/domain/entities/create_product_input.dart';
import 'package:mt/features/home/domain/usecases/get_categories.dart';
import 'package:mt/features/home/domain/usecases/get_product_details.dart';
import 'package:mt/features/home/domain/usecases/submit_product.dart';
import 'package:mt/features/home/domain/usecases/update_product.dart';
import 'package:mt/features/home/presentation/widgets/create_product_picked_image.dart';
import 'package:mt/features/home/presentation/widgets/create_product_section_heading.dart';
import 'package:mt/features/home/presentation/widgets/create_product_variant_fields.dart';
import 'package:mt/injection_container.dart';

class CreateProduct extends StatefulWidget {
  final int? productId;

  const CreateProduct({super.key, this.productId});

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
  bool _isConfirmingSubmission = false;
  bool _isLoadingProduct = false;
  bool _isSubmitting = false;
  String? _categoryError;
  String? _productLoadError;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.productId != null) _loadProduct();
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

  Future<void> _loadProduct() async {
    final productId = widget.productId;
    if (productId == null) return;

    setState(() {
      _isLoadingProduct = true;
      _productLoadError = null;
    });

    try {
      final product = await sl<GetProductDetails>().call(productId);
      if (!mounted) return;

      _titleController.text = product.title;
      _descriptionController.text = product.description ?? '';
      _categoryId = product.categoryId;
      _mainImage = product.mainImagePath == null
          ? null
          : CreateProductPickedImage.existing(
              previewUrl: product.mainImageUrl,
              storagePath: product.mainImagePath,
            );

      for (final variant in _variants) {
        variant.dispose();
      }
      _variants.clear();
      for (final productVariant in product.variants) {
        final fields = CreateProductVariantFields()
          ..variantId = productVariant.id
          ..nameController.text = productVariant.name
          ..priceController.text = productVariant.price.toStringAsFixed(2)
          ..stockController.text = productVariant.stockQuantity.toString();
        if (productVariant.imagePath != null) {
          fields.image = CreateProductPickedImage.existing(
            previewUrl: productVariant.imageUrl,
            storagePath: productVariant.imagePath,
          );
        }
        _variants.add(fields);
      }
      if (_variants.isEmpty) _variants.add(CreateProductVariantFields());
      setState(() => _isLoadingProduct = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _productLoadError = 'Product could not be loaded for editing.';
        _isLoadingProduct = false;
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
    if (_variants[index].variantId != null) return;
    setState(() {
      _variants.removeAt(index).dispose();
    });
  }

  Future<void> _submit() async {
    if (_isConfirmingSubmission || _isSubmitting) return;
    if (_isLoadingProduct || _productLoadError != null) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    var confirmed = false;
    setState(() => _isConfirmingSubmission = true);
    try {
      confirmed = await AppHelpers.showCenterModal(
        context,
        widget.productId == null ? 'Submit product?' : 'Save product changes?',
        widget.productId == null
            ? 'Submit "${_titleController.text.trim()}"?'
            : 'Save changes to "${_titleController.text.trim()}"?',
      );
    } catch (_) {
      if (mounted) {
        _showMessage('Error', 'Could not confirm product submission.');
      }
    } finally {
      if (mounted) setState(() => _isConfirmingSubmission = false);
    }

    if (!confirmed || !mounted) return;

    setState(() => _isSubmitting = true);
    try {
      final input = CreateProductInput(
        productId: widget.productId,
        title: _titleController.text.trim(),
        categoryId: _categoryId!,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        mainImageBytes: _mainImage?.bytes,
        mainImagePath: _mainImage?.bytes == null
            ? _mainImage?.storagePath
            : null,
        variants: _variants
            .map(
              (variant) => CreateProductVariantInput(
                variantId: variant.variantId,
                name: variant.nameController.text.trim(),
                price: double.parse(variant.priceController.text.trim()),
                stockQuantity: int.parse(variant.stockController.text.trim()),
                imageBytes: variant.image?.bytes,
                imagePath: variant.image?.bytes == null
                    ? variant.image?.storagePath
                    : null,
              ),
            )
            .toList(growable: false),
      );
      if (widget.productId == null) {
        await sl<SubmitProduct>().call(input: input);
      } else {
        await sl<UpdateProduct>().call(input: input);
      }
      if (mounted) {
        _showMessage(
          'Success',
          widget.productId == null
              ? 'Product submitted successfully.'
              : 'Product updated successfully.',
          contentType: ContentType.success,
        );
        context.pushReplacementNamed(AppRoute.myProducts);
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
      appBar: AppBar(
        title: Text(
          widget.productId == null ? 'Create product' : 'Edit product',
        ),
      ),
      body: SafeArea(
        top: false,
        child: _productLoadError != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_productLoadError!),
                    TextButton.icon(
                      onPressed: _loadProduct,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _isLoadingProduct
            ? const Center(child: CircularProgressIndicator())
            : Center(
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
                          title: 'Product thumbnail image',
                          subtitle:
                              'Choose a main image for the product listing.',
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
                                    'Add your only product or product variants here, with price and stock.\n(You can reuse your thumbnail image)',
                              ),
                            ),
                            const Gap(defaultPadding - 4),
                            IconButton.filledTonal(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: _addVariant,
                              icon: Icon(
                                Icons.add,
                                color: AppHelpers.primaryColor(context),
                              ),
                            ),
                          ],
                        ),
                        const Gap(defaultPadding),
                        for (
                          var index = 0;
                          index < _variants.length;
                          index++
                        ) ...[
                          _variantCard(index),
                          if (index < _variants.length - 1) const Gap(12),
                        ],
                        const Gap(24),
                        SizedBox(
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: _isConfirmingSubmission || _isSubmitting
                                ? null
                                : _submit,
                            label: Text(
                              _isSubmitting
                                  ? widget.productId == null
                                        ? 'Submitting...'
                                        : 'Saving...'
                                  : _isConfirmingSubmission
                                  ? 'Confirming...'
                                  : widget.productId == null
                                  ? 'Submit product'
                                  : 'Save changes',
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
      key: ValueKey(_categoryId),
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
            if (_variants.length > 1 && variant.variantId == null)
              IconButton(
                onPressed: () => _removeVariant(index),
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
          label: Text(variant.image == null ? 'Add image' : 'Change image'),
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
          child: image.bytes != null
              ? Image.memory(
                  image.bytes!,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 120,
                    child: Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                )
              : Image.network(
                  image.previewUrl ?? '',
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
