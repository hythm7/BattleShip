use Terminal::ANSIColor;
use Battleship::Coords;
use Battleship::Ship::Piece;

enum Name < Turtle Alligator Whale Bass Bonita Shark Seal Salmon Seawolf Tarpon Cuttlefish >;
enum Direction < north south east west northeast northwest southeast southwest forward backward left right>;
enum Type ( Frigate => 3, Corvette => 3, Destroyer => 5, Cruiser => 5, Carrier => 7 );
#enum Color < red green yellow blue magenta cyan >;
enum Color < blue >;
enum State < Swim Sink >;

# TODO: head shot eq sink
# hide ship body out of coords
# head out of coords eq escape

unit class Battleship::Ship;

has Str       $.owner   is required;
has Str       $.name    is required;
has Bool      $.visible is rw        = False;
has Type      $.type    is required;
has Piece     @.piece;

has State $!state;

submethod TWEAK ( ) {

  my $shape = '■';
  my $color = Color.roll.Str;

  @!piece.append: Piece.new: :$shape, :$color for ^$!type;

  $!state = Swim;

}

multi method move ( $ where ~forward ) {

  given self.direction {
    @!piece.map( -> $p { $p.coords = $p.coords.east  })     when east;
    @!piece.map( -> $p { $p.coords = $p.coords.west  })     when west;
    @!piece.map( -> $p { $p.coords = $p.coords.north })     when north;
    @!piece.map( -> $p { $p.coords = $p.coords.south })     when south;
    @!piece.map( -> $p { $p.coords = $p.coords.northeast }) when northeast;
    @!piece.map( -> $p { $p.coords = $p.coords.northwest }) when northwest;
    @!piece.map( -> $p { $p.coords = $p.coords.southeast }) when southeast;
    @!piece.map( -> $p { $p.coords = $p.coords.southwest }) when southwest;
  }

}

multi method move ( $ where ~backward ) {

  given self.direction {
    @!piece.map( -> $p { $p.coords = $p.coords.east  })     when  west;
    @!piece.map( -> $p { $p.coords = $p.coords.west  })     when  east;
    @!piece.map( -> $p { $p.coords = $p.coords.north })     when  south;
    @!piece.map( -> $p { $p.coords = $p.coords.south })     when  north;
    @!piece.map( -> $p { $p.coords = $p.coords.northeast }) when  southwest;
    @!piece.map( -> $p { $p.coords = $p.coords.northwest }) when  southeast;
    @!piece.map( -> $p { $p.coords = $p.coords.southeast }) when  northwest;
    @!piece.map( -> $p { $p.coords = $p.coords.southwest }) when  northeast;
  }

}

multi method move ( $ where ~left ) {

  my $rc = $!type div 2; # rotation center

  given self.direction {

    when north {

      .coords = .coords.west(++$) for @!piece.head($rc).reverse;
      .coords = .coords.east(++$) for @!piece.tail($rc);

    }

    when south {

      .coords = .coords.east(++$) for @!piece.head($rc).reverse;
      .coords = .coords.west(++$) for @!piece.tail($rc);

    }

    when east {

      .coords = .coords.north(++$) for @!piece.head($rc).reverse;
      .coords = .coords.south(++$) for @!piece.tail($rc);

    }

    when west {

      .coords = .coords.south(++$) for @!piece.head($rc).reverse;
      .coords = .coords.north(++$) for @!piece.tail($rc);
    }

    when northeast {

      .coords = .coords.west(++$) for @!piece.head($rc).reverse;
      .coords = .coords.east(++$) for @!piece.tail($rc);

    }

    when northwest {

      .coords = .coords.south(++$) for @!piece.head($rc).reverse;
      .coords = .coords.north(++$) for @!piece.tail($rc);

    }

    when southeast {

      .coords = .coords.north(++$) for @!piece.head($rc).reverse;
      .coords = .coords.south(++$) for @!piece.tail($rc);

    }

    when southwest {

      .coords = .coords.east(++$) for @!piece.head($rc).reverse;
      .coords = .coords.west(++$) for @!piece.tail($rc);

    }

  }

}


multi method move ( $ where ~right ) {

  my $rc = $!type div 2; # rotation center

  given self.direction {

    when north {

      .coords = .coords.east(++$) for @!piece.head($rc).reverse;
      .coords = .coords.west(++$) for @!piece.tail($rc);

    }

    when south {

      .coords = .coords.west(++$) for @!piece.head($rc).reverse;
      .coords = .coords.east(++$) for @!piece.tail($rc);

    }

    when east {

      .coords = .coords.south(++$) for @!piece.head($rc).reverse;
      .coords = .coords.north(++$) for @!piece.tail($rc);

    }

    when west {

      .coords = .coords.north(++$) for @!piece.head($rc).reverse;
      .coords = .coords.south(++$) for @!piece.tail($rc);
    }

    when northeast {

      .coords = .coords.south(++$) for @!piece.head($rc).reverse;
      .coords = .coords.north(++$) for @!piece.tail($rc);

    }

    when northwest {

      .coords = .coords.east(++$) for @!piece.head($rc).reverse;
      .coords = .coords.west(++$) for @!piece.tail($rc);

    }

    when southeast {

      .coords = .coords.west(++$) for @!piece.head($rc).reverse;
      .coords = .coords.east(++$) for @!piece.tail($rc);

    }

    when southwest {

      .coords = .coords.north(++$) for @!piece.head($rc).reverse;
      .coords = .coords.south(++$) for @!piece.tail($rc);

    }

  }
  say self.direction;
}

method direction ( --> Direction ) {

  given self.coords -> @coords {

    my $head = @coords.head;
    my $tail = @coords.tail;

    when $head.y == $tail.y {

      return east if  $head.x > $tail.x;
      return west if  $head.x < $tail.x;

    }


    when $head.x == $tail.x {

      return north if  $head.y < $tail.y;
      return south if  $head.y > $tail.y;

    }

    default {

      return northeast if  $head.y < $tail.y and $head.x > $tail.x;
      return northwest if  $head.y < $tail.y and $head.x < $tail.x;
      return southeast if  $head.y > $tail.y and $head.x > $tail.x;
      return southwest if  $head.y > $tail.y and $head.x < $tail.x;

    }

  }

}

method coords () {
  @!piece.map(*.coords);
}

