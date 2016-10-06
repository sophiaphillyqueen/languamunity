package me::tally_basics;
use chobak_cstruc;
use strict;

my $opto_review_var;
my $spec_vari = {};

sub complete_hand {
  my $lc_a;
  $lc_a = &chobak_cstruc::counto($_[0]->{'hand'});
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'rehand'}) + 0.2);
  return $lc_a;
}

sub complete_deck {
  my $lc_a;
  $lc_a = &chobak_cstruc::counto($_[0]->{'deck'});
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'hnd01'}) + 0.2);
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'hnd02'}) + 0.2);
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'hnd03'}) + 0.2);
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'redeck'}) + 0.2);
  return $lc_a;
}

sub complete_unsk_deck {
  my $lc_a;
  my $lc_b;
  my $lc_c;
  $lc_a = &chobak_cstruc::counto($_[0]->{'deck'});
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'hnd01'}) + 0.2);
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'hnd02'}) + 0.2);
  $lc_a = int($lc_a + &chobak_cstruc::counto($_[0]->{'hnd03'}) + 0.2);
  $lc_b = $_[0]->{'mtdeck'};
  
  foreach $lc_c (@$lc_b)
  {
    $lc_a = int($lc_a + &chobak_cstruc::counto($lc_c) + 0.2);
  }
  return $lc_a;
}

sub complete_quiz {
  return int(&complete_hand($_[0]) + &complete_deck($_[0]) + 0.2);
}

sub shift_unasked_in_arcos {
  
  if ( &chobak_cstruc::counto($_[0]->{'deck'}) )
  {
    &chobak_cstruc::ry_push($_[0]->{'mtdeck'},$_[0]->{'deck'});
    $_[0]->{'hand'} = [];
  }
  
  &chobak_cstruc::upfrs_hrf($_[0],'deck',$_[0],'hnd03');
  &chobak_cstruc::upfrs_hrf($_[0],'hnd03',$_[0],'hnd02');
  &chobak_cstruc::upfrs_hrf($_[0],'hnd02',$_[0],'hnd01');
  &chobak_cstruc::upfrs_hrf($_[0],'hnd01',$_[0],'hand');
  
  while ( ( &chobak_cstruc::counto($_[0]->{'hand'}) < 0.5 ) && ( &chobak_cstruc::counto($_[0]->{'mtdeck'}) > 0.5 ) )
  {
    $_[0]->{'hand'} = &chobak_cstruc::ry_shift($_[0]->{'mtdeck'});
  }
}

sub opto_review_in {
  $opto_review_var = $_[0];
}

sub opto_review_out {
  return $opto_review_var;
}

sub cusv_set {
  $spec_vari->{$_[0]} = $_[1];
}

sub cusv_incr {
  my $lc_a;
  $lc_a = int($spec_vari->{$_[0]} + 1.2);
  $spec_vari->{$_[0]} = $lc_a;
}

sub cusv_get {
  return $spec_vari->{$_[0]};
}


1;
