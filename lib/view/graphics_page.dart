import 'package:finalexam_salaries/view/UI_functions.dart';
import 'package:flutter/material.dart';

class GraphicsPageScreen extends StatefulWidget {
  const GraphicsPageScreen({super.key});

  @override
  State<GraphicsPageScreen> createState() => _GraphicsPageScreenState();
}

class _GraphicsPageScreenState extends State<GraphicsPageScreen> {

  String currentDataSet = 'ai';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.brightness == Brightness.light
                ? Colors.white
                : Colors.black,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Analytics",
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: "AI Careers",
                  style: currentDataSet == 'ai' ? 'primary' : 'secondary',
                  onPressed: () {
                    setState(() {
                      currentDataSet = 'ai';
                    });
                  },
                ),
                SizedBox(width:20),
                CustomButton(
                  text: "Software Engineering", 
                  style: currentDataSet == 'se' ? 'primary' : 'secondary',
                  onPressed: () {
                    setState(() {
                      currentDataSet = 'se';
                    });
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}