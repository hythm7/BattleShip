use Battleship::Player;
use Battleship::Play;
use Battleship::Command;
use Battleship::Coords;
use Battleship::Ship;

unit class Battleship::AI;
  also is Battleship::Player;

enum Name < Ghost AI Majesty Camelia >;
enum Mode < Target Hunt Run >;

has Str  $.name    = Name.pick.Str;
has Bool $.hidden  = False;
has Int  $.board-y = 20;
has Int  $.board-x = 20;
has Int  $.speed   = 7;


method command ( --> Battleship::Play ) {
  sleep 7 / $!speed;

  my $command = "f {(^$!board-y).roll} {(^$!board-x).roll}" ;
  my $mode = Hunt;

  print 'Sorry I did not understand that, try again > '
  until my $play = Battleship::Command.parse( $command, actions => Command::Actions.new(:$!name) ).ast;

  $play;

}

method hunt ( Type :$type = Destroyer ) {

  my @coords = (^$!board-y X ^$!board-x).grep( -> [ $y, $x ] { ($y + $x) %% $type } );

  my $coords = supply {
    .emit for @coords.map( -> [ $y, $x ] { Battleship::Coords.new: :$y, :$x } ).pick(*);
  }

  $coords;

}
