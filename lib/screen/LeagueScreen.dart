import 'package:flutter/material.dart';
import '../model/League.dart';
import '../source/load_data.dart';
import 'TeamScreen.dart';


class LeaguePage extends StatefulWidget {
  const LeaguePage({Key? key}) : super(key: key);

  @override
  State<LeaguePage> createState() => _LeaguePageState();
}

//buat clas
 class _LeaguePageState extends State<LeaguePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "League ",
            style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
          ),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: _buildListLeagueBody(),
    );
  }

  Widget _buildListLeagueBody() {
    return Container(
      color: Colors.blueGrey[200],
      child: FutureBuilder(
        future: ApiDataSource.instance.loadLeague(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            LeagueModel leagueModel = LeagueModel.fromJson(snapshot.data);
            return _buildSuccessSection(leagueModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error Bang");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(LeagueModel dataLeague) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: dataLeague.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemLeagues(dataLeague.data![index]);
      },
    );
  }

  Widget _buildItemLeagues(Data isleague) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaemPage(
                      idLeague: isleague.idLeague!,
                    )
                   )
                );
      },
      child: Card(
        color: Color(0xFFF7EFF1),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
              width: 100,
              child: isleague.logoLeagueUrl != null//condition true or false
                  ? Image.network(isleague.logoLeagueUrl!)//tru
                  : Placeholder(),//false
              ),
            
              SizedBox(height: 20),
              Text(
                isleague.leagueName!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "Country: ${isleague.country!}",
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
