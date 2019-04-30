use Terminal::Print <T>;
use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;
use Battleship::UI::Player;
use Battleship::UI::Ocean;

unit class Battleship::UI;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

has Battleship::UI::Player  $.player1;
has Battleship::UI::Player  $.player2;
has Battleship::UI::Ocean   $.ocean;
#has Battleship::UI::Command $.command;
#has Battleship::UI::Log     $.log;


method build-layout ( ) {

  #T.initialize-screen;
  T.add-grid: 'main', new-grid => $.grid;

  T.switch-grid('main');

  $!player1 = Battleship::UI::Player.new: y =>  0, x =>  0, w =>  7, h => 20, parent => self;
  $!player2 = Battleship::UI::Player.new: y =>  0, x => 30, w =>  7, h => 20, parent => self;
  $!ocean   = Battleship::UI::Ocean.new:  y =>  0, x =>  9, w => 20, h => 20, parent => self;
  #$!command = ViewPort.new: y => 21, x =>  0, w => 20, h =>  4, parent => self;
  #$!log     = ViewPort.new: y => 26, x =>  0, w => 20, h => 20, parent => self;

#  $!player1.draw;
#  $!player2.draw;
#  $!ocean.draw;

  #self.composite;
}



