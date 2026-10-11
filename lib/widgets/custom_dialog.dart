import 'package:flutter/material.dart';


void showSuccessDialog(
  BuildContext context,
  String message, {
  VoidCallback? onPressed,
}) {

  showDialog(
    context: context,
    barrierDismissible: false,

    builder: (context) {

      return AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        contentPadding:
            const EdgeInsets.all(24),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Container(
              width: 65,
              height: 65,

              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius:
                    BorderRadius.circular(40),
              ),

              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF2E7D32),
                size: 45,
              ),
            ),


            const SizedBox(height: 16),


            const Text(
              "Berhasil",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 10),


            Text(
              message,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),


            const SizedBox(height: 24),


            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  if (onPressed != null) {
                    onPressed();
                  }

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF1769FF),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

          ],
        ),
      );
    },
  );

}




void showErrorDialog(
  BuildContext context,
  String message,
) {

  showDialog(
    context: context,
    barrierDismissible: false,

    builder: (context) {

      return AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
        ),

        contentPadding:
            const EdgeInsets.all(24),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Container(
              width: 65,
              height: 65,

              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius:
                    BorderRadius.circular(40),
              ),

              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 40,
              ),
            ),


            const SizedBox(height: 16),


            const Text(
              "Gagal",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 10),


            Text(
              message,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),


            const SizedBox(height: 24),


            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {

                  Navigator.pop(context);

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF1769FF),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

          ],
        ),
      );
    },
  );

}