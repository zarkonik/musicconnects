import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChannelScreen extends StatefulWidget {
  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<String> _suggestions = [];
  OverlayEntry? _overlayEntry;
  final LayerLink layerLink = LayerLink();
  final GlobalKey _textFieldKey = GlobalKey(); // GlobalKey for the TextField
  bool _itemSelected = false; // Flag to track if an item was selected
  List<String> _thumbnailUrls = [];
  bool _shouldShowOverlay =
      true; // Flag to determine if overlay should be shown
  final List<String> buttonsText = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_itemSelected) {
      _itemSelected = false; // Reset the flag
      return;
    }

    resetTimer();
  }

  void startTimer() {
    // Cancel any existing timer
    _debounce?.cancel();

    // Start a new timer only if the query is non-empty
    if (_searchController.text.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 2000), () {
        if (!_itemSelected && _shouldShowOverlay) {
          _fetchSuggestions(_searchController.text);
        }
      });
    } else {
      _clearSuggestions(); // Clear suggestions if the query is empty
    }
  }

  void resetTimer() {
    _debounce?.cancel();
    startTimer();
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      _clearSuggestions();
      return;
    }

    final apiKey = '';
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=10&q=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<String> suggestions = (data['items'] as List)
          .map((item) => item['snippet']['title'] as String)
          .toList();

      final List<String> thumbnailUrls = (data['items'] as List)
          .map((item) =>
              item['snippet']['thumbnails']['default']['url'] as String)
          .toList();

      setState(() {
        _suggestions = suggestions;
        _thumbnailUrls = thumbnailUrls;
        _showOverlay();
      });

      print("Fetched suggestions: $_suggestions");
    } else {
      print('Failed to load suggestions');
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_textFieldKey.currentContext != null && _shouldShowOverlay) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry!);
        print("Overlay shown with suggestions: $_suggestions");
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null)
      return OverlayEntry(builder: (context) => SizedBox());

    var sizeTextField = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 16, // Adjust width if needed
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(
              0, sizeTextField.height), // Offset to place below the TextField
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 200.0,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      _searchController.text = _suggestions[index];
                      _itemSelected = true;
                      _shouldShowOverlay = false;
                      _clearSuggestions();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearSuggestions() {
    setState(() {
      _itemSelected = false;
      _suggestions.clear();
    });
    _overlayEntry?.remove();
    _overlayEntry = null;
    print("Suggestions cleared and overlay removed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CompositedTransformTarget(
              link: layerLink,
              child: TextField(
                key: _textFieldKey,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search YouTube videos',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const TextField(
              decoration: InputDecoration(hintText: "Search for artist"),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _thumbnailUrls.map((url) {
                return ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("Pevac"),
                  icon: CachedNetworkImage(
                    imageUrl: url,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 50.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';
import 'package:flutter_projects/models/channel_info.dart';

class ChannelScreen extends StatefulWidget {
  @override
  _ChannelScreenState createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  String? thumbnailUrl;
  List<String> thumbnailUrls = [];
  final String apiKey =
      'AIzaSyBLLgU6AYZmcyL-093rk42rB5Vnu1sLo44'; // Replace with your YouTube Data API key
  final TextEditingController _controller = TextEditingController();
  Future<ChannelsInfo>? futureChannelInfo;
  bool isSearching = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Channel Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter channel name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    setState(() {
                      isSearching = true;
                      errorMessage = '';
                    });
                    try {
                      final channelId =
                          await searchChannel(apiKey, _controller.text);
                      futureChannelInfo = fetchChannelInfo(apiKey, channelId);
                      setState(() {
                        isSearching = false;
                      });
                    } catch (e) {
                      setState(() {
                        isSearching = false;
                        errorMessage = e.toString();
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isSearching) CircularProgressIndicator(),
            if (errorMessage.isNotEmpty) Text(errorMessage),
            if (futureChannelInfo != null)
              FutureBuilder<ChannelsInfo>(
                future: futureChannelInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No data');
                  } else {
                    final channelInfo = snapshot.data!;

                    if (!thumbnailUrls.contains(channelInfo.thumbnailUrl)) {
                      thumbnailUrls.add(channelInfo.thumbnailUrl);
                    }

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Wrap(
                          children: [
                            for (var url in thumbnailUrls)
                              Container(
                                width: (MediaQuery.of(context).size.width) / 4,
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}*/
