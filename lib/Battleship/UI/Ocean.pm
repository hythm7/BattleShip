use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;

unit class Battleship::UI::Ocean;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

method draw ( ) {


  self.draw-box(0, 0, $.w - 1, $.h - 1);
  self.composite(:print);

}
