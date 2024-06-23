import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = "Loading...";
  List<Map<String, dynamic>> newsArticles = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNews();
  }

  Future<void> _loadUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? 'No name';
        });
      }
    }
  }

  Future<void> _loadNews() async {
    try {
      QuerySnapshot newsQuerySnapshot =
          await FirebaseFirestore.instance.collection('news').get();

      if (newsQuerySnapshot.docs.isNotEmpty) {
        newsArticles.clear(); // Clear previous data
        newsQuerySnapshot.docs.forEach((doc) {
          String title = doc['title'];
          String content = doc['content'];
          Timestamp publicationDate = doc['publication_date'];

          Map<String, dynamic> newsData = {
            'title': title,
            'content': content,
            'publication_date': publicationDate,
          };

          setState(() {
            newsArticles.add(newsData);
          });
        });
      } else {
        print('No news available');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "$userName 👋",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: newsArticles.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: newsArticles.length,
                      itemBuilder: (context, index) {
                        var article = newsArticles[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['title'],
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(article['content']),
                              // You can format publication date as needed
                              Text(
                                article['publication_date'].toDate().toString(),
                                style: TextStyle(color: Colors.grey),
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
    );
  }
}
