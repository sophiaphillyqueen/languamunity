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
  
  # How many rounds maximum can reintroduction of long-term
  # rehashes be halted?
  'max-dam-height' => 240,
  # And how high by default?
  'dfl-dam-height' => 0,
  
  # How many hours do "mortal" flash-cards remain valid?
  'mortality-hours' => 96,
  
  # After how many minutes are "mortal" flash-cards eligible
  # for the purge of mortal flash-cards?
  'mortality-minutes' => 20,
  
  # How many unasked cards minimum whenever a quiz session starts?
  'min-unasked-cards' => 250,
};

sub look {
  return $vallist->{$_[0]};
}


1;
