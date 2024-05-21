import 'package:beatbox/utils/colors.dart';
import 'package:flutter/material.dart';


class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Kprimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: MixPrimary, // Assuming MixPrimary is a List<Color>
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 28,
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: MixPrimary)),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to BEAT BOX - Your Ultimate Offline Music Experience',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'At BEAT BOX, we are dedicated to providing music enthusiasts with a unique and immersive offline music player experience. Our app, built using Flutter, combines cutting-edge technology with a passion for music to deliver a seamless and personalized music journey. With BEAT BOX, you can explore and enjoy your favorite songs, discover new tracks, and enhance your music experience in ways you never thought possible.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Our mission is to revolutionize the way you interact with music. We understand that music is more than just a background soundtrack; it\'s an integral part of our lives. BEAT BOX empowers you to dive deep into the world of music, discover new artists, and effortlessly connect with the songs that resonate with your soul. With our advanced features and intuitive interface, we strive to make MeloVibe your go-to destination for offline music playback.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Adjustable Playback Speed: Customize your listening experience with the adjustable playback speed feature. Whether you want to slow down a fast-paced track or speed up a slow ballad, BEAT BOX lets you control the tempo to match your preferences.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '2. Lyrics Integration: Connect deeply with the music and sing along to your favorite songs with our integrated lyrics feature. BEAT BOX fetches lyrics in real-time, displaying them on your screen as the song plays. Say goodbye to the frustration of misheard lyrics and enjoy an immersive karaoke-like experience.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '3. Offline Playback: Embrace the freedom of offline music with BEAT BOX . Download your favorite songs, albums, or playlists to your device and enjoy them anytime, anywhere, even without an internet connection. Whether you\'re on a long flight, commuting underground, or in an area with limited network coverage, your music is always accessible.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '4. Cross-Platform Sync: Seamlessly synchronize your music library and preferences across multiple devices. Whether you\'re using BEAT BOX on your smartphone, tablet, or computer, your music collection and personalized settings stay in perfect harmony, giving you a consistent and seamless experience.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '5. Personalized Recommendations: Discover new music tailored to your taste with our personalized recommendations. BEAT BOX analyzes your listening habits, genre preferences, and song history to suggest artists, albums, and tracks that align with your musical interests, helping you expand your music horizons.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '6. Customization Options: Make BEAT BOX reflect your unique style and preferences. Customize the app\'s appearance, themes, and player interface to suit your mood and enhance your overall music experience.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We are committed to continuously improving BEAT BOX and providing you with the best offline music player on the market. Our team of dedicated developers and music enthusiasts work tirelessly to enhance our features, integrate new technologies, and bring you regular updates that elevate your music journey.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Join the BEAT BOX community today and immerse yourself in a world of music like never before. Let the rhythms, melodies, and lyrics resonate deep within your soul as you explore the vast universe of offline music with MeloVibe.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Happy Vibing!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'The BEAT BOX Team',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: KPprimary,
    );
  }
}