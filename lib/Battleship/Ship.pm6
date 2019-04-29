use Terminal::ANSIColor;
use Battleship::Coords;

enum Name < Turtle Alligator Whale Bass Bonita Shark Seal Salmon Seawolf Tarpon Cuttlefish >;
enum Direction < north south east west northeast northwest southeast southwest forward backward left right>;
enum Type ( Frigate => 3, Corvette => 3, Destroyer => 5, Cruiser => 5, Carrier => 7 );
enum Color < red green yellow blue magenta cyan black >;
enum State < Swim Sink >;

# TODO: head shot eq sink
# hide ship body out of coords
# head out of coords eq escape

unit class Battleship::Ship;

my class Part {

  has Str   $.shape  is rw  = '＠';
  has Color $.color  is rw;
  has Bool  $.hit    is rw  = False;
  has Bool  $.hidden        = False;

  has Battleship::Coords $.coords is rw;

  method Str ( ) {
    $!shape.Str;
  }

}


has Str   $.owner   is required;
has Type  $.type    is required;
has Name  $.name;
has Color $.color = Color.pick;

has Bool  $.hidden = False;

has Part @.part;
has State $!state;

submethod TWEAK ( ) {

  my $shape = '＠';
  my $name  = Name.pick;

  @!part.append: Part.new: :$shape, :$!color, :$!hidden for ^$!type;

  $!state = Swim;

}

multi method move ( $ where ~forward ) {

  given self.direction {
    @!part.map( -> $p { $p.coords = $p.coords.east  })     when east;
    @!part.map( -> $p { $p.coords = $p.coords.west  })     when west;
    @!part.map( -> $p { $p.coords = $p.coords.north })     when north;
    @!part.map( -> $p { $p.coords = $p.coords.south })     when south;
    @!part.map( -> $p { $p.coords = $p.coords.northeast }) when northeast;
    @!part.map( -> $p { $p.coords = $p.coords.northwest }) when northwest;
    @!part.map( -> $p { $p.coords = $p.coords.southeast }) when southeast;
    @!part.map( -> $p { $p.coords = $p.coords.southwest }) when southwest;
  }

}

multi method move ( $ where ~backward ) {

  given self.direction {
    @!part.map( -> $p { $p.coords = $p.coords.east  })     when  west;
    @!part.map( -> $p { $p.coords = $p.coords.west  })     when  east;
    @!part.map( -> $p { $p.coords = $p.coords.north })     when  south;
    @!part.map( -> $p { $p.coords = $p.coords.south })     when  north;
    @!part.map( -> $p { $p.coords = $p.coords.northeast }) when  southwest;
    @!part.map( -> $p { $p.coords = $p.coords.northwest }) when  southeast;
    @!part.map( -> $p { $p.coords = $p.coords.southeast }) when  northwest;
    @!part.map( -> $p { $p.coords = $p.coords.southwest }) when  northeast;
  }

}

multi method move ( $ where ~left ) {

  my $rc = $!type div 2; # rotation center

  given self.direction {

    when north {

      .coords = .coords.west(++$) for @!part.head($rc).reverse;
      .coords = .coords.east(++$) for @!part.tail($rc);

    }

    when south {

      .coords = .coords.east(++$) for @!part.head($rc).reverse;
      .coords = .coords.west(++$) for @!part.tail($rc);

    }

    when east {

      .coords = .coords.north(++$) for @!part.head($rc).reverse;
      .coords = .coords.south(++$) for @!part.tail($rc);

    }

    when west {

      .coords = .coords.south(++$) for @!part.head($rc).reverse;
      .coords = .coords.north(++$) for @!part.tail($rc);
    }

    when northeast {

      .coords = .coords.west(++$) for @!part.head($rc).reverse;
      .coords = .coords.east(++$) for @!part.tail($rc);

    }

    when northwest {

      .coords = .coords.south(++$) for @!part.head($rc).reverse;
      .coords = .coords.north(++$) for @!part.tail($rc);

    }

    when southeast {

      .coords = .coords.north(++$) for @!part.head($rc).reverse;
      .coords = .coords.south(++$) for @!part.tail($rc);

    }

    when southwest {

      .coords = .coords.east(++$) for @!part.head($rc).reverse;
      .coords = .coords.west(++$) for @!part.tail($rc);

    }

  }

}


multi method move ( $ where ~right ) {

  my $rc = $!type div 2; # rotation center

  given self.direction {

    when north {

      .coords = .coords.east(++$) for @!part.head($rc).reverse;
      .coords = .coords.west(++$) for @!part.tail($rc);

    }

    when south {

      .coords = .coords.west(++$) for @!part.head($rc).reverse;
      .coords = .coords.east(++$) for @!part.tail($rc);

    }

    when east {

      .coords = .coords.south(++$) for @!part.head($rc).reverse;
      .coords = .coords.north(++$) for @!part.tail($rc);

    }

    when west {

      .coords = .coords.north(++$) for @!part.head($rc).reverse;
      .coords = .coords.south(++$) for @!part.tail($rc);
    }

    when northeast {

      .coords = .coords.south(++$) for @!part.head($rc).reverse;
      .coords = .coords.north(++$) for @!part.tail($rc);

    }

    when northwest {

      .coords = .coords.east(++$) for @!part.head($rc).reverse;
      .coords = .coords.west(++$) for @!part.tail($rc);

    }

    when southeast {

      .coords = .coords.west(++$) for @!part.head($rc).reverse;
      .coords = .coords.east(++$) for @!part.tail($rc);

    }

    when southwest {

      .coords = .coords.north(++$) for @!part.head($rc).reverse;
      .coords = .coords.south(++$) for @!part.tail($rc);

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
  @!part.map(*.coords);
}

