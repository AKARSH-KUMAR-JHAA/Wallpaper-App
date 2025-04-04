import 'package:flutter/material.dart';

class ForgetPassBtnWidget extends StatelessWidget {
  const ForgetPassBtnWidget({
    super.key,
    required this.size,
    required this.iconbtn,
    required this.title,
    required this.subtitle,
    required this.onTap

  });

  final Size size;
  final IconData iconbtn;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: onTap,
      child: Container(
        height: 110,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.grey.shade300),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(
                iconbtn,
                size: 70,
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
