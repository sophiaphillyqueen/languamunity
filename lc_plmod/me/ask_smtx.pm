package me::ask_smtx;
use strict;
use chobak_json;
use chobak_jsio;
use chobak_cstruc;

sub prime {
  my $lc_qus;
  my $lc_phase;
  my $lc_promptx;
  my $lc_maybe;
  my $lc_altern;
  my $lc_answr;
  
  &chobak_json::clone($_[0],$lc_qus);
  $lc_phase = 1;
  # Phase 1: No wrong answer has been given - nor any right answer
  # Phase 2: Handling of a wrong answer
  # Phase 3: EXITING:
  $lc_promptx = $lc_qus->{'q'};
  
  while ( $lc_phase < 1.5 )
  {
    system("clear");
    system("echo","ASKING:\n");
    system("echo","-n",$lc_promptx . "\n\n:> ");
    
    $lc_answr = &chobak_jsio::inln();
    if ( &correct($lc_answr,$lc_qus->{'a'},$lc_altern) )
    {
      $lc_phase = 3;
    }
    
    if ( $lc_phase < 2.5 ) { $lc_phase = 2; }
  }
  
  while ( $lc_phase < 2.5 )
  {
    &chobak_cstruc::ry_push($_[1]->{'main'}->{'hand'},$_[0]);
    if ( rand(10) > 8 )
    {
      &chobak_cstruc::ry_push($_[1]->{'main'}->{'deck'},$_[0]);
    }
    
    &savefail({
      'qus' => $lc_qus,
      'gvn' => $lc_answr,
    });
    
    
    system("clear");
    system("echo","WRONG:\n");
    system("echo",$lc_promptx . "\n");
    &shouldbe($lc_qus->{'a'});
    system("echo","NOT: " . $lc_answr . ' :');
    system("echo","-n","\n:> ");
    
    $lc_answr = &chobak_jsio::inln();
    if ( &correct($lc_answr,$lc_qus->{'a'},$lc_altern) ) { $lc_phase = 3; }
  }
  
  system("echo","\nCORRECT:");
  if ( $lc_altern ne '' )
  {
    system("echo","-n","\nAlso acceptable woud be:\n" . $lc_altern);
  }
  return 10;
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
