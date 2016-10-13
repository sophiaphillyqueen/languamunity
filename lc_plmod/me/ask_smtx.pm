package me::ask_smtx;
use strict;
use chobak_json;
use chobak_jsio;
use chobak_cstruc;
use me::longterm;
use me::otherans;
use me::tally_basics;
use me::voca;

sub prime {
  my $lc_useit;
  
  &chobak_json::clone($_[0],$lc_useit);
  $_[1]->{'pristine'} = $_[0];
  $_[1]->{'err_deck'} = [$_[0]];
  $_[1]->{'err_hand'} = [$_[0]];
  return &artifice($lc_useit,$_[1]);
}

sub artifice {
  my $lc_qus;
  my $lc_phase;
  my $lc_promptx;
  my $lc_maybe;
  my $lc_altern;
  my $lc_answr;
  my @lc_alter_a; # List of prompt-lines in response to alternate answers
  my $lc_anoncia;
  
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
  
  &me::otherans::do_clear();
  
  #&chobak_json::clone($_[0],$lc_qus);
  $lc_qus = $_[0];
  
  $lc_phase = 1;
  # Phase 1: No wrong answer has been given - nor any right answer
  # Phase 2: Handling of a wrong answer
  # Phase 3: EXITING:
  $lc_promptx = '';
  $lc_promptx .= $lc_qus->{'lang'}->[0];
  $lc_promptx .= ' -> ';
  $lc_promptx .= $lc_qus->{'lang'}->[1];
  $lc_promptx .= "\n\n";
  $lc_promptx .= $lc_qus->{'q'};
  $lc_anoncia = 'ASKING';
  
  
  # Now we obtain the lists of lines to add to the prompt if provided
  # with an answer that is technically not incorrect, but is not the
  # one we're looking for.
  {
    my $lc2_a;
    $lc2_a = $lc_qus->{'o'};
    @lc_alter_a = ();
    if ( ref($lc2_a) eq 'ARRAY' )
    {
      @lc_alter_a = @$lc2_a;
    }
  }
  
  while ( $lc_phase < 1.5 )
  {
    system("clear");
    system("echo",$lc_anoncia . ":\n");
    system("echo","-n",$lc_promptx . "\n\n:> ");
    
    $lc_answr = &chobak_jsio::inln();
    if ( &correct($lc_answr,$lc_qus->{'a'},$lc_altern) )
    {
      $lc_phase = 3;
    }
    
    if ( $lc_phase < 2.5 )
    {
      $lc_phase = 2;
      if ( &match_any_of($lc_answr,\@lc_alter_a,$lc_promptx) )
      {
        $lc_phase = 1;
        $lc_anoncia = 'BUT WE SEEK ANOTHER ANSWER';
      }
    }
  }
  
  while ( $lc_phase < 2.5 )
  {
    &chobak_cstruc::ry_m_push($_[1]->{'main'}->{'rehand'},$_[1]->{'err_hand'});
    
    
    #if ( rand(10) > 2 )
    &chobak_cstruc::ry_m_push($_[1]->{'main'}->{'redeck'},$_[1]->{'err_deck'});
    
    &me::longterm::savefail({
      'qus' => $lc_qus,
      'gvn' => $lc_answr,
    });
    
    
    system("clear");
    system("echo","WRONG:\n");
    &me::tally_basics::cusv_incr('oops');
    system("echo",$lc_promptx . "\n");
    &shouldbe($lc_qus->{'a'});
    system("echo","NOT: " . $lc_answr . ' :');
    system("echo","-n","\n:> ");
    
    $lc_answr = &chobak_jsio::inln();
    if ( &correct($lc_answr,$lc_qus->{'a'},$lc_altern) ) { $lc_phase = 3; }
  }
  
  system("echo","\nCORRECT:");
  &me::voca::sayit($lc_qus->{'a'},$lc_qus->{'voca'},{});
  if ( $lc_altern ne '' )
  {
    #system("echo","-n","\nAlso acceptable woud be:\n" . $lc_altern);
    &me::otherans::do_set($lc_altern);
  }
  return 10;
}

sub may_match_this {
  my $lc_list;
  my @lc_llist;
  my $lc_item;
  $lc_list = $_[1];
  @lc_llist = @$lc_list;
  $lc_item = @lc_llist;
  if ( $lc_item < 1.5 ) { return ( 0 > 5 ); }
  shift(@lc_llist);
  
  foreach $lc_item (@lc_llist)
  {
    if ( $lc_item eq $_[0] ) { return ( 10 > 5 ); }
  }
  
  return ( 0 > 5 );
}

sub match_any_of {
  my $lc_full_list;
  my $lc_survive;
  my $lc_prompt;
  my @lc_nomatch;
  my $lc_tis_this;
  my $lc_offhit;
  
  $lc_survive = 0;
  @lc_nomatch = ();
  $lc_full_list = $_[1];
  $lc_prompt = $_[2];
  
  foreach $lc_offhit (@$lc_full_list)
  {
    $lc_tis_this = &may_match_this($_[0],$lc_offhit);
    if ( $lc_tis_this )
    {
      $lc_survive = 10;
      $lc_prompt .= "\n" . $lc_offhit->[0];
    } else {
      @lc_nomatch = (@lc_nomatch,$lc_offhit);
    }
  }
  
  @$lc_full_list = @lc_nomatch;
  if ( $lc_survive > 5 ) { $_[2] = $lc_prompt; }
  return ( $lc_survive > 5 );
}

sub savefail {
  my $lc_filn;
  my $lc_cont;
  
  $lc_filn = &me::longterm::fjsnm('fail');
  $lc_cont = &chobak_json::readf($lc_filn);
  @$lc_cont = (@$lc_cont,@_);
  &chobak_json::savef($lc_cont,$lc_filn);
}

sub shouldbe {
  my $lc_ref;
  my $lc_each;
  if ( ref($_[0]) eq '' )
  {
    system("echo","The correct answer:\n   : " . $_[0] . ' :');
    return;
  }
  if ( ref($_[0]) eq 'ARRAY' )
  {
    system("echo","Possible answers:");
    $lc_ref = $_[0];
    foreach $lc_each (@$lc_ref)
    {
      system("echo",'   : ' . $lc_each . ' :');
    }
  }
}

sub correct {
  my $lc_ref;
  my $lc_each;
  my $lc_alt;
  my $lc_pass;
  
  $lc_pass = 0;
  $lc_ref = $_[1];
  
  # What if the answer provided is not an array?
  if ( ref($lc_ref) eq '' )
  {
    $_[2] = '';
    return ( $lc_ref eq $_[0] );
  }
  
  $lc_alt = '';
  foreach $lc_each (@$lc_ref)
  {
    if ( $lc_each eq $_[0] ) { $lc_pass = 10; }
    else { $lc_alt .= ' : ' . $lc_each . ' :' . "\n"; }
  }
  $_[2] = $lc_alt;
  return ( $lc_pass > 5 );
}



1;
