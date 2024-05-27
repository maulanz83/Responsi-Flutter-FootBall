import '../model/Detail.dart';
import '../source/load_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailTeamPage extends StatefulWidget{
  final int idLeague;
  final int idTeam;
  const DetailTeamPage({Key? key, required this.idLeague, required this.idTeam}) : super(key: key);
  @override
  State<DetailTeamPage> createState() => _DetailTeamPageState();
}

class _DetailTeamPageState extends State<DetailTeamPage> {
  //buat menu favorite
  bool _isFavorit = false;
  var icon = Icon(
    Icons.favorite_border
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Team Detail ",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic
          ),
        ),
        backgroundColor: Colors.black87,
        surfaceTintColor: Color(0xFFF7EFF1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: icon,
            onPressed: _Favorite,
            color: Colors.white,
          ),
        ],
      ),
      body: _buildTeamBody(),
    );
  }

  Widget _buildTeamBody() {
    return Container(
      color: Colors.blueGrey[200], // Mengatur warna latar belakang Container
      child: FutureBuilder(
        future: ApiDataSource.instance.loadDetailTeam(widget.idLeague, widget.idTeam),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            // Jika data ada error maka akan ditampilkan hasil error
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
            DetailTeamModel detailTeamModell =
            DetailTeamModel.fromJson(snapshot.data);
            return _buildSuccessSection(detailTeamModell);
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

  Widget _buildSuccessSection(DetailTeamModel data) {
    Data team = data.data!;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 200,
                  child: Image.network(team.logoClubUrl!),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: Column(
                    children: [
                      Text(team.nameClub!, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Head Coach", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(
                        team.headCoach!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Captain", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(
                        team.captainName!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Stadium Name", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(
                        team.stadiumName!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (team.logoClubUrl != "") {
                          launchURL(team.logoClubUrl!);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Link Logo Tidak Ada A'ah"),
                                content: Text("Ga ada Logonya banh"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF7EFF1),
                          foregroundColor: Color(0xFFF7EFF1)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: Color(0xFF3A023E)),
                          Text('Logo URL', style: TextStyle(color: Color(0xFF3A023E)),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

void _Favorite() {
  final bool newFavoriteStatus = !_isFavorit;
  final Icon newIcon = newFavoriteStatus
      ? Icon(Icons.favorite, color: Colors.red)
      : Icon(Icons.favorite_border);

  setState(() {
    _isFavorit = newFavoriteStatus;
    icon = newIcon;
  });

  final String message = newFavoriteStatus
      ? 'Favorite Team Added!'
      : 'Favorite Team Removed!';
  final Color bgColor = newFavoriteStatus ? Colors.green : Colors.red;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: bgColor,
    ),
  );
}


}

Future<void> launchURL(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw "Couldn't launch url";
  }
}
