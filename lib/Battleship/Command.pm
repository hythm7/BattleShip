use Battleship::Play::Fire;
use Battleship::Play::Move;
use Battleship::Play::Sink;
use Battleship::Coords;


grammar Battleship::Command {

  proto token TOP { * }
  rule TOP:sym<fire> { <fire> <coords>  }
  rule TOP:sym<move> { <move> <ship> <direction>  }
  rule TOP:sym<sink> { <sink> <ship> }

  proto token move { * }
  token move:sym<m>    { <sym> }
  token move:sym<mv>   { <sym> }
  token move:sym<move> { <sym> }

  proto token fire { * }
  token fire:sym<f>    { <sym> }
  token fire:sym<fire> { <sym> }

  proto token sink { * }
  token sink:sym<s>    { <sym> }
  token sink:sym<sink> { <sym> }

  proto token direction { * }
  token direction:sym<l>        { <sym> }
  token direction:sym<r>        { <sym> }
  token direction:sym<f>        { <sym> }
  token direction:sym<b>        { <sym> }
  token direction:sym<left>     { <sym> }
  token direction:sym<right>    { <sym> }
  token direction:sym<forward>  { <sym> }
  token direction:sym<backward> { <sym> }

  proto token coords { * }
  rule  coords:sym<nocomma> { $<y>=[<.digit>+] $<x>=[<.digit>+] }
  rule coords:sym<comma>    { $<y>=[<.digit>+] <comma> $<x>=[<.digit>+] }

  token ship { <.alnum>+  }
  token comma { ',' }

}

class Command::Actions {

  has $.player;

  method TOP:sym<fire> ( $/ ) {


    my $play   = $<fire>.ast;
    my $coords = $<coords>.ast;

    make Battleship::Play::Fire.new: :$!player, :$play, :$coords;
  }

  method TOP:sym<move> ( $/ ) {

    my $ship      = $<ship>.ast;
    my $play      = $<move>.ast;
    my $direction = $<direction>.ast;

    make Battleship::Play::Move.new: :$!player, :$play, :$ship, :$direction;
  }

  method TOP:sym<sink> ( $/ ) {

    my $ship      = $<ship>.ast;
    my $play      = $<move>.ast;

    make Battleship::Play::Move.new: :$!player, :$play, :$ship;

  }

  method fire:sym<f>    ( $/ ) { make 'fire' }
  method fire:sym<fire> ( $/ ) { make 'fire' }

  method move:sym<m>    ( $/ ) { make 'move' }
  method move:sym<move> ( $/ ) { make 'move' }

  method sink:sym<s>    ( $/ ) { make 'sink' }
  method sink:sym<sink> ( $/ ) { make 'sink'} 

  method direction:sym<l>        ( $/ ) { make 'left' }
  method direction:sym<r>        ( $/ ) { make 'right' }
  method direction:sym<f>        ( $/ ) { make 'forward' }
  method direction:sym<b>        ( $/ ) { make 'backward'  }
  method direction:sym<left>     ( $/ ) { make 'left' }
  method direction:sym<right>    ( $/ ) { make 'right' }
  method direction:sym<forward>  ( $/ ) { make 'forward' }
  method direction:sym<backward> ( $/ ) { make 'backward' }

  method ship ( $/ ) { make $/.Str }

  method coords:sym<comma>   ( $/ ) { make Battleship::Coords.new: y => $/<y>.Int, x => $/<x>.Int }
  method coords:sym<nocomma> ( $/ ) { make Battleship::Coords.new: y => $/<y>.Int, x => $/<x>.Int }

}

