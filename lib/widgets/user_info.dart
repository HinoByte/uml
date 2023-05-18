import 'package:flutter/material.dart';
import 'package:uml/repository/user_repository.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    IconData roleIcon;
    String roleString;
    switch (UserRepository.instance.userRole) {
      case UserRole.student:
        roleIcon = Icons.school;
        roleString = 'Студент';
        break;
      case UserRole.teacher:
        roleIcon = Icons.menu_book;
        roleString = 'Преподаватель';
        break;
      case UserRole.administrator:
        roleIcon = Icons.admin_panel_settings;
        roleString = 'Администратор';
        break;
      default:
        roleIcon = Icons.help;
        roleString = 'Неизвестная роль';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildInfo(
          iconData: Icons.person_outline,
          textData: UserRepository.instance.currentUser?.username ??
              'Default Username',
        ),
        _buildInfo(
          iconData: Icons.account_box_outlined,
          textData: UserRepository.instance.currentUser?.name ?? 'Default Name',
        ),
        _buildInfo(
          iconData: roleIcon,
          textData: roleString,
        ),
      ],
    );
  }

  Widget _buildInfo({
    required IconData iconData,
    required String textData,
  }) {
    return Container(
      height: 45,
      width: 270,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        color: const Color(0xfff8f8f8),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 5),
          Icon(iconData),
          Expanded(
            child: Text(
              textData,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
