import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagementController extends GetxController {
  var isLoading = false.obs;
  var currentSection = 'Dashboard'.obs;

  // Management sections
  final List<ManagementSection> sections = [
    ManagementSection(
      title: 'Team Management',
      icon: Icons.people_alt_rounded,
      items: [
        // Associate lawyers
        ManagementItem(
          title: 'Associate Lawyers',
          subtitle: 'Manage your legal team',
          icon: Icons.person_add_alt_1_rounded,
          route: '/associate-lawyers',
          color: 0xFF4299E1,
        ),

        // Juniors
        ManagementItem(
          title: 'Junior Lawyers',
          subtitle: 'Manage junior legal staff',
          icon: Icons.people_outline_rounded,
          route: '/junior-lawyers',
          color: 0xFF48BB78,
        ),

        ManagementItem(
          title: 'Legal Assistants',
          subtitle: 'Manage support staff',
          icon: Icons.assistant_rounded,
          route: '/legal-assistants',
          color: 0xFFED8936,
        ),
        ManagementItem(
          title: 'Client Management',
          subtitle: 'Manage all clients',
          icon: Icons.contacts_rounded,
          route: '/client-management',
          color: 0xFF9F7AEA,
        ),
      ],
    ),
    ManagementSection(
      title: 'Case Management',
      icon: Icons.folder_open_rounded,
      items: [
        ManagementItem(
          title: 'Case Categories',
          subtitle: 'Organize case types',
          icon: Icons.category_rounded,
          route: '/case-categories',
          color: 0xFFF56565,
        ),
        ManagementItem(
          title: 'Court Management',
          subtitle: 'Manage courts and venues',
          icon: Icons.account_balance_rounded,
          route: '/court-management',
          color: 0xFF38B2AC,
        ),
        ManagementItem(
          title: 'Case Templates',
          subtitle: 'Pre-defined case templates',
          icon: Icons.description_rounded,
          route: '/case-templates',
          color: 0xFFED64A6,
        ),
        ManagementItem(
          title: 'Billing Setup',
          subtitle: 'Configure billing rates',
          icon: Icons.attach_money_rounded,
          route: '/billing-setup',
          color: 0xFF48BB78,
        ),
      ],
    ),
    ManagementSection(
      title: 'System Settings',
      icon: Icons.settings_rounded,
      items: [
        ManagementItem(
          title: 'Appearance',
          subtitle: 'Theme and display settings',
          icon: Icons.palette_rounded,
          route: '/appearance',
          color: 0xFF667EEA,
        ),
        ManagementItem(
          title: 'Notifications',
          subtitle: 'Manage alerts and reminders',
          icon: Icons.notifications_active_rounded,
          route: '/notifications',
          color: 0xFFF6AD55,
        ),
        ManagementItem(
          title: 'Backup & Sync',
          subtitle: 'Data backup and synchronization',
          icon: Icons.cloud_sync_rounded,
          route: '/backup-sync',
          color: 0xFF4FD1C7,
        ),
        ManagementItem(
          title: 'Security',
          subtitle: 'Privacy and security settings',
          icon: Icons.security_rounded,
          route: '/security',
          color: 0xFFFC8181,
        ),
      ],
    ),
    ManagementSection(
      title: 'Tools & Utilities',
      icon: Icons.build_rounded,
      items: [
        ManagementItem(
          title: 'Document Templates',
          subtitle: 'Legal document templates',
          icon: Icons.article_rounded,
          route: '/document-templates',
          color: 0xFF68D391,
        ),
        ManagementItem(
          title: 'Time Tracking',
          subtitle: 'Configure time tracking',
          icon: Icons.timer_rounded,
          route: '/time-tracking',
          color: 0xFFD69E2E,
        ),
        ManagementItem(
          title: 'Reporting',
          subtitle: 'Generate case reports',
          icon: Icons.analytics_rounded,
          route: '/reporting',
          color: 0xFF63B3ED,
        ),
        ManagementItem(
          title: 'Calendar Settings',
          subtitle: 'Configure calendar views',
          icon: Icons.calendar_today_rounded,
          route: '/calendar-settings',
          color: 0xFFB794F4,
        ),
      ],
    ),
  ];

  void setCurrentSection(String section) {
    currentSection.value = section;
  }

  void navigateToRoute(String route) {
    // Show coming soon for unimplemented routes
    if (!_isRouteImplemented(route)) {
      Get.snackbar(
        'Coming Soon',
        'This feature will be available soon',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF1A365D),
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(route);
  }

  bool _isRouteImplemented(String route) {
    // Add routes that are already implemented
    final implementedRoutes = [
      '/associate-lawyers',
      '/client-management',
      // Add other implemented routes here
    ];

    return implementedRoutes.contains(route);
  }

  void refreshData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }
}

class ManagementSection {
  final String title;
  final IconData icon;
  final List<ManagementItem> items;

  ManagementSection({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class ManagementItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final int color;

  ManagementItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
  });

  Color get colorValue => Color(color);
}