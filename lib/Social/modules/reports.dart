import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_test/Constants/Componants.dart';
import 'package:social_test/Models/report_mode.dart';
import 'package:social_test/Social/App%20Cubit/cubit.dart';
import 'package:social_test/Social/App%20Cubit/cubit_states.dart';
import 'package:social_test/Social/modules/reported_post.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..GetPostsData()
        ..getReports(), // Initiating getReports when the widget is built

      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is Get_Reported_Post)
            Navigat(context, ReportedPost(postModel: state.post));
          if (state is Get_Reported_Post_Failure) {
            print('no');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load the reported post')),
            );
          }
          if (state is Get_Reports_Failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load reports')),
            );
          }
        },
        builder: (context, state) {
          var reports = context.read<SocialCubit>().reports;

          if (state is Get_Reports_Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Get_Reports_Failure) {
            return const Center(child: Text('Failed to load reports'));
          } else if (reports.isEmpty) {
            return const Center(child: Text('No reports found'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                ReportMode report = reports[index];

                return GestureDetector(
                  onTap: () {
                    print("object");
                    SocialCubit.get(context).getReportedPost(report.postId);
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                report
                                    .report, // Assuming authorId is a user name
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                report.reportTime, // Display report time
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            report.report, // Display the report text
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.flag, color: Colors.redAccent),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
