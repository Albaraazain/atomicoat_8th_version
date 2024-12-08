// lib/features/home/presentation/screens/home_screen.dart
import 'package:experiment_planner/features/auth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/bloc/auth_event.dart';
import '../../../auth/bloc/auth_state.dart';
import '../../../../enums/user_role.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.maybeMap(
          authenticated: (authenticated) =>
              _AuthenticatedView(user: authenticated.user),
          orElse: () => const CircularProgressIndicator(),
        );
      },
    );
  }
}

class _AuthenticatedView extends StatelessWidget {
  final User user;

  const _AuthenticatedView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALD System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEvent.signOut());
            },
          ),
        ],
      ),
      drawer: _AppDrawer(user: user),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (user.role) {
      case UserRole.admin:
        return const _AdminDashboard();
      case UserRole.operator:
        return const _OperatorDashboard();
      case UserRole.engineer:
        return const _EngineerDashboard();
      default:
        return const _UserDashboard();
    }
  }
}

class _AppDrawer extends StatelessWidget {
  final User user;

  const _AppDrawer({required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              child: Text(user.name[0].toUpperCase()),
            ),
          ),
          _buildMenuItems(context),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final List<Widget> menuItems = [
      ListTile(
        leading: const Icon(Icons.dashboard),
        title: const Text('Dashboard'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ];

    // Add role-specific menu items
    switch (user.role) {
      case UserRole.admin:
        menuItems.addAll([
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('User Management'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to user management
            },
          ),
        ]);
        break;
      case UserRole.engineer:
        menuItems.addAll([
          ListTile(
            leading: const Icon(Icons.engineering),
            title: const Text('System Configuration'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to system configuration
            },
          ),
        ]);
        break;
      default:
        break;
    }

    // Common menu items for all roles
    menuItems.addAll([
      ListTile(
        leading: const Icon(Icons.build),
        title: const Text('Maintenance'),
        onTap: () {
          Navigator.pop(context);
          // TODO: Navigate to maintenance
        },
      ),
      ListTile(
        leading: const Icon(Icons.analytics),
        title: const Text('System Status'),
        onTap: () {
          Navigator.pop(context);
          // TODO: Navigate to system status
        },
      ),
    ]);

    return Column(children: menuItems);
  }
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: const [
        _DashboardCard(
          title: 'User Management',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _DashboardCard(
          title: 'System Overview',
          icon: Icons.dashboard,
          color: Colors.green,
        ),
        _DashboardCard(
          title: 'Maintenance',
          icon: Icons.build,
          color: Colors.orange,
        ),
        _DashboardCard(
          title: 'Reports',
          icon: Icons.assessment,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _OperatorDashboard extends StatelessWidget {
  const _OperatorDashboard();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: const [
        _DashboardCard(
          title: 'System Control',
          icon: Icons.power_settings_new,
          color: Colors.green,
        ),
        _DashboardCard(
          title: 'Process Monitor',
          icon: Icons.monitor,
          color: Colors.blue,
        ),
        _DashboardCard(
          title: 'Maintenance',
          icon: Icons.build,
          color: Colors.orange,
        ),
        _DashboardCard(
          title: 'Alarms',
          icon: Icons.warning,
          color: Colors.red,
        ),
      ],
    );
  }
}

class _EngineerDashboard extends StatelessWidget {
  const _EngineerDashboard();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: const [
        _DashboardCard(
          title: 'System Configuration',
          icon: Icons.settings,
          color: Colors.blue,
        ),
        _DashboardCard(
          title: 'Maintenance',
          icon: Icons.build,
          color: Colors.orange,
        ),
        _DashboardCard(
          title: 'Diagnostics',
          icon: Icons.bug_report,
          color: Colors.purple,
        ),
        _DashboardCard(
          title: 'Reports',
          icon: Icons.assessment,
          color: Colors.green,
        ),
      ],
    );
  }
}

class _UserDashboard extends StatelessWidget {
  const _UserDashboard();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      children: const [
        _DashboardCard(
          title: 'System Status',
          icon: Icons.info,
          color: Colors.blue,
        ),
        _DashboardCard(
          title: 'Reports',
          icon: Icons.assessment,
          color: Colors.green,
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to respective screen
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
