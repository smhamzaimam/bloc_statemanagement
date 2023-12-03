class Article {
  final int id;
  final String title;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        id: json['id'], title: json['title'], content: json['content']);
  }
}

List<Article?> articles = [
  Article(id: 1, title: 'Article Title 1', content: 'Article Content 1'),
  Article(id:  2, title: 'Article Title 2', content: 'Article Content 2'),
];

