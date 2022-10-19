import 'package:stories/products.dart';
import 'package:stories/screens/story_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.light(),
      color: Colors.red,
      home: const MainScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == "/story") {
          StoryScreenArgs args = settings.arguments as StoryScreenArgs;
          return MaterialPageRoute(
            builder: (context) {
              return StoryScreen(groupId: args.id, products: args.products);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    List<ProductGroup> productGroup = [];
    formattedSource.forEach(
      (n) {
        List<Product> products = [];
        if (n['products'] != null) {
          n['products'].forEach(
            (pr) => {
              products.add(
                Product(
                  id: pr['id'],
                  title: pr['title'],
                  price: pr['price'].toDouble(),
                  description: pr['description'],
                  image: pr['image'],
                  media: pr['media'],
                  category: pr['category'],
                ),
              )
            },
          );
        }
        productGroup.add(ProductGroup(
          id: n['id'],
          name: n['name'],
          products: products,
          cover: n['cover'],
        ));
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Stories'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 122,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final group in productGroup)
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/story',
                          arguments: StoryScreenArgs(
                            id: group.id,
                            products: group.products,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 38,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(group.cover),
                                  radius: 38,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(group.name, style: TextStyle(fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
