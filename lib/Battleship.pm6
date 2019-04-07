use Battleship::Command;
use Battleship::Board;
use Battleship::AI;
use Battleship::Ship;

enum Fire        < Miss Hit >;
enum Orientation < Horizontal Vertical Diagonal >;


unit class Battleship;

has Int    $!x;
has Int    $!y;
has Int    $!ships;
has Board  $!board;
has Ship   @.ship;
has Player @.player[2];

multi method new ( Str :$name!, Int :$y!, Int :$x!, Int :$ships!, :$speed! ) {

  my Player @player;

  my $player1 = Player.new: :$name;
  my $player2 = AI.new: board-y => $y, board-x => $x, :$speed;

  @player.append: $player1, $player2;

  self.bless( :@player, :$y, :$x, :$ships )

}

multi method new ( Bool :$ai!, Int :$y!, Int :$x!, Int :$ships!, :$speed! ) {

  my Player @player;

  my $player1 = AI.new: board-y => $y, board-x => $x, :$speed;
  my $player2 = AI.new: board-y => $y, board-x => $x, :$speed;

  @player.append: $player1, $player2;

  self.bless( :@player, :$y, :$x, :$ships )

}


submethod BUILD ( Player :@!player, Int :$!y, Int :$!x, Int :$!ships ) {


  @!ship = self.create-ships;
  self.set-ships-coords;

  $!board = Board.new: :$!y, :$!x;
  $!board.place-ships: :@!ship;

  self.draw;

  #say @!ship>>.coords>>.Str;
}


method draw ( ) {

  #clear;

  $!board.draw;

  say '';
  say '';
  say '';

  for @!player {

    say "{.name}:";
    say "shots {.shots} misses {.misses} hits {.hits} moves {.moves}";
    say '';

  }


}

method check-shot ( Coords :$coords --> Fire ) {

  my $sym = $!board.cell[$coords.y][$coords.x].sym;

  say $sym;
  return Hit if  $sym eq '■';
  return Miss;

}


submethod create-ships {

  my @ship;

  for @!player { 

    my Bool $hidden;

    $hidden = True when AI;

    for Frigate, Corvette, Destroyer, Cruiser, Carrier -> $type {

      @ship.append: Ship.new: owner => .name, :$type, :$hidden;

    }

  }


  @ship;

}

submethod set-ships-coords ( ) {

  for @!ship -> $ship {

    my @coords = self.rand-coords: type => $ship.type;

    .coords = @coords.shift for $ship.part;

  }



}

submethod rand-coords ( Type :$type, Orientation :$orientation = Orientation.roll ) {

  my Battleship::Coords @coords;

  my $y = (^$!y).roll;
  my $x = (^$!x).roll;

  given $orientation {

    #TODO: Random ±

    do @coords.append: Coords.new: y => $y,      x => $x + $_ for ^$type when Horizontal;
    do @coords.append: Coords.new: y => $y + $_, x => $x      for ^$type when Vertical;
    do @coords.append: Coords.new: y => $y + $_, x => $x + $_ for ^$type when Diagonal;
  }

  return @coords if self.validate-coords: :@coords;

  self.rand-coords: :$type, :$orientation;
}

submethod validate-coords ( Coords :@coords --> Bool:D ) {

  return False unless all(@coords>>.y) ∈ ^$!y;
  return False unless all(@coords>>.x) ∈ ^$!x;

  so none @coords Xeqv @!ship.map(*.coords).flat;

}

method welcome ( ) {

  say 'Welcome!';

}


submethod update ( :$player, :%command ) {

  given %command<action> {

    when 'move' {

      $player.moves += 1;

      my $name      = %command<ship>;
      my $direction = %command<direction>;

      my $ship = @!ship.grep( *.owner eq $player.name ).first( *.name eq $name );
      $ship.move: $direction if $ship;


    }

    when 'fire' {

      $player.shots += 1;

      my $coords = %command<coords>;

      my $result = self.check-shot: :$coords;

      if $result ~~ Hit {

        $player.hits += 1;

        my $ship  = @!ship.first({ so any(.coords) eqv $coords });
        my $part = $ship.part.first({ .coords eqv $coords });

        $part.hit   = True;
        say $part.color;
        $part.color = 'black';
        say $part.color;


      }

      else {

        $player.misses += 1;

        say 'you missed!';
      }

    }

  }

  $!board.place-ships: :@!ship;
}

method run ( ) {

  my $player = @!player.first;

  loop {


    print "{$player.name} > ";

    my $command = $player.command;

    my $m = Battleship::Command.parse( $command, :actions(Battleship::CommandActions) );


    if $m {
      self.update: :$player, command => $m.ast;
    }

    else {
      say 'Sorry I did not understand that, try again';

      next;
    }

    self.draw;

    $player = @!player[++$ mod 2];
  }

}

sub clear { print qx[clear] }
