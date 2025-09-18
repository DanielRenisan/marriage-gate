class NotificationItem {
  final String id;
  final String? title;
  final String? body;
  final dynamic payload;
  final NotificationPayload? parsedPayload;
  final int? notificationType;
  final String? receivedProfileId;
  final String? receivedUserId;
  final bool isRead;
  final String? readAt;
  final String createdDate;

  NotificationItem({
    required this.id,
    this.title,
    this.body,
    this.payload,
    this.parsedPayload,
    this.notificationType,
    this.receivedProfileId,
    this.receivedUserId,
    required this.isRead,
    this.readAt,
    required this.createdDate,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    NotificationPayload? parsedPayload;
    
    try {
      if (json['payload'] != null) {
        if (json['payload'] is String) {
          // Try to parse JSON string
          final payloadMap = json['payload'] as Map<String, dynamic>?;
          if (payloadMap != null) {
            parsedPayload = NotificationPayload.fromJson(payloadMap);
          }
        } else if (json['payload'] is Map<String, dynamic>) {
          parsedPayload = NotificationPayload.fromJson(json['payload']);
        }
      }
    } catch (e) {
      // If parsing fails, set to null
      parsedPayload = null;
    }

    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'],
      body: json['body'],
      payload: json['payload'],
      parsedPayload: parsedPayload,
      notificationType: json['notificationType'],
      receivedProfileId: json['receivedProfileId'],
      receivedUserId: json['receivedUserId'],
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'],
      createdDate: _formatDateAndTime(json['createdDate'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'parsedPayload': parsedPayload?.toJson(),
      'notificationType': notificationType,
      'receivedProfileId': receivedProfileId,
      'receivedUserId': receivedUserId,
      'isRead': isRead,
      'readAt': readAt,
      'createdDate': createdDate,
    };
  }

  static String _formatDateAndTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateTimeString;
    }
  }
}

class NotificationPayload {
  final String? profileId;
  final String? imageUrl;

  NotificationPayload({
    this.profileId,
    this.imageUrl,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      profileId: json['ProfileId'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProfileId': profileId,
      'ImageUrl': imageUrl,
    };
  }
}

enum NotificationType {
  welcomeMember(1),
  forgotPasswordOtp(2),
  emailVerificationOtp(3),
  friendRequestAccept(4),
  friendRequestReject(5);

  const NotificationType(this.value);
  final int value;
}
