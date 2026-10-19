import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:fuzzy_bolt/fuzzy_bolt.dart';
import 'package:go_router/go_router.dart';
import 'package:mt/core/router/routes.dart';
import 'package:mt/core/utils/helpers.dart';
import 'package:mt/features/home/domain/entities/product_title_entity.dart';
import 'package:mt/features/home/domain/usecases/get_all_product_titles.dart';
import 'package:mt/injection_container.dart';

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class SearchForm extends StatefulWidget {
  final String? searchQuery;
  const SearchForm({super.key, this.searchQuery});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _debouncer = sl<Debouncer>();
  late List<ProductTitleEntity> _titles = [];
  bool _isLoading = true;
  List<ProductTitleEntity> _textMatches = [];
  List<FuzzyResult<ProductTitleEntity>> _fuzzyMatches = [];
  int _searchRequest = 0;
  static const _maxSuggestions = 12;

  @override
  void initState() {
    super.initState();
    if (widget.searchQuery != null) {
      _controller.text = widget.searchQuery!;
    }
    _loadProductTitles();
  }

  @override
  void dispose() {
    _debouncer.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadProductTitles() async {
    try {
      final titles = await sl<GetProductTitles>().call();

      if (!mounted) return;
      setState(() {
        _titles = titles;
        _isLoading = false;
      });
    } catch (error) {
      AppHelpers.logger().error(error);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onQueryChanged(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    final request = ++_searchRequest;

    _debouncer.debounce(
      duration: const Duration(milliseconds: 300),
      onDebounce: () async {
        if (normalizedQuery.isEmpty) {
          if (!mounted) return;
          setState(() {
            _textMatches = [];
            _fuzzyMatches = [];
          });
          return;
        }

        final textMatches = _titles
            .where((item) => item.title.toLowerCase().contains(normalizedQuery))
            .take(_maxSuggestions)
            .toList();

        final fuzzyMatches = textMatches.isNotEmpty
            ? <FuzzyResult<ProductTitleEntity>>[]
            : await FuzzyBolt.searchWithScores<ProductTitleEntity>(
                _titles,
                normalizedQuery,
                selectors: [(item) => item.title.toLowerCase()],
                maxResults: _maxSuggestions,
                skipIsolate: kIsWeb,
              );

        if (!mounted || request != _searchRequest) return;
        setState(() {
          _textMatches = textMatches;
          _fuzzyMatches = fuzzyMatches;
        });
      },
    );
  }

  void _openProductResults(String query) {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return;

    context.pushNamed(AppRoute.products, extra: {'query': normalizedQuery});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            errorBorder: outlineInputBorder,
          ),
          onChanged: _onQueryChanged,
          onSubmitted: (query) {
            _openProductResults(query);
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _onQueryChanged('');
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) {
                final textMatchCount = _textMatches.length;
                final resultCount = textMatchCount + _fuzzyMatches.length;

                return ListView.separated(
                  itemCount: resultCount,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      height: 1,
                      indent: 10,
                      endIndent: 10,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (index < textMatchCount) {
                      final item = _textMatches[index];

                      return ListTile(
                        trailing: const Icon(
                          Icons.arrow_right_rounded,
                          size: 30,
                        ),
                        title: Text(item.title),
                        onTap: () {
                          _openProductResults(item.title);
                        },
                      );
                    }

                    final result = _fuzzyMatches[index - textMatchCount];

                    return ListTile(
                      trailing: const Icon(Icons.arrow_right_rounded),
                      title: Text(result.item.title),
                      onTap: () {
                        _openProductResults(result.item.title);
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
