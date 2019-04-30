use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;

class ViewPort {
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

  method draw ( ) {

    #$.grid.change-cell: 0, 0, 'H';
    self.draw-box(0, 0, $.w - 1, $.h - 1);
    $.grid.change-cell: 0, 0, 'HHHHHHHHHHHHHHH';
    $.grid.change-cell: 3, 0, 'D';
    self.composite(:print);

  }

}

