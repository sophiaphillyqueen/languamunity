package me::core_quiz_cmd;
use strict;
use chobak_io;
use me::longterm;
use me::ask_smtx;
use me::ask_subst;
use me::tally_basics;


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


sub anotround {
  # Declearations:
  
  while ( $lastcomd eq 'h' ) { &get_me_help(); }
  
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
  $lc_dt .= "h - - - Display this help message:\n";
  $lc_dt .= "save -- Save status - and continue the quiz:\n";
  $lc_dt .= "x - - - Save status and exit the program:\n";
  system("echo","-n",$lc_dt);
  &enter_the_prompt();
}



sub enter_the_prompt {
  my $lc_prmp;
  my $lc_step;
  my $lc_dxref;
  my $lc_dxeach;
  
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
  $lc_prmp .= "[\"h\"/\"x\"/..] JUST [enter] TO CONTINUE:> ";
  
  system("echo","-n",$lc_prmp);
  $lastcomd = &chobak_io::inln;
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
  
  # Now we decide if it is time to reload a question from the
  # Missed Deck to the Missed Hand
  $lc_mdeck_count = &chobak_cstruc::counto($arcosa->{'redeck'});
  $lc_mhand_count = &chobak_cstruc::counto($arcosa->{'rehand'});
  $lc_rand_elem = rand(50 + ( $lc_mhand_count * 3 ) );
  $lc_ok_reload = ( $lc_rand_elem < $lc_mdeck_count );
  if ( $lc_ok_reload ) { $lc_ok_reload = ( $lc_mdeck_count > 0.5 ); }
  
  # And we do the reload if applicable
  if ( $lc_ok_reload )
  {
    $lc_tmhold = &chobak_cstruc::ry_hat($arcosa->{'redeck'});
    &chobak_cstruc::ry_push($arcosa->{'rehand'},$lc_tmhold);
  }
}

sub old_megadeckthand {
  #if ( &chobak_cstruc::counto($arcosa->{'deck'}) < 0.5 ) { return; }
  #&decktohand(); &decktohand();
  #if ( &chobak_cstruc::counto($arcosa->{'deck'}) < 0.5 ) { return; }
  #&decktohand(); &decktohand();
  #if ( &chobak_cstruc::counto($arcosa->{'deck'}) < 0.5 ) { return; }
  #&decktohand(); &decktohand();
  #if ( &chobak_cstruc::counto($arcosa->{'deck'}) < 0.5 ) { return; }
  #&decktohand(); &decktohand();
  #if ( &chobak_cstruc::counto($arcosa->{'deck'}) < 0.5 ) { return; }
  #&decktohand(); &decktohand();
  my $lc_count;
  my $lc_chosen;
  my $lc_elem;
  
  for ( $lc_count = 0; $lc_count < ($handsize - 0.5); $lc_count = int($lc_count + 1.2) )
  {
    # First recognize certain writings on the wall as signs that it is
    # time to return;
    if ( &me::tally_basics::complete_deck($arcosa) < 0.5 ) { return; }
    if ( &me::tally_basics::complete_hand($arcosa) > ( $handsize - 0.5 ) ) { return; }
    
    # And if it is time, then we do a round:
    $lc_chosen = &decktohand_slc();
    if ( $lc_chosen > 5 ) {
      $lc_elem = &chobak_cstruc::ry_hat($arcosa->{'redeck'});
      &chobak_cstruc::ry_push($arcosa->{'rehand'},$lc_elem);
    } else {
      $lc_elem = &chobak_cstruc::ry_hat($arcosa->{'deck'});
      &chobak_cstruc::ry_push($arcosa->{'hand'},$lc_elem);
    }
  }
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
  
  &chobak_cstruc::force_hash_has_hash($lc_qus,'score');
  if ( $lc_qus->{'typ'} eq 'smtx' ) { return &me::ask_smtx::prime($lc_qus,{
    'main' => $arcosa,
  }); }
  if ( $lc_qus->{'typ'} eq 'subst' ) { return &me::ask_subst::prime($lc_qus,{
    'main' => $arcosa,
  }); }
  
  return 10;
}

1;
