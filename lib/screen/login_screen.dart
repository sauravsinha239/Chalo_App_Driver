
import 'package:drivers/screen/register_screen.dart';
import 'package:drivers/widgets/getDriverData.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Assistants/assistant.dart';
import '../global/global.dart';
import '../model/user_model.dart';
import '../splash_screen/splash.dart';
import 'forget.dart';
import 'main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextEditor = TextEditingController();
  final passwordTextEditor = TextEditingController();
  bool passwordVisible = false;

  //GlobalKey

  final _formkey = GlobalKey<FormState>();

  void _Submit() async {
    if (_formkey.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
        email: emailTextEditor.text.trim(),
        password: passwordTextEditor.text.trim(),
      ).then((auth) async {
        DatabaseReference UserRef = FirebaseDatabase.instance.ref().child("drivers");

        UserRef.child(firebaseAuth.currentUser!.uid).once().then((value) async{
          final snap = value.snapshot;
          if(snap.value!=null){
            currentUser =auth.user;
            GetDriverData gt=GetDriverData();
            await gt.readCurrentDriverInformation();
            await Fluttertoast.showToast(msg: "Successfully Logged In");
            Navigator.push(context, MaterialPageRoute(builder: (c)=>MainPage()));
            //for get current user info in drawer patch
            DatabaseReference userRef = FirebaseDatabase.instance
                .ref().child("drivers").child(currentUser!.uid);
            DatabaseEvent event = await userRef.once();
            DataSnapshot snapshot = event.snapshot;
            userModelCurrentInfo = UserModel.fromSnapshot(snapshot);
            //end
            Assistants.readDriverRatings(context);
            Assistants.readDriverEarnings(context);

          }
          else{
            await Fluttertoast.showToast(msg: "No user exits with this email");
            firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c)=>Splash()));
          }
        });
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occures \n $errorMessage");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all Filed are valid !");
    }
  }




  @override
  Widget build(BuildContext context) {
    bool darktheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Image.asset(darktheme ? 'images/citydark.jpg' : 'images/city.jpg'),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Login Now',
              textAlign: TextAlign.center,
              style: GoogleFonts.niconne(
                fontSize: 40,
                color: darktheme ? Colors.yellowAccent : Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor:
                                  darktheme ? Colors.black : Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )),
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: darktheme
                                    ? Colors.yellowAccent
                                    : Colors.red,
                              )),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return "Email is required";
                            }
                            if (email.length < 2 || email.length > 50) {
                              return "Please Enter Valid email address";
                            }
                            if (EmailValidator.validate(email)) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (Text) => setState(() {
                            emailTextEditor.text = Text;
                          }),
                        ),
                        //Password Box
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: !passwordVisible,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: darktheme ? Colors.black : Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                )),
                            prefixIcon: Icon(
                              Icons.password,
                              color: darktheme ? Colors.yellow : Colors.red,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: darktheme ? Colors.green : Colors.red,
                              ),
                              onPressed: () {
                                //Update the state of password visible variable
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return "Enter Password";
                            }
                            if (text.length < 8 || text.length > 30) {
                              return "Please Enter Valid password";
                            }
                            return null;
                          },
                          onChanged: (text) => setState(() {
                            passwordTextEditor.text = text;
                          }),
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                darktheme ? Colors.yellowAccent : Colors.red,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(200, 40),
                          ),
                          onPressed: () {
                            _Submit();
                          },
                          child:  Text(
                            "Log in",
                            style: GoogleFonts.niconne(
                              fontSize: 32,
                              color: Colors.purple[900],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const forgetScreen()));
                          },
                          child: Text(
                            'Forget Password',
                            style: GoogleFonts.niconne(
                              color:
                                  darktheme ? Colors.yellowAccent : Colors.red,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          width: 10,
                        ),
                        //Create Accounts
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const register_screen()));
                          },
                          child:  Center(
                            child: Text(
                              "Doesn't have an account?",
                              style: GoogleFonts.niconne(
                                color: Colors.grey,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                          height: 10,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
