use Battleship::Coords;

enum Commands < fire move sink >;

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

class Battleship::Actions {


  method TOP:sym<fire> ( $/ ) {

    my %h;

    %h<action> = $<fire>.ast;
    %h<coords> = $<coords>.ast;

    make %h;
  }

  method TOP:sym<move> ( $/ ) {

    my %h;

    %h<name>      = $<ship>.ast;
    %h<action>    = $<move>.ast;
    %h<direction> = $<direction>.ast;

    make %h;
  }

  method TOP:sym<sink> ( $/ ) {

    my %h;

    %h<ship>   = $<ship>.ast;
    %h<action> = $<sink>.ast;

    make %h;
  }

  method fire:sym<f>    ( $/ ) { make fire }
  method fire:sym<fire> ( $/ ) { make fire }

  method move:sym<m>    ( $/ ) { make move }
  method move:sym<move> ( $/ ) { make move }

  method sink:sym<s>    ( $/ ) { make Command::sink }
  method sink:sym<sink> ( $/ ) { make Command::sink}

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

