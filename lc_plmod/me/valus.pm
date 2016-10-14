package me::valus;
use strict;

my $vallist = {
  # BEGIN THE LIST OF SIGNIFICANT VALUES:
  
  # What is the minimal probability-denominator for long-term
  # repeat-questions?
  'min-longterm-qfac' => 150,
  
  # Maximum presumed pre-shortening size of new-deck.
  'max-deck-preshort' => 120,
  
  # Maximum post-shortening size of new-deck
  'max-deck-postshort' => 100,
};

sub look {
  return $vallist->{$_[0]};
}


1;
