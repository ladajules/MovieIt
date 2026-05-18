import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieit/theme/movieit_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.movieItTheme;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: theme.glassSurface,
            border: Border(
              top: BorderSide(color: theme.glassBorder, width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'icons/popcorn_icon.png',
                        color: theme.textPrimary,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'MovieIT',
                        style: GoogleFonts.bagelFatOne(
                          color: theme.textPrimary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Made with love by:',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _FooterLink(
                        name: 'Jules Gimenez',
                        url: 'https://github.com/ladajules',
                      ),
                      SizedBox(width: 10),
                      _FooterLink(
                        name: 'Gaea Mutia',
                        url: 'https://github.com/Gaeano',
                      ),
                      SizedBox(width: 10),
                      _FooterLink(
                        name: 'Althea Telmo',
                        url: 'https://github.com/xysonie',
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Divider(color: theme.glassBorder, thickness: 1),
                  const SizedBox(height: 10),
                  Text(
                    '\u00a9 ${DateTime.now().year} MovieIt. All rights reserved.',
                    style: TextStyle(color: theme.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String name;
  final String url;

  const _FooterLink({required this.name, required this.url});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.movieItTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launchUrl,
        child: Text(
          widget.name,
          style: TextStyle(
            color: _isHovered ? theme.accent : theme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            decoration:
                _isHovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: theme.accent,
          ),
        ),
      ),
    );
  }
}
