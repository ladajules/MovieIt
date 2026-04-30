import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movieit/providers/movie_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/hero_slider.dart';
import '../widgets/horizontal_movie_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<MovieProvider>(context, listen: false).loadTrendingAndDiscoverAndTop4();
    });
  }
  
 
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),

          Consumer<MovieProvider>(
            builder: (context, movieProvider, child){
              if (movieProvider.isLoading){
                return const Center(child: CircularProgressIndicator());
              }

              if(movieProvider.errorMessage.isNotEmpty){
                return Center(child: Text(movieProvider.errorMessage, style: const TextStyle(color: Colors.red, fontSize: 18)));
              }

              return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 180),
                          
                          //  hero Slider
                          HeroSlider(movies: movieProvider.top4MoviesList),
                          
                          const SizedBox(height: 60),
                          
                          //  horizontal List
                          HorizontalMovieList(movies: movieProvider.trendingMoviesList, sectionTitle: "Trending Now",),
                          
                          const SizedBox(height: 60),
                        ],
                      ),
                    );
            }
          )
          
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E0A52), Colors.black, Color(0xFF032D6C)],
        ),
      ),
    );
  }
}