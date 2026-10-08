import 'dart:async';

import 'package:flutter/material.dart';

import 'auth/login_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});


  @override
  State<SplashPage> createState() => _SplashPageState();
}


class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {


  late AnimationController _controller;

  late Animation<double> _fadeAnimation;

  Timer? _timer;



  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );


    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );


    _controller.forward();



    _timer = Timer(
      const Duration(seconds: 3),
      () {

        if (!mounted) return;


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );

      },
    );

  }



  @override
  void dispose() {

    _timer?.cancel();

    _controller.dispose();

    super.dispose();

  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,


      body: FadeTransition(

        opacity: _fadeAnimation,


        child: Center(

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,


            children: [


              Container(

                width: 120,

                height: 120,


                decoration: BoxDecoration(

                  color: const Color(0xFF2563EB),

                  borderRadius:
                      BorderRadius.circular(25),

                  boxShadow: [

                    BoxShadow(

                      color:
                          const Color(0xFF2563EB)
                              .withOpacity(0.25),

                      blurRadius: 25,

                      offset:
                          const Offset(0, 10),

                    ),

                  ],

                ),



                child: Stack(

                  alignment:
                      Alignment.center,


                  children: [


                    const Icon(

                      Icons.shield,

                      size: 65,

                      color: Colors.white,

                    ),




                    Positioned(

                      right: 10,

                      bottom: 10,


                      child: Container(

                        padding:
                            const EdgeInsets.all(5),


                        decoration:
                            const BoxDecoration(

                          color: Colors.green,

                          shape: BoxShape.circle,

                        ),



                        child: const Icon(

                          Icons.check,

                          size: 15,

                          color: Colors.white,

                        ),

                      ),

                    ),


                  ],

                ),

              ),




              const SizedBox(height: 20),





              RichText(

                text: const TextSpan(

                  children: [


                    TextSpan(

                      text: "Campus",

                      style: TextStyle(

                        color: Colors.black,

                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),



                    TextSpan(

                      text: "Report",

                      style: TextStyle(

                        color:
                            Color(0xFF2563EB),

                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,

                      ),

                    ),


                  ],

                ),

              ),




              const SizedBox(height: 10),





              const Text(

                "SISTEM FASILITAS KAMPUS",

                style: TextStyle(

                  color: Colors.grey,

                  fontSize: 12,

                  letterSpacing: 2,

                  fontWeight:
                      FontWeight.w600,

                ),

              ),



              const SizedBox(height: 30),




              const SizedBox(

                width: 28,

                height: 28,


                child:
                    CircularProgressIndicator(

                  strokeWidth: 2.5,

                  color: Color(0xFF2563EB),

                ),

              ),




              const SizedBox(height: 12),




              const Text(

                "Memuat sistem fasilitas...",

                style: TextStyle(

                  color: Color(0xFF9CA3AF),

                  fontSize: 12,

                ),

              ),



            ],

          ),

        ),

      ),

    );

  }

}