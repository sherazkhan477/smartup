import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/category.dart';
import '../models/job_model.dart';
import 'job_detail_screen.dart';

class JobListScreen extends StatefulWidget {
  final String categoryName;

  const JobListScreen({super.key, required this.categoryName});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  List<Job> _jobs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final jobs = await DBHelper.getJobsByCategory(widget.categoryName);
      setState(() {
        _jobs = jobs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      debugPrint('Error loading jobs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.green.shade700,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _jobs.isEmpty
          ? Center(
              child: Text(
                "No jobs available in this category",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _jobs.length,
              itemBuilder: (context, index) {
                final job = _jobs[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      job.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(job.description),
                    trailing: Text('£${job.rate}/hr'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailScreen(jobId: job.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
