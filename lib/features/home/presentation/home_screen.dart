import 'package:flutter/material.dart';
import 'package:dhikru_linda_flutter/networks/api_acess.dart';
import 'package:dhikru_linda_flutter/features/home/model/home_data_model.dart';
import 'package:dhikru_linda_flutter/features/home/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onGoProfile;
  final VoidCallback? onGoJournal;
  const HomeScreen({super.key, this.onGoProfile, this.onGoJournal});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getProfileRxObj.getProfileInfo();
    homeDataRxObj.getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).padding.top + 16,
            bottom: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeTopBar(onGoProfile: widget.onGoProfile),
              const SizedBox(height: 6),
              const HomeGreetingName(),
              const SizedBox(height: 24),
              const HomePortalCard(),
              const SizedBox(height: 24),
              StreamBuilder<HomeDataModel>(
                stream: homeDataRxObj.getHomeDataStream,
                builder: (context, snapshot) {
                  final isLoading =
                      snapshot.connectionState == ConnectionState.waiting;
                  final data = snapshot.hasData ? snapshot.data?.data : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeStatsRow(data: data, isLoading: isLoading),
                      const SizedBox(height: 32),
                      HomeRecentDreamsSection(
                        data: data,
                        isLoading: isLoading,
                        onGoJournal: widget.onGoJournal,
                      ),
                      const SizedBox(height: 32),
                      HomeWeeklyInsightSection(
                        data: data,
                        isLoading: isLoading,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
