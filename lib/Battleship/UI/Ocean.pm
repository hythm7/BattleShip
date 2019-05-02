use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;

unit class Battleship::UI::Ocean;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

method TWEAK ( ) {

  self.draw-box(0, 0, $.w - 1, $.h - 1);

}

method update ( :$data ) {

  for $.grid.indices -> [$y, $x] {
    $.grid.change-cell: $y, $x, $data.cell[$y][$x].Str;
  }

  self.composite: :print;

}

