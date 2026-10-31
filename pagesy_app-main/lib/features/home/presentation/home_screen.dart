import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pagesy_frontend/core/constants/app_colors.dart';

import '../../../core/navigation/app_navigation.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

// 1. Query GraphQL dengan Parameter Variabel userId
const String getHomeDataQuery = r"""
  query GetHomeData($userId: ID!) {
    homeData(user_id: $userId) {
      user {
        name
        username
      }
      streak {
        currentStreak
        longestStreak
        revivalQuotaRemaining
      }
      readingBooks {
        id
        currentPage
        status
        book {
          title
          page_count   # Diubah dari pageCount
          publisher
          authors {
            author_name
          }
        }
      }
      recommendations {
        id
        title
        page_count     # Diubah dari pageCount
        first_publish_year # Diubah dari firstPublishYear
        authors {
          author_name
        }
      }
    }
  }
""";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getHomeDataQuery),
        variables: const {
          'userId':
              '1', // Mengirim argumen user_id yang wajib di backend Laravel
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
      builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        // Handle Error State
        if (result.hasException) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Gagal memuat data dari server:\n${result.exception.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          );
        }

        // Handle Loading State
        if (result.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        // Ambil data hasil query GraphQL Laravel
        final data = result.data?['homeData'];
        final user = data?['user'];
        final streak = data?['streak'];
        final readingBooks = data?['readingBooks'] as List? ?? [];
        final recommendations = data?['recommendations'] as List? ?? [];

        final userName = user?['name'] ?? 'Bima';
        final currentStreak = streak?['currentStreak'] ?? 0;
        final revivalQuota = streak?['revivalQuotaRemaining'] ?? 3;

        // Ambil buku yang sedang dibaca pertama (jika ada)
        final activeReadingBook = readingBooks.isNotEmpty
            ? readingBooks[0]
            : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Section (Dinamis dengan Data User & Streak)
                  _buildHeader(userName, currentStreak),
                  const SizedBox(height: 16),

                  // 2. Reading Streak Card (Dinamis)
                  _buildStreakCard(currentStreak, revivalQuota),
                  const SizedBox(height: 20),

                  // 3. Currently Reading Section (Dinamis dari Tabel user_books)
                  _buildCurrentlyReadingCard(activeReadingBook),
                  const SizedBox(height: 24),

                  // 4. Recommendation by Genre (Dari Database)
                  _buildBookSectionFromApi(
                    title: 'Rekomendasi Berdasarkan Genre',
                    subtitle: 'Buku yang Mungkin Cocok Untuk Kamu',
                    rawBooks: recommendations,
                  ),
                  const SizedBox(height: 24),

                  // 5. Recommendation by Trend (Dari Database)
                  _buildBookSectionFromApi(
                    title: 'Rekomendasi Berdasarkan Trend',
                    subtitle: 'Koleksi Buku Favorit Pengguna Lainnya',
                    rawBooks: recommendations,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // 6. Bottom Navigation Bar
          bottomNavigationBar: const AppBottomNavBar(currentTab: MainTab.home),
        );
      },
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeader(String userName, int streakCount) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFEAD8CD),
          child: Text(
            userName.isNotEmpty ? userName[0].toUpperCase() : 'B',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pagesy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Halo, $userName',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Streak Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$streakCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCard(int currentStreak, int revivalQuota) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3EC), Color(0xFFFFF9F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3E3D8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFEED5C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$currentStreak Hari Beruntun',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.streakGreenBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              size: 12,
                              color: AppColors.streakGreen,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Streak Hidup',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.streakGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tetap jaga konsistensi membaca harianmu',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEED5C7)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.refresh, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              const Text(
                'Jatah Revival Bulanan:',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tagOrangeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sisa ${revivalQuota}x Revival Bulan Ini',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentlyReadingCard(Map<String, dynamic>? activeBook) {
    if (activeBook == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'Belum ada buku yang sedang dibaca. Cari buku yuk!',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final bookInfo = activeBook['book'];
    final title = bookInfo?['title'] ?? 'Tanpa Judul';
    final pageCount = bookInfo?['pageCount'] ?? 100;
    final currentPage = activeBook['currentPage'] ?? 0;
    final authorName = (bookInfo?['authors'] as List?)?.isNotEmpty == true
        ? bookInfo['authors'][0]['author_name']
        : 'Penulis Tidak Diketahui';

    final double progress = pageCount > 0
        ? (currentPage / pageCount).clamp(0.0, 1.0)
        : 0.0;
    final int percent = (progress * 100).toInt();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.menu_book, color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Text(
                  'Sedang Dibaca',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.streakGreenBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Status: Progress',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.streakGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 125,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E0DA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BUKU AKTIF',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Serif',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          authorName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Halaman $currentPage dari $pageCount',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '$percent%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFE8E2DC),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookSectionFromApi({
    required String title,
    required String subtitle,
    required List<dynamic> rawBooks,
  }) {
    if (rawBooks.isEmpty) return const SizedBox.shrink();

    // Ambil max 2 buku untuk ditampilkan di section
    final displayBooks = rawBooks.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: displayBooks.map((bookData) {
            final bookTitle = bookData['title'] ?? 'Tanpa Judul';
            final authors = bookData['authors'] as List?;
            final authorName = authors?.isNotEmpty == true
                ? authors![0]['author_name']
                : 'Penulis';
            final pages = '${bookData['pageCount'] ?? 150} Hal';

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right:
                      displayBooks.indexOf(bookData) == displayBooks.length - 1
                      ? 0
                      : 12,
                ),
                child: _buildBookCardItem(
                  title: bookTitle,
                  author: authorName,
                  pages: pages,
                  estTime: '~ 4.0 Jam',
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBookCardItem({
    required String title,
    required String author,
    required String pages,
    required String estTime,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E3DD),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            author,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                pages,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
