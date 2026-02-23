import 'package:flutter/material.dart';
enum HeightType {cm, feetInch}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 HeightType? heightType = HeightType.cm;
 final weightKg = TextEditingController();
 final heightCM = TextEditingController();
 final heightFt = TextEditingController();
 final heightInch = TextEditingController();
  String? bmiResult='0';
  String? category;

  String categoryFinder(double bmi){
    if (bmi<16){return 'You\'re Severely Thin';}
    if (bmi>=16 && bmi <=17){return 'You\'re Moderately Thin';}
    if (bmi>17 && bmi <18.5){return 'You\'re Mildly Thin';}
    if (bmi>18.5 && bmi <=25){return 'You\'re Normal';}
    if (bmi>25 && bmi <=30){return 'You\'re Overweight';}
    if (bmi>30 && bmi <=35){return 'You\'re Obese ClassI';}
    if (bmi>35 && bmi <=40){return 'You\'re Obese ClassII';}
    if (bmi>40){return 'You\'re Obese ClassIII';}
    return 'Invalid Data';


  }


 double? cmToMeter(){
  final cm = double.tryParse(heightCM.text.trim());
  if(cm == null || cm<=0) {
    return null;
  }
  else{
    return cm/100;
  }
 }

 double? feetInchToMeter(){
   final feet = double.tryParse(heightFt.text.trim());
   final inch = double.tryParse(heightInch.text.trim());

   if(feet==null || feet<=0 || inch == null || inch<=0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Input')));
      return null;
   }
   double totalInch = (feet*12+inch);
   if(totalInch<=0){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Input',style: TextStyle(color: Colors.red))));
     return null;
   }
   return totalInch*0.0254;
 }

void calculation(){
    final weight = double.tryParse(weightKg.text.trim());
    if(weight==null || weight<=0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Input',style: TextStyle(color: Colors.red),)));
        return;
    }
    final mood = heightType== HeightType.cm ? cmToMeter():feetInchToMeter();
    if( mood == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Value')));
      return;
    }
    final bmi = weight/(mood*mood);
    final bmiCategory = categoryFinder(bmi);

    setState(() {
      bmiResult=bmi.toStringAsFixed(2);
      category =bmiCategory;
    });

    

  }
 @override
  void dispose() {
    weightKg.dispose();
    heightCM.dispose();
    heightFt.dispose();
    heightInch.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('BMI Calculator',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
        centerTitle: true,
      ),
      body: Padding(

        padding: const EdgeInsets.all(8.0),
        child: ListView(

          children: [

            TextFormField(
              controller: weightKg,
              decoration: InputDecoration(
                labelText: "weight (kg)",
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )
              ),
            ),
            SizedBox(height: 16,),
            SegmentedButton( segments: [const ButtonSegment (value: HeightType.cm,label: Text('cm',style: TextStyle(color: Colors.black),)),
            const ButtonSegment(value: HeightType.feetInch,label: Text('feetInch',style: TextStyle(color: Colors.black,),))], selected: {heightType},
            onSelectionChanged: (value)=> setState(() =>heightType = value.first,)),
            SizedBox(height: 15),

            if(heightType==HeightType.cm)...[
              TextFormField(
                controller: heightCM,
                decoration: InputDecoration(
                  labelText: 'height (cm)',
                  contentPadding: EdgeInsets.all(8),
                  hintMaxLines: 2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),

                  ),

                ),),

            ]
            else...[

              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: heightFt,
                        decoration: InputDecoration(
                          labelText: 'feet (\')',
                          contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: TextFormField(
                        controller: heightInch,
                        decoration: InputDecoration(
                          labelText:'inch (")',
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          )
                        ),
                      ),
                    )
                  ],
                  ),
              )
            ],
            SizedBox(height: 16,),
            ElevatedButton(onPressed: (){
              calculation();
              }, child: Text('Result', textAlign: TextAlign.center,),),

            SizedBox(height: 16,),
            Text('Result= $bmiResult', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight(20),
              fontStyle: FontStyle.italic,

            ),),
            Text('$category',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight(16),
              fontStyle: FontStyle.normal,
            ),),
            SizedBox(width: 5,height: 35,child: IconButton(onPressed: (){
              setState(() {
                heightCM.clear();
                weightKg.clear();
                heightFt.clear();
                heightInch.clear();
                bmiResult='0';
                category=null;

              });
            }, icon: Icon(Icons.refresh)),),


          ],

        ),
      ),
    );
  }
}
