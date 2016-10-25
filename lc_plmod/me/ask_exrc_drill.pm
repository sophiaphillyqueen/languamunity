package me::ask_exrc_drill;
use strict;
# The original form of the 'exrc' flashcard had one card-record
# per-form per-tense. This turned out to be a bit boggling -
# thus impeding the learning process. Therefore, this new
# variant is being implemented that allows me to drill all
# forms within a tense in a single flash-card as list form
# so that the focus-on-one-form-of-the-tense type flashcards
# will instead get auto-generated whenever the user
# indicates the need to do repetition-drilling on a
# specific, problematic form.
#
#
# It should be noted that NOTHING in this file should EVER
# be accessed DIRECTLY from OUTSIDE the file - with the
# exception of the function 'prime'.
#
# This is because everything else is part of the internal
# mechanics of the module.
use chobak_json;
use chobak_cstruc;
use chobaktime;
use chobak_jsio;
use me::core_quiz_cmd;

my $qst_text;

my $lastq_set;
my $lastq_val;
my $biggest_f;
my $active_q;

my $deckref;

sub prime {
  my $lc_allln;
  my $lc_eachln;
  
  # Validade this card for the re-prompt:
  &me::tally_basics::card_valid_on();
  
  &chobak_json::clone($_[0],$active_q);
  $deckref = $_[1];
  
  # The question text starts empty until stuff gets
  # added to it:
  $qst_text = '';
  
  
  # Fix the full-fledge rehash-request data:
  {
    my $lc2_sta;
    my $lc2_stb;
    $lc2_sta->{'redeck'} = [$_[0]];
    $lc2_sta->{'rehand'} = [$_[0]];
    &chobak_json::clone($lc2_sta,$lc2_stb);
    &me::tally_basics::opto_review_in($lc2_stb);
  }
  
  # First, let us add the intro lines to the text:
  &add_intro_lines($active_q->{'inst'});
  
  # Initialize certain registries:
  $lastq_set = 0; # the first item has no 'previous item'.
  $biggest_f = 0; # At start, the maximum number of wrong-answers is zero.
  
  # Now we go through the lines:
  $lc_allln = $active_q->{'lines'};
  if ( ref($lc_allln) eq 'ARRAY' )
  {
    foreach $lc_eachln (@$lc_allln) { &do_the_line($lc_eachln,$active_q->{'voca'}); }
  }
  &do_after_line();
  
  # And last but not least --- let us add rehashes appropriate to the
  # number of errors on the most-missed line:
  while ( $biggest_f > 0.5 )
  {
    &me::tally_basics::cusv_incr('oops');
    &chobak_cstruc::ry_m_push($deckref->{'main'}->{'rehand'},[$_[0]]);
    &chobak_cstruc::ry_m_push($deckref->{'main'}->{'redeck'},[$_[0]]);
    $biggest_f = int($biggest_f - 0.8);
  }
  
  return 10;
}

sub add_intro_lines {
  my $lc_ray;
  my $lc_typ;
  
  { my $lc2_rf; $lc2_rf = $_[0]; $lc_ray = [@$lc2_rf]; }
  $lc_typ = &chobak_cstruc::ry_shift($lc_ray);
  
  if ( $lc_typ eq 'ds' )
  {
    while ( &chobak_cstruc::counto($lc_ray) > 0.5 )
    {
      $qst_text .= ': ' . &chobak_cstruc::ry_shift($lc_ray) . "\n";
    }
    $qst_text .= "\n";
    return;
  }
}

sub do_after_line {
  my $lc_cm;
  $lc_cm = '';
  while ( &me::distress::trpcmd($lc_cm) )
  {
    &procomd($lc_cm);
    system("clear");
    system("echo","-n",("DONE\n\n" . $qst_text . "\n\n" . '[Any last in-card commands?]> '));
  }
}

sub do_the_line {
  my $lc_entr;
  my $lc_answr;
  my $lc_nota;
  my $lc_bado;
  my $lc_fails;
  
  # Of course - the first round, it
  # is EXPECTED that the 'previous'
  # answer not match the right one.
  $lc_nota = 'SEQUENCE-DRILL';
  $lc_bado = 0;
  $lc_answr = ( $_[0]->{'a'} . 'xx' );
  
  # And we are tallying the results:
  $lc_fails = 0;
  
  while ( $lc_answr ne ($_[0]->{'a'}) )
  {
    $lc_entr = '';
    while ( &me::distress::trpcmd($lc_entr) )
    {
      &procomd($lc_entr);
      system("clear");
      system("echo",($lc_nota . "\n\n" . $qst_text));
      
      if ( $lc_bado > 5 )
      {
        system("echo",("   : " . $_[0]->{'pre'} . $_[0]->{'a'} . " :"));
        system("echo",("NOT: " . $_[0]->{'pre'} . $lc_answr . " :\n"));
      }
      
      system("echo","-n",('   > ' . $_[0]->{'pre'}));
    } $lc_answr = $lc_entr;
    
    
    if ( $lc_bado > 5 ) { $lc_fails = int($lc_fails + 1.2); }
    # Of course, if we will have to go another round,
    # that is because there was a mistake.
    $lc_bado = 10;
  }
  
  # Now we vocalize it -- if applicable
  &vocalize($_[0],$_[1]);
  
  
  # Is this the biggest number of mistakes?
  if ( $lc_fails > $biggest_f ) { $biggest_f = $lc_fails; }
  
  # Make sure this line is visible for future ines:
  $qst_text .= $_[0]->{'x'} . $_[0]->{'pre'} . $_[0]->{'a'} . "\n";
  $lastq_val = $_[0]; $lastq_set = 10;
}

sub vocalize {
  my $lc_pre;
  $lc_pre = $_[0]->{'pre'};
  
  if ( defined($_[0]->{'apre'}) ) { $lc_pre = $_[0]->{'apre'}; }
  if ( ref($lc_pre) eq 'ARRAY' ) { $lc_pre = &chobak_cstruc::rand_item_of_array($lc_pre); }
  if ( ref($lc_pre) eq 'ARRAY' ) { $lc_pre = &chobak_cstruc::rand_item_of_array($lc_pre); }
  if ( ref($lc_pre) eq 'ARRAY' ) { $lc_pre = &chobak_cstruc::rand_item_of_array($lc_pre); }
  
  &me::voca::sayit(($lc_pre . $_[0]->{'a'}),$_[1],{});
}

sub procomd {
  if ( $_[0] eq '**rv' ) { &rhash_last(); return; }
  if ( $_[0] eq '**vc' ) { &me::voca::aprosay(); return; }
  if ( $_[0] eq '**vc-on' ) { &me::core_quiz_cmd::set__voca__on(); return; }
}

sub rhash_last {
  my $lc_newc;
  my $lc_howmany;
  my $lc_done;
  if ( $lastq_set < 5 ) { return; }
  
  $lc_newc = {
    'typ' => 'exrc',
    'form' => 'focus',
  };
  $lc_newc->{'mort'} = &chobaktime::nowo();
  
  &chobak_cstruc::copy_fields($active_q,$lc_newc,['inst','voca','qvoca']);
  &chobak_cstruc::copy_fields($lastq_val,$lc_newc,['pre','a','apre']);
  
  system("echo","-n","\n\nHow many rehash-pairs of last COMPLETED line? [0-30] ");
  $lc_howmany = &chobak_jsio::inln();
  $lc_done = 0;
  $lc_howmany = int($lc_howmany + 0.49);
  if ( $lc_howmany > 30 ) { $lc_howmany = 30; }
  while ( $lc_howmany > 0.5 )
  {
    &me::tally_basics::cusv_incr('rqst');
    &chobak_cstruc::ry_m_push($deckref->{'main'}->{'rehand'},[$lc_newc]);
    &chobak_cstruc::ry_m_push($deckref->{'main'}->{'redeck'},[$lc_newc]);
    $lc_howmany = int($lc_howmany - 0.8);
    $lc_done = int($lc_done + 1.2);
  }
  system("echo",($lc_done . " rehash-pairs added:")); sleep(1);
}




1;
