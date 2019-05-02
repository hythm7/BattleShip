use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;

unit class Battleship::UI::Player;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

has $.name;

method TWEAK ( ) {

  self.draw-box( 0, 0, $.w - 1, $.h - 1 );

}


method update ( :$data ) {

  $.grid.set-span-text: 1, 1, $data.name;
  $.grid.set-span-text: 1, 2, "Shots {$data.shots}";
  $.grid.set-span-text: 1, 3, "Hits {$data.hits}";
  self.composite: :print;

}
