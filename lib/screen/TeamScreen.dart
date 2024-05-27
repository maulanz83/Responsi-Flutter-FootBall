import 'DetailScreen.dart';
import '../model/Team.dart';
import 'package:flutter/material.dart';
import '../source/load_data.dart';

class TaemPage extends StatefulWidget {
  final int idLeague;
  const TaemPage({Key? key, required this.idLeague}) : super(key: key);

  @override
  State<TaemPage> createState() => _TaemPageState();
}

class _TaemPageState extends State<TaemPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Teams",
          style: TextStyle(
            color: Colors.white,
             fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
          ),
        ),
        backgroundColor: Colors.black87,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: _buildListTeamsBody(),
    );
  }

  Widget _buildListTeamsBody() {
    return Container(
      color: Colors.blueGrey[200],
      child: FutureBuilder(
        future: ApiDataSource.instance.loadTeam(widget.idLeague),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            TeamsModel teamsModel = TeamsModel.fromJson(snapshot.data);
            return _buildSuccessSection(teamsModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(TeamsModel dataTeam) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: dataTeam.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemTeams(dataTeam.data![index]);
      },
    );
  }

  Widget _buildItemTeams(Data isteams) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailTeamPage(
                  //var idLeague = isleague.idLeague!;
                  idLeague: widget.idLeague,
                  idTeam: isteams.idClub!,
                )));
      },
      child: Card(
          color: Color(0xFFF7EFF1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: Image.network(isteams.logoClubUrl!),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                          isteams.nameClub!,
                          style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                          textAlign: TextAlign.center, overflow: TextOverflow.ellipsis
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Head Coach: ${isteams.headCoach!}",
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          )

      ),
    );
  }


}
