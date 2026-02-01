import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/search_result.dart';
import '../bloc/search_bloc.dart';
import '../../../../core/constants/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari panduan, video...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onChanged: (query) {
            context.read<SearchBloc>().add(SearchQueryChanged(query));
          },
        ),
        backgroundColor: AppColors.blueSoft,
        foregroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchError) {
            return Center(child: Text(state.message));
          } else if (state is SearchEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ditemukan hasil untuk "${_searchController.text}"',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ],
              ),
            );
          } else if (state is SearchLoaded) {
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final result = state.results[index];
                return ListTile(
                  leading: _buildIcon(result.type),
                  title: Text(
                    result.title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    result.description,
                    style: GoogleFonts.nunito(
                      color: AppColors.grayText.withOpacity(0.7),
                    ),
                  ),
                  onTap: () {
                    _navigateToResult(context, result);
                  },
                );
              },
            );
          }
          return Center(
            child: Text(
              'Ketik untuk mulai mencari',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(SearchResultType type) {
    switch (type) {
      case SearchResultType.infographic:
        return const Icon(Icons.image, color: Colors.blue);
      case SearchResultType.stepByStep:
        return const Icon(Icons.list_alt, color: Colors.green);
      case SearchResultType.video:
        return const Icon(Icons.play_circle_outline, color: Colors.red);
      case SearchResultType.emergency:
        return const Icon(Icons.warning_amber_rounded, color: Colors.orange);
    }
  }

  void _navigateToResult(BuildContext context, SearchResult result) {
    if (result.type == SearchResultType.infographic &&
        result.extraData != null) {
      context.push(result.route, extra: result.extraData!['infographic']);
    } else if (result.type == SearchResultType.stepByStep &&
        result.extraData != null) {
      context.push(result.route, extra: result.extraData!['step']);
    } else if (result.type == SearchResultType.video &&
        result.extraData != null) {
      // Create a map that matches what VideoPlayerPage expects: Map<String, String>
      final Map<String, String> args = {
        'url': result.extraData!['url'] as String,
        'title': result.extraData!['title'] as String,
      };
      context.push(result.route, extra: args);
    } else {
      context.push(result.route);
    }
  }
}
