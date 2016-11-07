package me::tally_basics;
use chobak_cstruc;
use chobaktime;
use strict;

my $opto_review_var;
my $spec_vari = {};

my $var_card_valid;

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
  my $lc_grad_today;
  
  if ( &chobak_cstruc::counto($_[0]->{'deck'}) )
  {
    &chobak_cstruc::ry_push($_[0]->{'mtdeck'},$_[0]->{'deck'});
    $_[0]->{'deck'} = [];
  }
  
  &chobak_cstruc::upfrs_hrf($_[0],'deck',$_[0],'hnd03');
  &chobak_cstruc::upfrs_hrf($_[0],'hnd03',$_[0],'hnd02');
  &chobak_cstruc::upfrs_hrf($_[0],'hnd02',$_[0],'hnd01');
  &chobak_cstruc::upfrs_hrf($_[0],'hnd01',$_[0],'hand');
  
  $lc_grad_today = 0;
  while ( ( &chobak_cstruc::counto($_[0]->{'hand'}) < 0.5 ) && ( &chobak_cstruc::counto($_[0]->{'mtdeck'}) > 0.5 ) )
  {
    $lc_grad_today = 10;
    $_[0]->{'hand'} = &chobak_cstruc::ry_shift($_[0]->{'mtdeck'});
  }
  
  if ( $lc_grad_today > 5 )
  {
    &chobak_cstruc::ry_push($_[0]->{'gradrec'}, {
      'time' => &chobaktime::nowo(),
    });
  }
}

sub opto_review_in {
  $opto_review_var = $_[0];
}

sub card_valid_on {
  $var_card_valid = 10;
}
sub card_valid_off {
  $var_card_valid = 0;
}
sub card_valid_yes {
  return ( $var_card_valid > 5 );
}
sub card_valid_no {
  return ( $var_card_valid < 5 );
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

sub cusv_decr {
  my $lc_a;
  $lc_a = int($spec_vari->{$_[0]} - 0.8);
  if ( $lc_a < 0 ) { $lc_a = 0; }
  $spec_vari->{$_[0]} = $lc_a;
}

sub cusv_get {
  return $spec_vari->{$_[0]};
}


1;
