use Battleship::Utils;
use Battleship::Command;
use Battleship::Play;
use Battleship::Play::Fire;
use Battleship::Play::Move;
use Battleship::Play::Sink;
use Battleship::Coords;
use Battleship::Board;
use Battleship::AI;
use Battleship::Ship;

unit class Battleship::Server;

has Battleship::Ship @.ship;
has Board            $.board;
has Channel          $.player1;
has Channel          $.player2;
has Supply           $.play;

submethod TWEAK ( ) {
  $!board.place-ships: :@!ship;
}

method serve ( ) {

  my @player = $!player1, $!player2;
  my $player = @player.head;

  react {
    whenever $!play -> Battleship::Play $play {

      my $event = self.play: :$play;
      $player.send($event);

      $!board.place-ships: :@!ship;
      self.draw;


      done if [eq] @!ship.map(*.owner);

      $player = @player.first( * !=== $player);
      $player.send(Start);
    }

    sleep .1;
    $player.send(Start);
  }
}


multi method play ( Battleship::Play::Move :$play --> Event ) {

  my $ship = @!ship.grep( *.owner eq $play.player ).first( *.name eq $play.ship);

  $ship.move: $play.direction if $ship;
}

multi method play ( Battleship::Play::Fire :$play --> Event ) {

  my Event $event;
  my $sym = $!board.cell[$play.coords.y][$play.coords.x].sym;

  if $sym eq '■' {

    my $ship  = @!ship.first({ so any(.coords) eqv $play.coords });
    my $part  = $ship.part.first({ .coords eqv $play.coords });

    $part.hit   = True;
    $part.color = black;
    @!ship .= grep: not * eqv $ship if all $ship.part.map(*.hit);
    # check if own ship
    
    $event = Hit;
  }
  else {
    $event = Miss;
  }

  $event;

}


method draw ( ) {

  say '';
  # clear;

  $!board.draw;

  say '';
  say '';

  }

sub clear { print qx[clear] }
