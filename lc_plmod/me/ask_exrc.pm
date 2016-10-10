package me::ask_exrc;
use strict;
use chobak_json;
use me::tally_basics;
use me::otherans;
use chobak_cstruc;

sub prime {
  my $lc_useit;
  
  &chobak_json::clone($_[0],$lc_useit);
  
  if ( ref($lc_useit->{'pre'}) eq 'ARRAY' )
  {
    my $lc2_a;
    $lc2_a = &chobak_cstruc::rand_item_of_array($lc_useit->{'pre'});
    $lc_useit->{'pre'} = $lc2_a;
  }
  
  $_[1]->{'pristine'} = $_[0];
  $_[1]->{'err_deck'} = [$_[0]];
  $_[1]->{'err_hand'} = [$lc_useit];
  return &artifice($lc_useit,$_[1]);
}

sub artifice {
  # VARIABLES HERE:
  my $lc_usinf;
  my $lc_success;
  
  # Make sure that it is possible for the calling program to initiate
  # additional voluntary review:
  {
    my $lc2_set;
    my $lc2_vl;
    
    $lc2_set = {};
    &chobak_json::clone($_[1]->{'err_deck'},$lc2_vl);
    $lc2_set->{'redeck'} = $lc2_vl;
    &chobak_json::clone($_[1]->{'err_hand'},$lc2_vl);
    $lc2_set->{'rehand'} = $lc2_vl;
    
    &me::tally_basics::opto_review_in($lc2_set);
  }
  
  $lc_usinf = {};
  
  if ( &do_ask_first($_[0],$_[1],$lc_usinf) ) { &do_congrat(); return 10; };
  $lc_success = ( 1 > 2 );
  while ( !($lc_success) )
  {
    &chobak_cstruc::ry_m_push($_[1]->{'main'}->{'rehand'},$_[1]->{'err_hand'});
    &chobak_cstruc::ry_m_push($_[1]->{'main'}->{'redeck'},$_[1]->{'err_deck'});
    
    $lc_success = &do_ask_again($_[0],$_[1],$lc_usinf);
  }
  
  &do_congrat();
  return 10;
}

sub do_ask_first {
  # FUNCTION BEHAVIOR:
  # Simply returns 'true' upon a correct answer - and any change it makes
  #   to Rg2 in that event will be inconsequential (if at all extant).
  # Otherwise, it uses Rg2 as a place to save data-info.
  my $lc_dat;
  my $lc_q;
  
  
  $lc_q = $_[0];
  $lc_dat = $_[2];
  
  system("clear");
  system("echo","EXERCISE");
  &show_by_format($lc_q->{'inst'});
  
  system("echo","-n",("\n" . '  > ' . $lc_q->{'pre'}));
  $lc_dat->{'answr'} = &chobak_jsio::inln();
  
  return($lc_dat->{'answr'} eq $lc_q->{'a'});
}

sub do_ask_again {
  # FUNCTION BEHAVIOR:
  # Simply returns 'true' upon a correct answer - and any change it makes
  #   to Rg2 in that event will be inconsequential (if at all extant).
  # Otherwise, it uses Rg2 as a place to save data-info.
  my $lc_dat;
  my $lc_odat;
  my $lc_q;
  
  
  $lc_q = $_[0];
  $lc_odat = $_[2];
  $lc_dat = {};
  $_[2] = $lc_dat;
  
  system("clear");
  system("echo","WRONG ANSWER - REPEAT EXERCISE");
  &show_by_format($lc_q->{'inst'});
  
  system("echo");
  system("echo",(' --> : ' . $lc_q->{'pre'} . $lc_q->{'a'} . ' :'));
  system("echo",(' NOT : ' . $lc_q->{'pre'} . $lc_odat->{'answr'} . ' :'));
  
  system("echo","-n",("\n" . '     > ' . $lc_q->{'pre'}));
  $lc_dat->{'answr'} = &chobak_jsio::inln();
  
  return($lc_dat->{'answr'} eq $lc_q->{'a'});
}



sub do_congrat {
  system("echo","\n\nCORRECT\n\n");
}



sub show_by_format {
  my $lc_ref;
  my @lc_left;
  my $lc_cnt;
  my $lc_typ;
  
  $lc_ref = $_[0];
  @lc_left = @$lc_ref;
  $lc_cnt = @lc_left;
  if ( $lc_cnt < 1.5 ) { return; }
  $lc_typ = shift(@lc_left);
  
  if ( $lc_typ eq 'ds' )
  {
    while ( $lc_cnt > 0.5 )
    {
      my $lc3_lin;
      $lc3_lin = shift(@lc_left);
      system("echo",("\n" . $lc3_lin));
      $lc_cnt = @lc_left;
    }
    return;
  }
}


1;
