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

 double? cmToMeter(){
  final cm = double.tryParse(heightCM.text.trim());
  if(cm == null || cm<=0) {
    return null;
  }
  else{
    return 100/cm;
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

void calculation(int value){
    final weight = double.tryParse(weightKg.text.trim());
    if(weight==null || weight<=0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid Input',style: TextStyle(color: Colors.red),)));
        return;
    }
    final mood = heightType== HeightType.cm ? cmToMeter():feetInchToMeter();
    

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
              controller: TextEditingController(),
              decoration: InputDecoration(
                labelText: "weight (kg)",
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 16,),
            SegmentedButton( segments: [const ButtonSegment (value: HeightType.cm,label: Text('cm',style: TextStyle(color: Colors.black),)),
            const ButtonSegment(value: HeightType.feetInch,label: Text('feetInch',style: TextStyle(color: Colors.black,),))], selected: {heightType},
            onSelectionChanged: (value)=> setState(() =>heightType = value.first,)),
            SizedBox(height: 15),

            if(heightType==HeightType.cm)...[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'height (cm)',
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),

                ),),

            ]
            else...[

              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
            ElevatedButton(onPressed: (){}, child: Text('Result', textAlign: TextAlign.center,),),

            SizedBox(height: 16,),
            Text('Result', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight(20),
              fontStyle: FontStyle.italic,
            ),)
          ],

        ),
      ),
    );
  }
}
