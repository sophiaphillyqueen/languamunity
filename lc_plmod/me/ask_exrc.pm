package me::ask_exrc;
use strict;
use chobak_json;
use me::tally_basics;
use me::otherans;
use chobak_cstruc;
use me::voca;
use me::distress;
use me::ask_exrc_drill;
use me::valus;

sub prime {
  my $lc_useit;
  my $lc_ok;
  
  # The 'drill' subform is diverted to the alternative:
  if ( $_[0]->{'form'} eq 'drill' ) { return me::ask_exrc_drill::prime($_[0],$_[1]); }
  
  # Now to filter out the old questions by assuring that continuation is only with
  # authorized forms:
  $lc_ok = 0;
  # - The 'focus' form is for those that were auto-generated upon request for focus:
  # However - they are slated for automatic discard 36 hours after they are generated.
  if ( $_[0]->{'form'} eq 'focus' )
  {
    if ( &me::distress::mortcalc($_[0]->{'mort'}) ) { $lc_ok = 10; }
    #my $lc2_now;
    #my $lc2_then;
    #$lc2_now = &chobaktime::nowo();
    #$lc2_then = $_[0]->{'mort'};
    #$lc_ok = 10;
    #if ( $lc2_then > ( $lc2_now + 300 ) ) { $lc_ok = 0; }
    #if ( $lc2_then < ( $lc2_now - ( 60 * 60 * &me::valus::look('mortality-hours') ) ) ) { $lc_ok = 0; }
  }
  if ( $lc_ok < 5 ) {
    system("clear");
    system("echo","\nEXPIRED AND/OR MAL-FORMED FLASH-CARD --- SKIPPED:\n");
    return 10;
  }
  
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
  
  # Validade this card for the re-prompt:
  &me::tally_basics::card_valid_on();
  
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
  
  # Now we defer that which must be deferred:
  if ( $lc_usinf->{'defer'} )
  {
    &chobak_cstruc::ry_m_push($_[1]->{'main'}->{'redeck'},$_[1]->{'err_deck'});
    system("echo","\n\nDEFERRED (but not forgotten)\n\n");
    return 10;
  }
  
  $lc_success = ( 1 > 2 );
  while ( !($lc_success) )
  {
    &me::tally_basics::cusv_incr('oops');
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
  my $lc_ret;
  my $lc_entr;
  
  
  $lc_q = $_[0];
  $lc_dat = $_[2];
  
  $lc_dat->{'defer'} = (1>2);
  
  $lc_entr = '';
  while ( &me::distress::trpcmd($lc_entr) ) {
    
    # For things that must be deferred ...
    if ( $lc_entr eq '**lt' )
    {
      $lc_dat->{'defer'} = (2>1);
      return(1>2);
    }
    
    system("clear");
    system("echo","EXERCISE");
    &show_by_format($lc_q->{'inst'});
    
    system("echo","-n",("\n" . '  > ' . $lc_q->{'pre'}));
  }
  #$lc_dat->{'answr'} = &chobak_jsio::inln();
  $lc_dat->{'answr'} = $lc_entr;
  
  $lc_ret = ($lc_dat->{'answr'} eq $lc_q->{'a'});
  if ( $lc_ret ) { &me::voca::sayit(($lc_q->{'pre'} . $lc_q->{'a'}),$lc_q->{'voca'},{}); }
  return $lc_ret;
}

sub do_ask_again {
  # FUNCTION BEHAVIOR:
  # Simply returns 'true' upon a correct answer - and any change it makes
  #   to Rg2 in that event will be inconsequential (if at all extant).
  # Otherwise, it uses Rg2 as a place to save data-info.
  my $lc_dat;
  my $lc_odat;
  my $lc_q;
  my $lc_ret;
  
  
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
  
  $lc_ret = ($lc_dat->{'answr'} eq $lc_q->{'a'});
  if ( $lc_ret ) { &me::voca::sayit(($lc_q->{'pre'} . $lc_q->{'a'}),$lc_q->{'voca'},{}); }
  return $lc_ret;
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
      system("echo",("\n        " . $lc3_lin));
      $lc_cnt = @lc_left;
    }
    return;
  }
}


1;
