unit role Battleship::AI;

#method hunt ( Type :$type = Submarine ) {

    #  for self.filter-coords( :$type ) -> [ $y, $x ] {
        #    self.target( :$y, :$x, :$type ) if self.fire( :$y, :$x ) ~~ Hit;
        #  }
  #}

#method target ( :$y!, :$x!, Type :$type ) {

    #say "($y $x) ({$type.coords}) {$type.pieces}"

  #}

#method filter-coords ( Type :$type --> Seq ) {
    #  (^$!y X ^$!x).grep( -> [ $y, $x ] { ($y + $x) %% $type } );
          #}

