import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class PatientHistoryAi extends StatefulWidget {
  const PatientHistoryAi({
    super.key,
    required this.patientId,
  });

  final String patientId;

  @override
  State<PatientHistoryAi> createState() => _PatientHistoryAiState();
}

class _PatientHistoryAiState extends State<PatientHistoryAi>  with SingleTickerProviderStateMixin {
  bool isLoading = true; // Track loading state
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    fetchAiData(); // Call API when screen loads
  }

   @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchAiData() async {
    Doctorprovider patientpageprovider = context.read<Doctorprovider>();
   

    await patientpageprovider.getpatienthistoryairesponse(widget.patientId);
    setState(() {
      isLoading = false; 
    });
  }

  Widget _buildShimmerEffect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Analyzing message with animated dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: Color(0XFF0857C0),
              size: 24,
            ),
            SizedBox(width: 8),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                int dotCount = ((_animationController.value * 3) % 4).floor();
                return Text(
                  "Analysing Profile${"." * dotCount}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF0857C0),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 30),
        
        // Animated shimmer lines
        ...List.generate(8, (index) => Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                height: 16,
                width: index.isEven 
                    ? double.infinity 
                    : MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[300]!,
                      Colors.grey[100]!,
                      Colors.grey[300]!,
                    ],
                    stops: [
                      _animationController.value - 0.3,
                      _animationController.value,
                      _animationController.value + 0.3,
                    ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
                    begin: Alignment(-1.0, 0.0),
                    end: Alignment(1.0, 0.0),
                  ),
                ),
              );
            },
          ),
        )),
      ],
    );
  }

  Widget _buildImportantDisclaimer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.4,
          ),
          children:const [
            TextSpan(
              text: "Important: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextSpan(
              text: "Health information provided by AI analysis is for ",
            ),
            TextSpan(
              text: "educational purposes only ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: "and is not a substitute for professional medical advice. Always consult your healthcare provider for personal guidance.",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Doctorprovider patientpageprovider = context.read<Doctorprovider>();

    return Scaffold(
      appBar: AppBar(
         flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        title: const Text("Patient AI History",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,
        color: Colors.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: isLoading
            ? _buildShimmerEffect()
            : patientpageprovider.patienthistorydata.isEmpty
                ? Column(
                  children: [
                    const Expanded(child: Center(child: Text("No data found for this patient"))),

                    _buildImportantDisclaimer(),
                    SizedBox(height: 20,),
                  ],
                ) // No data case
                : Column(
                  children: [
                    Expanded(
                      child: Markdown(
                          data: patientpageprovider.patienthistorydata.isNotEmpty
                              ? patientpageprovider.patienthistorydata
                              : "No AI analysis available.",
                        ),
                    ),
                    _buildImportantDisclaimer(),
                    SizedBox(height: 20,)
                  ],
                ),
      ),
    );
  }
}
