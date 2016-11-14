package me::core_quiz_cmd;
use strict;
use chobak_io;
use chobaktime;
use me::longterm;
use me::ask_smtx;
use me::ask_subst;
use me::ask_exrc;
use me::tally_basics;
use me::valus;
use me::voca;
use me::head_elsewhere;


my $arcosa;
my $lastcomd = '';
my $handsize;

my $before_prompt = [];
my $before_resume = [];

sub set_b_prompt {
  @$before_prompt = (@$before_prompt,@_);
}

sub set_b_resume {
  @$before_resume = (@$before_resume,@_);
}

sub set_arcosa_var {
  $arcosa = $_[0];
  $handsize = 20;
  if ( defined($arcosa->{'stng'}->{'handsize'}) )
  {
    my $lc2_hs;
    $lc2_hs = int($arcosa->{'stng'}->{'handsize'} + 0.4);
    if ( $lc2_hs > 0.5 ) { $handsize = $lc2_hs; }
  }
  &me::voca::set_arcosa_var($arcosa);
  &me::distress::set_arcosa_var($arcosa);
}


sub may_resume {
  my $lc_sfar;
  my $lc_test;
  $lc_sfar = ( 10 > 5 );
  
  foreach $lc_test (@$before_resume)
  {
    if ( $lc_sfar )
    {
      $lc_sfar = ( (&$lc_test()) > 5 );
    }
  }
  return $lc_sfar;
}

sub inspect_the_dam {
  system("echo",("\n\nCurrent height of the dam: " . &me::tally_basics::cusv_get('dam') . ":\n"));
}

sub raise_the_dam {
  my $lc_max;
  my $lc_entr;
  my $lc_bnum;
  
  $lc_max = &me::valus::look('max-dam-height');
  
  system("echo","-n",("\n\n"
    . "Halt the re-introduction of long-term rehashes for a\n"
    . "specific number of rounds.\n\n"
    . "How many rounds should that be? (0-" . $lc_max . ") "
  ));
  
  $lc_entr = &chobak_io::inln();
  $lc_bnum = int($lc_entr + 0.2);
  if ( $lc_bnum < 0 ) { $lc_bnum = 0; }
  if ( $lc_bnum > $lc_max ) { $lc_bnum = $lc_max; }
  
  &me::tally_basics::cusv_set('dam',$lc_bnum);
  system("echo",("\nDam height set to: " . $lc_bnum . ":\n"));
}

sub demand_extra_review {
  my $lc_count;
  my $lc_set;
  my $lc_all;
  my $lc_item;
  system("echo","-n","\n\nVoluntary equivalent of now many wrong answers? (1-10) ");
  $lc_count = &chobak_io::inln();
  if ( $lc_count > 10 ) { $lc_count = 10; }
  $lc_set = &me::tally_basics::opto_review_out();
  while ( $lc_count > 0.5 )
  {
    &me::tally_basics::cusv_incr('rqst');
    $lc_all = $lc_set->{'rehand'};
    if ( ref($lc_all) ne 'ARRAY' ) { $lc_all = []; }
    foreach $lc_item (@$lc_all) { if ( ref($lc_item) eq 'HASH' ) { &chobak_cstruc::ry_push($arcosa->{'rehand'},$lc_item); } }
    $lc_all = $lc_set->{'redeck'};
    if ( ref($lc_all) ne 'ARRAY' ) { $lc_all = []; }
    foreach $lc_item (@$lc_all) { if ( ref($lc_item) eq 'HASH' ) { &chobak_cstruc::ry_push($arcosa->{'redeck'},$lc_item); } }
    $lc_count = int($lc_count - 0.8);
  }
  system("echo","\n");
}


sub set__voca__on {
  $arcosa->{'stng'}->{'voca'} = 'on';
  system("echo","\nAudio repetition of answers enabled.\n");
}

sub set__voca__off {
  $arcosa->{'stng'}->{'voca'} = 'off';
  system("echo","\nAudio repetition of answers DEACTIVATED.\n");
}

sub set__voca__fg {
  $arcosa->{'stng'}->{'voca'} = 'fg';
  system("echo","\nAudio repetition of answers enabled\n  -- And in Foreground Mode.\n");
}


sub anotround {
  # Declearations:
  my $lc_aloop;
  
  $lc_aloop = 10;
  while ( $lc_aloop > 5 )
  {
    $lc_aloop = 0;
    if ( $lastcomd eq 'h' ) { $lc_aloop = 10; &get_me_help(); }
    if ( $lastcomd eq 'rvu' ) { $lc_aloop = 10; &demand_extra_review(); }
    if ( $lastcomd eq 'dam' ) { $lc_aloop = 10; &raise_the_dam(); }
    if ( $lastcomd eq 'ldam' ) { $lc_aloop = 10; &inspect_the_dam(); }
    if ( $lastcomd eq 'vc-on' ) { $lc_aloop = 10; &set__voca__on(); }
    if ( $lastcomd eq 'vc-off' ) { $lc_aloop = 10; &set__voca__off(); }
    if ( $lastcomd eq 'vc-fg' ) { $lc_aloop = 10; &set__voca__fg(); }
    if ( $lastcomd eq 'vc' ) { $lc_aloop = 10; &me::voca::aprosay(); }
    
    if ( $lastcomd eq 'out' ) { $lc_aloop = 10; &me::head_elsewhere::haltquiz(); }
    if ( $lastcomd eq '**out' ) { $lc_aloop = 10; &me::head_elsewhere::haltquiz(); }
    
    if ( $lastcomd eq 'clrm' )
    {
      my $lc3_a;
      $lc3_a = &me::valus::look('mortality-minutes');
      $lc_aloop = 10;
      $arcosa->{'stng'}->{'mort'} = int(&chobaktime::nowo() + 0.2 - ( 60 * $lc3_a ));
      system("echo",("\nExpired All Time-Limited Flashcards over " . $lc3_a . " minutes old:\n"));
    }
    
    if ( $lastcomd eq 'clrm-total' )
    {
      my $lc3_a;
      $lc3_a = &me::valus::look('mortality-minutes');
      $lc_aloop = 10;
      $arcosa->{'stng'}->{'mort'} = &chobaktime::nowo();
      system("echo",("\nExpired All Time-Limited Flashcards - all of them:\n"));
    }
    
    if ( $lc_aloop > 5 ) { &enter_the_prompt(); }
  }
  
  if ( $lastcomd eq '' )
  {
    if ( !(&may_resume()) ) { return ( 0 > 5 ); }
    return ( &make_a_question() > 5 );
  }
  if ( $lastcomd eq 'save' ) { &me::longterm::save($arcosa); return(&may_resume()); }
  if ( $lastcomd eq 'x' ) { return(0 > 5); }
  
  return(&may_resume());
}

sub get_me_help {
  my $lc_dt;
  $lc_dt = "\n";
  $lc_dt .= "h - - -- Display this help message:\n";
  $lc_dt .= "save - - Save status - and continue the quiz:\n";
  $lc_dt .= "x - - -- Save status and exit the program:\n";
  $lc_dt .= "rvu - -- Request additional volutnary review:\n";
  $lc_dt .= "vc-on -- Turn audio on:\n";
  $lc_dt .= "vc-off - Turn audio off:\n";
  $lc_dt .= "vc-fg -- Turn audio on - foreground mode:\n";
  $lc_dt .= "vc - - - Sound off the most recent flash-card (if the card supports it):\n";
  system("echo","-n",$lc_dt);
}



sub enter_the_prompt {
  my $lc_prmp;
  my $lc_step;
  my $lc_dxref;
  my $lc_dxeach;
  
  if ( &me::tally_basics::card_valid_no() )
  {
    $lastcomd = '';
    return;
  }
  
  foreach $lc_step (@$before_prompt)
  {
    &$lc_step();
  }
  
  $lc_prmp = "\n";
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'rehand'});
  $lc_prmp .= ':';
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'redeck'});
  $lc_prmp .= ': - :';
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'hand'});
  $lc_dxref = $arcosa->{'mtdeck'};
  foreach $lc_dxeach (@$lc_dxref)
  {
    $lc_prmp .= ':';
    $lc_prmp .= &chobak_cstruc::counto($lc_dxeach);
  }
  $lc_prmp .= ': - :';
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'hnd01'});
  $lc_prmp .= ':';
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'hnd02'});
  $lc_prmp .= ':';
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'hnd03'});
  $lc_prmp .= ':';
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'deck'});
  $lc_prmp .= "\n\n[\"h\"/\"x\"/..] JUST [enter] TO CONTINUE:> ";
  
  system("echo","-n",$lc_prmp);
  $lastcomd = &chobak_io::inln();
}

#sub decktohand {
#  my $lc_a;
#  $lc_a = &chobak_cstruc::counto($arcosa->{'hand'});
#  if ( $lc_a > ( $handsize - 0.5 ) ) { return; }
#  $lc_a = &chobak_cstruc::counto($arcosa->{'deck'});
#  if ( $lc_a < ( 0.5 ) ) { return; }
#  
#  $lc_a = &chobak_cstruc::ry_hat($arcosa->{'deck'});
#  &chobak_cstruc::ry_push($arcosa->{'hand'},$lc_a);
#}
sub decktohand_slc {
  # Return 10 if we re-load a missed question
  # Return 0 if we load a brand-new question
  my $lc_rand_val;
  my $lc_siz_rdeck;
  
  if ( &chobak_cstruc::counto($arcosa->{'deck'}) < 0.5 ) { return 10; }
  
  $lc_siz_rdeck = &chobak_cstruc::counto($arcosa->{'redeck'});
  if ( $lc_siz_rdeck < 0.5 ) { return 0; }
  
  $lc_rand_val = rand($handsize * 6);
  if ( $lc_siz_rdeck > $lc_rand_val ) { return 10; }
  return 0;
}

sub megadeckthand {
  my $lc_tmhold;
  my $lc_ok_reload;
  my $lc_mdeck_count;
  my $lc_mhand_count;
  my $lc_rand_elem;
  
  # First, we make sure that the deck and hand swap if the hand
  # is empty. Using this strategy (rather than the old one) we
  # can assure that no questions sit in the Eternal Rot.
  #if ( &chobak_cstruc::counto($arcosa->{'hand'}) < 0.5 )
  #{
  #  $lc_tmhold = $arcosa->{'hand'};
  #  $arcosa->{'hand'} = $arcosa->{'deck'};
  #  $arcosa->{'deck'} = $lc_tmhold;
  #}
  #
  # SECOND VERSION ALSO COMMENTED OUT
  #&chobak_cstruc::upfrs_hrf($arcosa,'deck',$arcosa,'hnd03');
  #&chobak_cstruc::upfrs_hrf($arcosa,'hnd03',$arcosa,'hnd02');
  #&chobak_cstruc::upfrs_hrf($arcosa,'hnd02',$arcosa,'hnd01');
  #&chobak_cstruc::upfrs_hrf($arcosa,'hnd01',$arcosa,'hand');
  #
  &me::tally_basics::shift_unasked_in_arcos($arcosa);
  
  if ( &me::tally_basics::cusv_get('dam') < 0.5 ) # Don't leak longterm if dam is up
  {
    # Now we decide if it is time to reload a question from the
    # Missed Deck to the Missed Hand
    $lc_mdeck_count = &chobak_cstruc::counto($arcosa->{'redeck'});
    $lc_mhand_count = &chobak_cstruc::counto($arcosa->{'rehand'});
    $lc_rand_elem = rand(&me::valus::look('min-longterm-qfac') + ( $lc_mhand_count * 3 ) );
    $lc_ok_reload = ( $lc_rand_elem < $lc_mdeck_count );
    if ( $lc_ok_reload ) { $lc_ok_reload = ( $lc_mdeck_count > 0.5 ); }
    
    # And we do the reload if applicable
    if ( $lc_ok_reload )
    {
      $lc_tmhold = &chobak_cstruc::ry_hat($arcosa->{'redeck'});
      &chobak_cstruc::ry_push($arcosa->{'rehand'},$lc_tmhold);
    }
  }
  &me::tally_basics::cusv_decr('dam'); # But also don't keep the dam up forever
}



sub make_a_question {
  my $lc_from_prev_err;
  my $lc_err_size;
  my $lc_qus;
  
  &megadeckthand();
  if ( &me::tally_basics::complete_hand($arcosa) < 0.5 ) { return 0; }
  
  $lc_from_prev_err = 0;
  $lc_err_size = &chobak_cstruc::counto($arcosa->{'rehand'});
  if ( $lc_err_size > rand($handsize) ) { $lc_from_prev_err = 10; }
  if ( $lc_err_size < 0.5 ) { $lc_from_prev_err = 0; }
  
  if ( $lc_from_prev_err < 5 ) { $lc_qus = &chobak_cstruc::ry_hat($arcosa->{'hand'}); }
  if ( $lc_from_prev_err > 5 ) { $lc_qus = &chobak_cstruc::ry_hat($arcosa->{'rehand'}); }
  
  # By default, all cards are presumed invalid until
  # demonstrated to be valid.
  &me::tally_basics::card_valid_off();
  
  &chobak_cstruc::force_hash_has_hash($lc_qus,'score');
  if ( $lc_qus->{'typ'} eq 'smtx' ) { return &me::ask_smtx::prime($lc_qus,{
    'main' => $arcosa,
  }); }
  if ( $lc_qus->{'typ'} eq 'subst' ) { return &me::ask_subst::prime($lc_qus,{
    'main' => $arcosa,
  }); }
  if ( $lc_qus->{'typ'} eq 'exrc' ) { return &me::ask_exrc::prime($lc_qus,{
    'main' => $arcosa,
  }); }
  
  return 10;
}

1;
