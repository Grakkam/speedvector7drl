import 'package:malison/malison.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/infoscreen.dart';

class AboutScreen extends InfoScreen {
  AboutScreen(Game game, String title) : super(game, title);

  @override
  void initialize() {
    add('Speed Vector - 7DRL 2021 Edition', fgColor: Color.aqua);
    add(' ');
    add('There is a saying:');
    add(' ');
    add('          "Finished is better than perfect!"', fgColor: Color.gold);
    add(' ');
    add('Speed Vector is certainly not perfect, but I am willing to call it "finished" for the purpose of the 7DRL challenge.');
    add('I think the core gameplay works well enough, and I really enjoy playing the game myself. And I feel like I have really leveled up my coding skills during this week.');
    add('So regardless of any marks I get from the reviewers, or if this game will even be considered a roguelike or not, I consider myself a winner for finishing. :D');
    add(' ');
    add('I did not invent the core mechanic of adding vectors to simulate momentum. I first became aware of it in my early teen years, in the first half of the 1990\'s.');
    add('It was presented as a pen-and-paper racing game, being played on a square grid. It was perfect for short, fast-paced games during school breaks.');
    add('Just draw up a suitable circuit, with a long straight and some squiggly hairpin corners, and go for it.');
    add('You already have all you need to play among your math supplies! I had a lot fun with it, playing with friends in school. In fact, I still enjoy it at times.');
    add('It is such beautifully simple, as many of the best ideas are.');
    add(' ');
    add('Speed Vector is my attempt to bring this simple mechanic into a roguelike racing game. I am sure I\'m not the first person to think of this, and there are probably a lot of other games out there making use of it.');
    add('But this one is mine, and I hope you will like it.');
    add('As I am writing this, I have less than six hours remaining before my deadline to submit. It has been an intense week, with far too few hours of coding per day, but I have thoroughly enjoyed the process.');
    add('I have learned so much and I am immensely proud to be able to submit a finished, playable game.');
    add(' ');
    add('Acknowledgments and Shout-outs', fgColor: Color.gold);
    add(' ');
    add('I couldn\'t have done this without my fantastic wife, who is incredibly understanding and supportive of my various insane projects I keep starting. Thank you Li-Lo, I love you so much.');
    add(' ');
    add('I also couldn\'t have done this without the "malison" and "piecemeal" Dart libraries by Bob Nystrom (u/munificent).');
    add('His Roguelike Celebration 2018 talk (https://youtu.be/JxI3Eu5DPwE) about game programming patterns inspired me to both get into Dart programming and to start thinking about roguelike development.');
    add(' ');
    add('And speaking of roguelike development, I want to say thanks to the r/roguelikedev community on Reddit, for arranging this challenge and being amazingly supportive and welcoming.');
    add(' ');
    add('Special shout-out to Josh Ge (u/Kyzrati) for being such a positive and driving force in this space.');
    add('His "How to Make a Roguelike" talk (https://youtu.be/jviNpRGuCIU), also from the Roguelike Celebration 2018, inspired me to get back into coding after a long hiatus.');
    add('Using Python and the TCOD tutorial as a jumping off point, I started to get excited about game development and programming again.');
    add(' ');
    add('So thank you also to u/TStand90 and u/HexDecimal, and any others responsible for maintaining the TCOD library and tutorial.');
    add(' ');
    add('Apologies if I am forgetting someone. I now have about five hours left and I still have a few things I want to add before submitting my entry.');
    add(' ');
    add('I honestly didn\'t intend for this to sound like an award acceptance speech, but here we are. I am not cutting any of this out.');
    add('I often say that I am an expert in starting new projects, but unfortunately not in finishing them, and I guess that\'s true.');
    add('And even though I have every intention to keep developing Speed Vector long beyond the 2021 7DRL challenge, I am super proud of it in its current state.');
    add(' ');
    add('See you soon in...');
    add(' ');
    add(' >>> Speed Vector 2:', fgColor: Color.orange);
    add('  >>> The Need for Steeg!', fgColor: Color.purple);
    add(' ');
    add('Sincerely, Stig Rudeholm (u/Grakkam)');
    add(' ');
    add(' - Saturday, 13 March 2021', fgColor: Color.darkGray);
  }
}
