import 'package:flutter/material.dart';
import 'auth/VProfileInformation.dart';
import 'auth/VProfilePassword.dart';
import '../util/util.dart';

class VProfile extends StatefulWidget {
    @override
    _VProfileState createState() => _VProfileState();
}

class _VProfileState extends State<VProfile> {
    Util _util = Util();
    int indexTap = 0;
    
    final List<Widget> widgetsChildren = [
        VProfileInformation(),
        VProfilePassword(),
    ];

    void onTapTapped(int index){
        setState(() {
            indexTap = index;
        });
    }

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: (){
              Navigator.pop(context);
            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(_util.primaryColor),
                  leading: IconButton(
                      icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                      ),
                      onPressed: (){
                          Navigator.pop(context);
                      },
                  ),
                  title: Text("Perfil"),                  
                ),
                body: widgetsChildren[indexTap],
                bottomNavigationBar: Theme(
                    data: Theme.of(context).copyWith(
                        canvasColor: Colors.white,
                        primaryColor: Color(_util.primaryColor),
                        textTheme: Theme.of(context).textTheme.copyWith(
                            caption: TextStyle( 
                                color: Color(0xFFAAAAAA),
                            ),
                        ),
                    ),
                    child: BottomNavigationBar(
                        onTap: onTapTapped,
                        currentIndex: indexTap,
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person),
                            title: Text('Información'),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.lock),
                            title: Text('Contraseña'),
                          ),
                        ],
                    ),
                ),
            ),
        );
    }
}
