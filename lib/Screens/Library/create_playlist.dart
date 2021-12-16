import 'package:blackhole/APIs/api.dart';
import 'package:blackhole/CustomWidgets/copy_clipboard.dart';
import 'package:blackhole/model/single_playlist_response.dart'
    as singlePlaylistResponse;
import 'package:blackhole/model/song_model.dart';
import 'package:blackhole/model/trending_song_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CreatePlaylist extends StatefulWidget {
  const CreatePlaylist({Key? key}) : super(key: key);

  @override
  _CreatePlaylistState createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  List<Map<String, dynamic>> legend = [
    {
      'name': 'Ambient',
      'color': Colors.blue,
    },
    {
      'name': 'Slow',
      'color': Colors.yellow,
    },
    {
      'name': 'Medium',
      'color': Colors.orange,
    },
    {
      'name': 'Fast',
      'color': Colors.red,
    },
  ];

  List<String> selectedPlaylist = [];
  int pageNo = 1;
  bool isFinish = false;
  bool apiLoading = false;
  List<singlePlaylistResponse.Track> lstSongTrending = [];
  final ScrollController _scrollController = ScrollController();
  bool loading = false;

  Future fetchData() async {
    try {
      apiLoading = true;
      setState(() {});
      final TrendingSongResponse? playlistRes = await YogitunesAPI()
          .fetchYogiTrendingSongData('browse/trending_songs', pageNo);

      pageNo++;
      if (playlistRes != null) {
        if (playlistRes.status!) {
          if (playlistRes.data != null) {
            if (playlistRes.data!.data!.isNotEmpty) {
              lstSongTrending.addAll(playlistRes.data!.data!);
            } else {
              isFinish = true;
            }
          } else {
            isFinish = true;
          }
        } else {
          isFinish = true;
        }
      } else {
        isFinish = true;
      }
    } on Exception catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
    } finally {
      apiLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    pageNo = 1;
    fetchData();
    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Playlist'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              var res = await YogitunesAPI().editPlaylist(
                args['playlistId'].toString(),
                args['name'].toString(),
                selectedPlaylist,
              );
              setState(() {
                loading = true;
              });
              if (res['status'] as bool) {
                Navigator.pop(context);
              } else {
                final snackBar = SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(res['data']['data'].toString(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Text(
              'Next',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                // fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      padding: const EdgeInsets.all(4),
                      // decoration: const BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: const Text(
                        'Select songs for each phase of your practice.\nUse the filter to narrow down your songs to a specific yoga type of phase.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      padding: const EdgeInsets.all(4),
                      // decoration: const BoxDecoration(
                      //   color: Colors.white,
                      // ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Legend:',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              // fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: legend.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          color:
                                              legend[index]['color'] as Color,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        legend[index]['name'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          // fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Add songs below to see them populate the playlist here.',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          // fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total time: 00:00',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                builder: (BuildContext contex) {
                                  return Filters();
                                },
                              );
                            },
                            child: const Text(
                              'Filter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lstSongTrending.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final SongItemModel item =
                            lstSongTrending[index].songItemModel!;

                        final bool selected =
                            selectedPlaylist.contains(item.id);
                        return ListTile(
                          contentPadding: const EdgeInsets.only(left: 15.0),
                          title: Text(
                            lstSongTrending[index].name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // onLongPress: () {
                          //   copyToClipboard(
                          //     context: context,
                          //     text: '{entry.title}',
                          //   );
                          // },
                          subtitle: Text(
                            // entry.artist ??
                            item.artist.toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              errorWidget: (context, _, __) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/cover.jpg',
                                ),
                              ),
                              imageUrl: item.image.toString(),
                              placeholder: (context, url) => const Image(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/cover.jpg',
                                ),
                              ),
                            ),
                          ),
                          trailing: selected
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedPlaylist
                                          .remove(item.id.toString());
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedPlaylist.add(item.id.toString());
                                    });
                                    print(selectedPlaylist.toString() +
                                        selected.toString());
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                          // onTap: () {
                          //   List<SongItemModel> songItemModel = [];
                          //   songItemModel.add(entry);
                          //   Navigator.push(
                          //     context,
                          //     PageRouteBuilder(
                          //       opaque: false,
                          //       pageBuilder: (_, __, ___) => PlayScreen(
                          //         songsList: songItemModel,
                          //         index: 0,
                          //         // songList.indexWhere(
                          //         //   (element) => element == entry,
                          //         // ),
                          //         offline: false,
                          //         fromDownloads: false,
                          //         fromMiniplayer: false,
                          //         recommend: true,
                          //       ),
                          //     ),
                          //   );
                          // },
                        );
                      },
                    ),
                    if (apiLoading)
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                          ),
                          child: Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width / 7,
                              width: MediaQuery.of(context).size.width / 7,
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
      ),
    );
  }

  void _listScrollListener() {
    // if (lstPlaylistData.isNotEmpty) {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!isFinish & !apiLoading) {
        fetchData();
      }
    }
    // }
  }
}

class Filters extends StatefulWidget {
  Filters({Key? key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int? selectedVocal;
  int? selectedTempo;
  int? selectedStyle;
  int selectedCategory = 0;

  List<Map<String, dynamic>> vocals = [
    {
      'key': 'lyrics',
      'val': 'Lyrics',
    },
    {
      'key': 'no_lyrics',
      'val': 'No Lyrics',
    },
  ];

  List<Map<String, dynamic>> tempo = [
    {
      'key': 'slow',
      'val': 'Slow',
    },
    {
      'key': 'medium',
      'val': 'Medium',
    },
    {
      'key': 'fast',
      'val': 'Fast',
    },
    {
      'key': 'ambient',
      'val': 'Ambient',
    },
  ];

  List<Map<String, dynamic>> style = [
    {
      'key': 'electronic',
      'val': 'Electronic',
    },
    {
      'key': 'electro-acoustic',
      'val': 'Electro-acoustic',
    },
    {
      'key': 'acoustic',
      'val': 'Acoustic',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: () {},
                  child: Center(
                    child: Text(
                      'view results',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = 0;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedCategory == 0
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                          )),
                      child: Center(
                        child: Text(
                          'All of YogiTunes',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = 1;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedCategory == 1
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          )),
                      child: Center(
                        child: Text(
                          'My Library',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'VOCALS',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisExtent: 40,
                mainAxisSpacing: 5,
              ),
              itemCount: vocals.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedVocal = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: selectedVocal == index
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary),
                    child: Center(
                      child: Text(
                        vocals[index]['val'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'TEMPO',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisExtent: 40,
                mainAxisSpacing: 5,
              ),
              itemCount: tempo.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedTempo = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: selectedTempo == index
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary),
                    child: Center(
                      child: Text(
                        tempo[index]['val'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'STYLE',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisExtent: 40,
                mainAxisSpacing: 5,
              ),
              itemCount: style.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedStyle = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: selectedStyle == index
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary),
                    child: Center(
                      child: Text(
                        style[index]['val'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedCategory = 0;
                  selectedVocal = null;
                  selectedTempo = null;
                  selectedStyle = null;
                });
              },
              child: const Text(
                'clear filter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}