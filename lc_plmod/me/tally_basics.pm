package me::tally_basics;
use chobak_cstruc;
use strict;

sub complete_hand {
  my $lc_a;
  $lc_a = &chobak_cstruc::counto($_[0]->{'hand'});
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'rehand'}) + 0.2);
  return $lc_a;
}

sub complete_deck {
  my $lc_a;
  $lc_a = &chobak_cstruc::counto($_[0]->{'deck'});
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'redeck'}) + 0.2);
  return $lc_a;
}

sub complete_quiz {
  return int(&complete_hand($_[0]) + &complete_deck($_[0]) + 0.2);
}


1;
