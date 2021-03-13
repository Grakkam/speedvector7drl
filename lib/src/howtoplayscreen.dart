import 'package:malison/malison.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/infoscreen.dart';

class HowToPlayScreen extends InfoScreen {
  HowToPlayScreen(Game game, String title) : super(game, title);

  @override
  void initialize() {
    add('Soundtrack:', fgColor: Color.orange);
    add('The Speed Vector Unofficial Soundtrack can be found on Spotify. It is not required for playing the game, but is highly recommended!');
    add('https://open.spotify.com/playlist/', fgColor: Color.orange);
    add('   3u5g9wybWolaozoC5SAedt', fgColor: Color.orange);
    add(' ');
    add('The basic idea of SPEED VECTOR is simple:');
    add('You drive your car along a never-ending, procedurally generated stretch of road.');
    add('You must stay on the road and try to not get too banged up by the other motorists in the process.');
    add(' ');
    add('Controlling your car is all about momentum. The faster you go, the more difficult it will be to control your vehicle.');
    add(' ');
    add('More info for the mathematically inclined:', fgColor: Color.darkGold);
    add('<<< DON\'T PANIC! If this makes no sense to you, just skip it. You don\'t need to fully understand it to play the game. >>>',
        fgColor: Color.lightGray);
    add('Your car has a speed vector that gets added to your car\'s position each turn, giving your new position.',
        fgColor: Color.darkGold);
    add('You change your speed vector by picking a direction vector to add to it.',
        fgColor: Color.darkGold);
    add(' ');
    add('You change direction by picking one of the (usually nine) possible choices using your cursor: +');
    add(' ');
    add('Whatever point you choose, that is where you will (generally) end up next turn.');
    add('Exceptions exist. For instance, you can be knocked slightly off course by bumping into other cars.',
        fgColor: Color.gray);
    add(' ');
    add('                       ···', fgColor: Color.darkGray);
    add('                       ·+·', fgColor: Color.darkGray);
    add('                       ···', fgColor: Color.darkGray);
    add(' ');
    add('                        τ', fgColor: Color.purple);
    add(' ');
    add('Pick one of the three top directions and you speed up. The middle three means you stay at your current speed. The bottom three lowers your speed, allowing you to make tighter turns.');
    add(' ');
    add('But watch out! If you go too slow, or too fast, you risk moving off screen and being eliminated!',
        fgColor: Color.red);
    add(' ');
    add('You can move the cursor using the arrow keys. Confirm your choice with a press on the [enter] key and off you go!');
    add(' ');
    add('Choices that light up in red are moves that will result in a crash, so watch your speed!',
        fgColor: Color.red);
    add(' ');
    add('When you\'re ready for even more speed, you can use the numpad keys [1-9] or the mouse to instantly select a direction and move, without having to manually confirm your choice.');
    add(' ');
    add('At the end of each turn, after all cars have moved, the road "rolls" down a number of steps, depending on your current speed. For every piece of road that disappears from the bottom of the screen, a new piece of fresh road appears at the top.');
    add(' ');
    add('That\'s basically all you need to know to get started. Don\'t worry if you don\'t understand exactly everything now.');
    add('Once you actually start playing, you will pick it up in no time!');
    add(' ');
    add('Now go burn some rubber!!!', fgColor: Color.orange);
  }
}
