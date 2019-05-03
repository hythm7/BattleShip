use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;

unit class Battleship::UI::Log;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

method TWEAK ( ) {

  self.draw-box(0, 0, $.w - 1, $.h - 1);

}

method update ( :$data ) {

  $.grid.set-span-text: 1, 1, "{$data.author}: {$data.tweet}";

  self.composite: :print;

}
