
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movieit/models/sources_model.dart';
import 'package:url_launcher/url_launcher.dart';

class WhereToWatchSection extends StatelessWidget{
  final List<Sources>? sources;
  
  const WhereToWatchSection({super.key, this.sources});



  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(label: 'Where to Watch'),
        const SizedBox(height: 20),

        if (sources == null || sources!.isEmpty)
          const Text(
            'No streaming sources available.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          )
        else
          Wrap(
            spacing: 2.0,
            runSpacing: 16,
            children: sources!.map((source) => _buildSourceItem(source)).toList(),
          ),
      ],
    );
  }

  Widget _buildSourceItem(Sources source){
    return InkWell(
      onTap: () async {
        final url = Uri.parse(source.link);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: source.logoUrl != null
                      ? Image.network(
                          source.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                              Logger log = Logger ();
                            log.e('Failed to load image for ${source.name} at ${source.logoUrl}: $error');
                            return const Icon(Icons.tv, color: Colors.white54);
                          },
                        )
                      : const Icon(Icons.tv, color: Colors.white54),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                source.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String label;
  const _SectionHeading({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFFE53935), width: 3),
        ),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}
