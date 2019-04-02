use Battleship::Coords;
use Battleship::Ship::Piece;

enum Name < Turtle Alligator Whale Bass Bonita Shark Seal Salmon Seawolf Tarpon Cuttlefish >;
enum Direction < north south east west northeast northwest southeast southwest forward backward left right>;
enum Type ( Submarine => 3, Cruiser => 5, Carrier => 7);
enum State < Swim Sink >;

# TODO: head shot eq sink
# hide ship body out of coords
# head out of coords eq escape

unit class Battleship::Ship;

has Str       $.name is required;
has Type      $.type is required;
has Piece     @.pieces;

has State $!state;

submethod BUILD ( Str :$!name, Type :$!type ) {

  my $shape = ShipPiece.pick;

  @!pieces.append: Piece.new: :$shape for ^$!type;

  $!state = Swim;

}

multi method move ( $ where ~forward ) {

  given self.direction {
    @!pieces.map( -> $p { $p.coords = $p.coords.east  })     when east;
    @!pieces.map( -> $p { $p.coords = $p.coords.west  })     when west;
    @!pieces.map( -> $p { $p.coords = $p.coords.north })     when north;
    @!pieces.map( -> $p { $p.coords = $p.coords.south })     when south;
    @!pieces.map( -> $p { $p.coords = $p.coords.northeast }) when northeast;
    @!pieces.map( -> $p { $p.coords = $p.coords.northwest }) when northwest;
    @!pieces.map( -> $p { $p.coords = $p.coords.southeast }) when southeast;
    @!pieces.map( -> $p { $p.coords = $p.coords.southwest }) when southwest;
  }

}

multi method move ( $ where ~backward ) {

  given self.direction {
    @!pieces.map( -> $p { $p.coords = $p.coords.east  })     when  west;
    @!pieces.map( -> $p { $p.coords = $p.coords.west  })     when  east;
    @!pieces.map( -> $p { $p.coords = $p.coords.north })     when  south;
    @!pieces.map( -> $p { $p.coords = $p.coords.south })     when  north;
    @!pieces.map( -> $p { $p.coords = $p.coords.northeast }) when  southwest;
    @!pieces.map( -> $p { $p.coords = $p.coords.northwest }) when  southeast;
    @!pieces.map( -> $p { $p.coords = $p.coords.southeast }) when  northwest;
    @!pieces.map( -> $p { $p.coords = $p.coords.southwest }) when  northeast;
  }

}

multi method move ( $ where ~left ) {

  my $rc = $!type div 2; # rotation center

  given self.direction {

    when north {

      .coords = .coords.west(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.east(++$) for @!pieces.tail($rc);

    }

    when south {

      .coords = .coords.east(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.west(++$) for @!pieces.tail($rc);

    }

    when east {

      .coords = .coords.north(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.south(++$) for @!pieces.tail($rc);

    }

    when west {

      .coords = .coords.south(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.north(++$) for @!pieces.tail($rc);
    }

    when northeast {

      .coords = .coords.west(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.east(++$) for @!pieces.tail($rc);

    }

    when northwest {

      .coords = .coords.south(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.north(++$) for @!pieces.tail($rc);

    }

    when southeast {

      .coords = .coords.north(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.south(++$) for @!pieces.tail($rc);

    }

    when southwest {

      .coords = .coords.east(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.west(++$) for @!pieces.tail($rc);

    }

  }

}


multi method move ( $ where ~right ) {

  my $rc = $!type div 2; # rotation center

  given self.direction {

    when north {

      .coords = .coords.east(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.west(++$) for @!pieces.tail($rc);

    }

    when south {

      .coords = .coords.west(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.east(++$) for @!pieces.tail($rc);

    }

    when east {

      .coords = .coords.south(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.north(++$) for @!pieces.tail($rc);

    }

    when west {

      .coords = .coords.north(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.south(++$) for @!pieces.tail($rc);
    }

    when northeast {

      .coords = .coords.south(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.north(++$) for @!pieces.tail($rc);

    }

    when northwest {

      .coords = .coords.east(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.west(++$) for @!pieces.tail($rc);

    }

    when southeast {

      .coords = .coords.west(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.east(++$) for @!pieces.tail($rc);

    }

    when southwest {

      .coords = .coords.north(++$) for @!pieces.head($rc).reverse;
      .coords = .coords.south(++$) for @!pieces.tail($rc);

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
  @!pieces.map(*.coords);
}

