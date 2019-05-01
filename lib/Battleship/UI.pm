no precompilation;
use Terminal::Print <T>;
use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;
use Battleship::UI::Player;
use Battleship::UI::Ocean;
use Battleship::UI::Command;
use Battleship::UI::Log;

unit class Battleship::UI;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

has Player  $.player1;
has Player  $.player2;
has Ocean   $.ocean;
has Command $.command;
has Log     $.log;
has Supply  $.update;

method new ( :$update ) {
  self.bless: y => 0, x => 0, w => w, h => h, :$update;
}

submethod TWEAK ( ) {


  $!player1 = Player.new:  :x(0),           :y(0),           :w(w div 4), :h(3 * h div 4),  :parent(self);
  $!ocean   = Ocean.new:   :x(w div 4),     :y(0),           :w(20), :h(20),  :parent(self);
  $!player2 = Player.new:  :x(3 * w div 4), :y(0),           :w(w div 4), :h(3 * h div 4),  :parent(self);
  $!log     = Log.new:     :x(0),           :y(3 * h div 4), :w(w),       :h((h div 4) - 3),:parent(self);
  $!command = Command.new: :x(0),           :y(h - 3),       :w(w),       :h(3),            :parent(self);

  self.children>>.composite: :print;
}


method display ( ) {

  T.initialize-screen;

  self.composite: :print;

  react {

    whenever $!update -> @cell {

      $!ocean.update: :@cell;

    }
  }

  T.shutdown-screen;
}



