import 'package:flutter/material.dart';
import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/colors.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: info.spacing(ResponsiveSpacing.lg),
              ),
              child: Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                    
                    // Header shimmer
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(width: info.spacing(ResponsiveSpacing.md)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 12,
                                color: AppColors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 120,
                                height: 16,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: info.spacing(ResponsiveSpacing.lg)),

                    // Card shimmer
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    SizedBox(height: info.spacing(ResponsiveSpacing.lg)),

                    // Action buttons shimmer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        4,
                        (index) => Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 40,
                              height: 12,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: info.spacing(ResponsiveSpacing.xl)),

                    // Transaction items shimmer
                    ...List.generate(
                      4,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: info.spacing(ResponsiveSpacing.sm),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
