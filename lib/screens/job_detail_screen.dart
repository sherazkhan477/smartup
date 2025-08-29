import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../db_helper.dart';
import '../models/job_model.dart';

class JobDetailScreen extends StatefulWidget {
  final int jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  Job? job;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  Future<void> _loadJob() async {
    final data = await DBHelper.getJobById(widget.jobId);
    setState(() {
      job = data != null ? Job.fromMap(data) : null;
      _loading = false;
    });
  }

  // Open Google Maps
  void _openMap() async {
    if (job == null) return;
    final googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${job!.lat},${job!.lng}';
    final uri = Uri.parse(googleUrl);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the map app.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening map: $e')));
    }
  }

  // Send Email
  void _sendEmail() async {
    if (job == null || job!.contact.isEmpty) return;
    final emailUrl = 'mailto:${job!.contact}';
    final uri = Uri.parse(emailUrl);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email client.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening email client: $e')));
    }
  }

  // Open WhatsApp
  void _chatOnWhatsApp() async {
    if (job == null || job!.contact.isEmpty) return;

    // Make sure the number is properly formatted (no spaces, no +)
    final phone = job!.contact.replaceAll(RegExp(r'[^\d]'), '');
    final whatsappUrl =
        "https://wa.me/$phone?text=Hi, I'm interested in your job posting.";

    final uri = Uri.parse(whatsappUrl);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error opening WhatsApp: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (job == null) {
      return const Scaffold(body: Center(child: Text('Job not found')));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          job!.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              shadowColor: Colors.teal.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(
                        Icons.work,
                        size: 50,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      job!.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildInfoChip(
                          icon: Icons.person,
                          label: "Vendor: ${job!.vendorId}",
                          color: Colors.teal,
                        ),
                        _buildInfoChip(
                          icon: Icons.monetization_on,
                          label: "£${job!.rate}",
                          color: Colors.orange,
                        ),
                        _buildInfoChip(
                          icon: Icons.location_on,
                          label: job!.locationName,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  label: "Map",
                  icon: Icons.location_on,
                  color: Colors.blueAccent,
                  onPressed: _openMap,
                ),
                _buildActionButton(
                  label: "Email",
                  icon: Icons.email,
                  color: Colors.green,
                  onPressed: _sendEmail,
                ),
                _buildActionButton(
                  label: "WhatsApp",
                  icon: Icons.chat,
                  color: Colors.teal,
                  onPressed: _chatOnWhatsApp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      shape: const StadiumBorder(
        side: BorderSide(color: Colors.black87, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        elevation: 5,
        shadowColor: color.withOpacity(0.4),
      ),
    );
  }
}
