use Array::Circular;
use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;

unit class Battleship::UI::Tweet;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

has @!tweet;

method TWEAK ( ) {

  my @tweet is circular(3);

  @!tweet := @tweet;

  self.draw-box(0, 0, $.w - 1, $.h - 1);

}

method update ( :$data ) {

  @!tweet.append: $data;

  for @!tweet -> $tweet {

    $.grid.set-span-text: 1, ++$ , "{$tweet.author}: {$tweet.tweet}";

  }

  self.composite: :print;

}
