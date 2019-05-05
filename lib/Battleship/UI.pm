no precompilation;
use Terminal::Print <T>;
use Terminal::Print::Widget;
use Terminal::Print::BoxDrawing;
use Battleship::Utils;
use Battleship::UI::Title;
use Battleship::UI::Player;
use Battleship::UI::Ocean;
use Battleship::UI::Command;
use Battleship::UI::Tweet;

unit class Battleship::UI;
  also is   Terminal::Print::Widget;
  also does Terminal::Print::BoxDrawing;

has Title   $!title;
has Player  $!player1;
has Player  $!player2;
has Ocean   $!ocean;
has Command $!command;
has Tweet   $!tweet;
has Supply  $.updates;

method new ( :$updates, :$player1, :$player2  ) {
  self.bless: y => 0, x => 0, w => w, h => h, :$updates, :$player1, :$player2;
}

submethod BUILD ( :$!updates, :$player1, :$player2 ) {


  $!title   = Title.new:   :x(0),            :y(0),  :w(w),  :h(7),      :parent(self);
  $!player1 = Player.new:  :x(0),            :y(8),  :w(14), :h(20),     :parent(self), :name($player1);
  $!player2 = Player.new:  :x(w - 14),       :y(8),  :w(14), :h(20),     :parent(self), :name($player2);
  $!ocean   = Ocean.new:   :x(w div 2 - 20), :y(8),  :w(20), :h(20),     :parent(self);
  $!command = Command.new: :x(0),            :y(30), :w(w),  :h(3),      :parent(self);
  $!tweet   = Tweet.new:   :x(0),            :y(34), :w(w),  :h(h - 34), :parent(self);

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


multi method koko ( Int :$data ) { 'int' }

multi method koko ( Battleship::Utils::Tweet :$data ) {
  $!tweet.update: :$data;
}

multi method koko ( Str :$data) { 'str!' }

multi method update ( Battleship::Utils::OceanData :$data ) {

  $!ocean.update: :$data;

}

multi method update ( Battleship::Utils::PlayerData :$data ) {

  ($!player1, $!player2).first( *.name eq $data.name).update: :$data;

}
multi method update ( Battleship::Utils::Tweet :$data ) {

  $!tweet.update: :$data;

}

