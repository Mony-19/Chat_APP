// ignore_for_file: file_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
class CustomSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        //iconTheme: const IconThemeData(color: Colors.black),
        title: TextField(
          controller: TextEditingController(text: query),
          autofocus: true,
          decoration: const InputDecoration(
            //hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            query = value;
            showResults(context);
          },
        ),
      ),
      body: buildSuggestions(context),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return const Center(
        child: Text("Enter a search term"),
      );
    }

    return FutureBuilder(
      future: _searchUsers(query),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var user = snapshot.data![index];
              return  GestureDetector(
                onTap: () {},
                child: UserTile(
                  text: user['name'],
                  onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ChatPage(
                      receiverID: user["uid"],
                      receiverName: user["name"],
                      )
                    )
                   );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<List<DocumentSnapshot>> _searchUsers(String query) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return snapshot.docs;
  }
}
