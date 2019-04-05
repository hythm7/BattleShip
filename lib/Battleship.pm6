use Terminal::ANSIColor;
use Battleship::Player;
use Battleship::Ship;

enum Fire        < Miss Hit >;
enum Orientation < Horizontal Vertical Diagonal >;

constant WATER = colored('~', 'cyan');

unit class Battleship;

has Int    $.x;
has Int    $.y;
has Int    $.count;
has        @!board;
has Ship   @.ship;
has Player @.player[2];


submethod BUILD ( Int :$!y = 20, Int :$!x = 20, :@!player, :@!ship ) {

  self.place-ships;
  self.draw;

}


method draw ( ) {

  self.clear-board;

  for @!ship -> $ship {

    @!board[.coords.y][.coords.x] = colored(.shape, .color) for $ship.piece;

  }

  clear;

  .put for @!board;

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

  my $sym = colorstrip @!board[$coords.y][$coords.x];

  say $sym;
  return Hit if  $sym eq '■';
  return Miss;

}



submethod place-ships ( ) {

  for @!ship -> $ship {

    my @coords = self.rand-coords: type => $ship.type;

    .coords = @coords.shift for $ship.piece;

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


method clear-board ( ) {

  @!board = [ WATER xx $!y ] xx $!x;

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
        my $piece = $ship.piece.first({ .coords eqv $coords });

        $piece.hit   = True;
        $piece.color = 'black';

        say $ship.piece>>.hit;

      }

      else {

        $player.misses += 1;

        say 'you missed!';
      }

    }

  }
}


sub clear { print qx[clear] }
