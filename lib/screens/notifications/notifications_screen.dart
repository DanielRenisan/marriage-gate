import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:matrimony_flutter/providers/member_provider.dart';
import 'package:matrimony_flutter/models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _showUnreadOnly = false;
  int _currentPage = 1;
  bool _hasMoreNotifications = true;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    try {
      await memberProvider.loadNotifications(
        _currentPage, 
        _pageSize, 
        _showUnreadOnly ? true : null
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load notifications: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (!_hasMoreNotifications) return;
    
    _currentPage++;
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    try {
      final notifications = await memberProvider.loadMoreNotifications(
        _currentPage, 
        _pageSize, 
        _showUnreadOnly ? true : null
      );
      
      if (notifications.length < _pageSize) {
        _hasMoreNotifications = false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load more notifications: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    try {
      await memberProvider.markNotificationAsRead(notificationId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark notification as read: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    try {
      await memberProvider.markAllNotificationsAsRead();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All notifications marked as read'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark all notifications as read: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        actions: [
          Consumer<MemberProvider>(
            builder: (context, memberProvider, child) {
              if (memberProvider.totalUnreadCount > 0) {
                return IconButton(
                  icon: const Icon(Icons.checklist, color: Colors.white),
                  onPressed: _markAllAsRead,
                  tooltip: 'Mark all as read',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showUnreadOnly = false;
                        _currentPage = 1;
                        _hasMoreNotifications = true;
                      });
                      _loadNotifications();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showUnreadOnly ? Colors.red : Colors.grey[300],
                      foregroundColor: !_showUnreadOnly ? Colors.white : Colors.grey[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('All Notifications'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showUnreadOnly = true;
                        _currentPage = 1;
                        _hasMoreNotifications = true;
                      });
                      _loadNotifications();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showUnreadOnly ? Colors.red : Colors.grey[300],
                      foregroundColor: _showUnreadOnly ? Colors.white : Colors.grey[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Unread Only'),
                  ),
                ),
              ],
            ),
          ),
          
          // Notifications list
          Expanded(
            child: Consumer<MemberProvider>(
              builder: (context, memberProvider, child) {
                if (memberProvider.isLoadingNotifications) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }

                final notifications = _showUnreadOnly 
                    ? memberProvider.unreadNotifications 
                    : memberProvider.allNotifications;

                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'ll see your notifications here when they arrive.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadNotifications,
                  color: Colors.red,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length + (_hasMoreNotifications ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == notifications.length) {
                        // Load more button
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _loadMoreNotifications,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                elevation: 0,
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Load More Notifications'),
                            ),
                          ),
                        );
                      }

                      final notification = notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: !notification.isRead ? () => _markAsRead(notification.id) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: !notification.isRead 
                ? Border.all(color: Colors.red.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.notificationType ?? 0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getNotificationIcon(notification.notificationType ?? 0),
                  color: _getNotificationColor(notification.notificationType ?? 0),
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title ?? 'Notification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: !notification.isRead ? FontWeight.w600 : FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      notification.body ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      notification.createdDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action button for unread notifications
              if (!notification.isRead)
                IconButton(
                  onPressed: () => _markAsRead(notification.id),
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  tooltip: 'Mark as read',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(int notificationType) {
    switch (notificationType) {
      case 1: return Colors.green; // WelcomeMember
      case 2: return Colors.orange; // ForgotPasswordOtp
      case 3: return Colors.blue; // EmailVerificationOtp
      case 4: return Colors.green; // FriendRequestAccept
      case 5: return Colors.red; // FriendRequestReject
      default: return Colors.grey;
    }
  }

  IconData _getNotificationIcon(int notificationType) {
    switch (notificationType) {
      case 1: return Icons.favorite; // WelcomeMember
      case 2: return Icons.key; // ForgotPasswordOtp
      case 3: return Icons.email; // EmailVerificationOtp
      case 4: return Icons.person_add; // FriendRequestAccept
      case 5: return Icons.person_remove; // FriendRequestReject
      default: return Icons.notifications;
    }
  }
}
