import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weatherapp/util/utils.dart' as util;
import 'package:http/http.dart' as http;
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeState();
  }

}

class HomeState extends State<Home> {

String _cityEntered;

Map results;
 Future _gotonextscreen(BuildContext context) async{
   results = await Navigator.of(context).push(
     new MaterialPageRoute<Map>(builder: (BuildContext context){
       return new Changecity();
     })
   );
   if(results!=null && results.containsKey('enter')){
     _cityEntered = results['enter'];
   }
 }

  Map data ;
  void showweather() async{
    data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Weather app"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () { _gotonextscreen(context); },
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',fit: BoxFit.fill,width: 490.0,height: 1200.0,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
            child: new Text( '${_cityEntered == null ? util.defaultCity : _cityEntered  }' , style: new TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(20.0, 250.0, 0.0, 0.0),
            child: updateTemp('${_cityEntered == null ? util.defaultCity : _cityEntered  }'),
          ),
        ],
      ),
    );
  }

Future<Map> getWeather(String appId , String city) async {
  String apiurl = "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID=${util.appId}&units=metric" ;
  http.Response response = await http.get(apiurl) ;
  return json.decode(response.body);
}

Widget updateTemp(String city){
  return new FutureBuilder(
    future: getWeather(util.appId, city==null? util.defaultCity : city ),
    builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
      if(snapshot.hasData){
        Map content = snapshot.data ;
        return new Container(
          child: new Column(
            children: <Widget>[
              new ListTile(
                title: new Text(content['main']['temp'].toString()+"C",style: new TextStyle(color: Colors.white,fontSize: 45.0,fontWeight: FontWeight.w500),),
                subtitle: new ListTile(
                  title: new Text(
                    "Humidity: ${content['main']['humidity'].toString()}\n"
                    "Min: ${content['main']['temp_min'].toString()}C\n"
                    "Max: ${content['main']['temp_max'].toString()}C",
                    style: new TextStyle(
                      color: Colors.white
                    )   
                  ),
                ),
              )
            ],
          ),
        );
      } else{
        return new Container();
      }
    },);
}

}

class Changecity extends StatelessWidget {
  var _citycontrol = new TextEditingController() ;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change City"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',height: 1200.0,width: 490.0,fit: BoxFit.fill,),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Enter City"
                  ),
                  controller: _citycontrol,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(onPressed: () {
                  Navigator.pop(context,{
                    'enter' : _citycontrol.text
                  });
                }, 
                child: new Text("Get Weather"),
                color: Colors.pink,
                textColor: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}