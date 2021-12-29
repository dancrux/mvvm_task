import 'package:flutter/material.dart';
import 'package:mvvm_task/constants/colors.dart';
import 'package:mvvm_task/constants/styles.dart';
import 'package:mvvm_task/db/shared_prefs_db.dart';
import 'package:mvvm_task/network/model/medicine_model.dart';
import 'package:mvvm_task/network/repository.dart';
import 'package:mvvm_task/utitlities/size_config.dart';
import 'package:mvvm_task/utitlities/spacing.dart';
import 'package:mvvm_task/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final String userEmail;
  HomeScreen({Key? key, required this.userEmail}) : super(key: key);

  late Future<List<Medicine>> medItemList;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    medItemList = homeProvider.getMedInfo(context);
    List<Medicine>? medicine = List.empty();
    Repository repository = Repository();
    SharedPrefsUtil sharedPrefsUtil = SharedPrefsUtil();
    sharedPrefsUtil.saveEmail(userEmail);
    String greeting() {
      var currentTime = DateTime.now().hour;
      if (currentTime <= 12) {
        return 'Good Morning';
      } else if ((currentTime > 12) && (currentTime <= 16)) {
        return 'Good Afternoon';
      } else if ((currentTime > 16) && (currentTime < 20)) {
        return 'Good Evening';
      } else {
        return 'Good Night';
      }
    }

    String greetingMessage = greeting();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.mediumHeight(),
              Text(
                greetingMessage,
                style: AppStyles.heading2,
              ),
              Spacing.smallHeight(),
              FutureBuilder(
                  future: sharedPrefsUtil.getEmail('userEmail'),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData ? snapshot.data.toString() : userEmail,
                      style: AppStyles.heading1,
                    );
                  }),
              Flexible(
                child: FutureBuilder<List<Medicine>>(
                    future: medItemList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        medicine = snapshot.data;
                      }
                      return Consumer(
                          builder: (context, HomeViewModel user, _) {
                        switch (user.state) {
                          case HomeState.loading:
                            return const Center(
                                child: CircularProgressIndicator());

                          case HomeState.completed:
                            return ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: getProportionateScreenHeight(14),
                                  );
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: medicine!.length,
                                itemBuilder: (context, index) => MedcineItem(
                                      medicine: medicine![index],
                                    ));
                          case HomeState.error:
                            return const Center(
                                child:
                                    Text('Something Went Wrong Please Retry '));

                          default:
                            return const Center(
                                child:
                                    Text('Something Went Wrong Please Retry'));
                        }
                      });

                      // homeProvider.state == HomeState.loading
                      //     ? const Center(child: CircularProgressIndicator())
                      //     :
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MedcineItem extends StatelessWidget {
  final Medicine medicine;

  const MedcineItem({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        height: getProportionateScreenHeight(240),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.neutralGrey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 9)
            ],
            color: Colors.white,
            border: Border.all(width: 2.0, color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(26)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${medicine.name}'),
            Spacing.mediumHeight(),
            Text('${medicine.dose}', maxLines: 3, style: AppStyles.heading5),
            Spacing.mediumHeight(),
            Text('${medicine.strength}'),
          ],
        ),
      ),
    );
  }
}
