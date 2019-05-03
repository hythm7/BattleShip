no precompilation;
use Terminal::Print <T>;
use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;
use Battleship::Utils;
use Battleship::UI::Player;
use Battleship::UI::Ocean;
use Battleship::UI::Command;
use Battleship::UI::Log;

unit class Battleship::UI;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

has Player  $!player1;
has Player  $!player2;
has Ocean   $!ocean;
has Command $!command;
has Log     $!log;
has Supply  $.updates;

method new ( :$updates, :$player1, :$player2  ) {
  self.bless: y => 0, x => 0, w => w, h => h, :$updates, :$player1, :$player2;
}

submethod BUILD ( :$!updates, :$player1, :$player2 ) {


  $!player1 = Player.new:  :name($player1), :x(0), :y(0), :w(w div 4), :h(3 * h div 4), :parent(self);
  $!ocean   = Ocean.new:   :x(w div 4), :y(0), :w(20), :h(20),  :parent(self);
  $!player2 = Player.new:  :name($player2), :x(3 * w div 4), :y(0), :w(w div 4), :h(3 * h div 4), :parent(self);
  $!log     = Log.new:     :x(0), :y(3 * h div 4), :w(w), :h((h div 4) - 3),:parent(self);
  $!command = Command.new: :x(0), :y(h - 3), :w(w), :h(3), :parent(self);

  self.children>>.composite: :print;
}


method display ( ) {

  T.initialize-screen;

  self.composite: :print;

  react {

    whenever $!updates -> $data {

      self.update: :$data;

    }
  }

  T.shutdown-screen;
}


multi method update ( Battleship::Utils::OceanData :$data ) {

  $!ocean.update: :$data;

}

multi method update ( Battleship::Utils::PlayerData :$data ) {

  ($!player1, $!player2).first( *.name eq $data.name).update: :$data;

}
multi method update ( Battleship::Utils::Tweet :$data ) {

  $!log.update: :$data;

}
