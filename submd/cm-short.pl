use strict;
use chobak_io;
use me::longterm;
use me::ask_smtx;

my $arcosa;
my $lastcomd = '';
my $handsize;

$handsize = 20;
if ( defined($arcosa->{'stng'}->{'handsize'}) )
{
  my $lc2_hs = int($arcosa->{'stng'}->{'handsize'} + 0.4);
  if ( $lc2_hs > 0.5 ) { $handsize = $lc2_hs; }
}

$arcosa = &me::longterm::load();

sub anotround {
  # Declearations:
  
  while ( $lastcomd eq 'h' ) { &get_me_help(); }
  
  if ( $lastcomd eq '' ) { return ( &make_a_question() > 5 ); }
  if ( $lastcomd eq 'save' ) { &me::longterm::save($arcosa); return(10 > 5); }
  if ( $lastcomd eq 'x' ) { return(0 > 5); }
  
  return(10 > 5);
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


while ( &anotround() ) { &enter_the_prompt(); }

sub enter_the_prompt {
  my $lc_prmp;
  
  $lc_prmp = "\n";
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'hand'});
  $lc_prmp .= ':';
  $lc_prmp .= &chobak_cstruc::counto($arcosa->{'deck'});
  $lc_prmp .= "[\"h\"/\"x\"/..] JUST [enter] TO CONTINUE:> ";
  
  system("echo","-n",$lc_prmp);
  $lastcomd = &chobak_io::inln;
}

sub decktohand {
  my $lc_a;
  my $lc_crt;
  $lc_a = &chobak_cstruc::counto($arcosa->{'hand'});
  if ( $lc_a > ( $handsize - 0.5 ) ) { return; }
  $lc_a = &chobak_cstruc::counto($arcosa->{'deck'});
  if ( $lc_a < ( 0.5 ) ) { return; }
  
  $lc_a = &chobak_cstruc::ry_hat($arcosa->{'deck'});
  $lc_crt = 1;
  if ( $lc_a->{'crit'} > 1 ) { $lc_crt = $lc_a->{'crit'}; }
  
  while ( $lc_crt > 0.5 )
  {
    &chobak_cstruc::ry_push($arcosa->{'hand'},$lc_a);
    $lc_crt = int($lc_crt - 0.8);
  }
}

sub make_a_question {
  my $lc_qus;
  
  &decktohand(); &decktohand();
  if ( &chobak_cstruc::counto($arcosa->{'hand'}) < 0.5 ) { return 0; }
  
  $lc_qus = &chobak_cstruc::ry_hat($arcosa->{'hand'});
  &chobak_cstruc::force_hash_has_hash($lc_qus,'score');
  if ( $lc_qus->{'typ'} eq 'smtx' ) { return &me::ask_smtx::prime($lc_qus,{
    'main' => $arcosa,
  }); }
  
  return 10;
}



&me::longterm::save($arcosa);





