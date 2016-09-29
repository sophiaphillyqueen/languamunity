use strict;
use me::longterm;
use me::tally_basics;
use chobak_cstruc;
use argola;

my $arcosa;

$arcosa = &me::longterm::load();

while ( &argola::yet() ) { &zonto(&argola::getrg()); }
sub zonto {
  my $lc_rg;
  my $lc_clc;
  my $lc_neo;
  
  $lc_rg = $_[0];
  
  if ( $lc_rg eq '-f' )
  {
    $arcosa = &me::longterm::load_quiz_file(&argola::getrg());
    return;
  }
  
  if ( $lc_rg eq 'deck' )
  {
    system("echo",&me::tally_basics::complete_deck($arcosa));
    return;
  }
  
  if ( $lc_rg eq 'hand' )
  {
    system("echo",&me::tally_basics::complete_hand($arcosa));
    return;
  }
  
  if ( $lc_rg eq 'deck+hand' )
  {
    $lc_clc = &me::tally_basics::complete_deck($arcosa);
    $lc_neo = &me::tally_basics::complete_hand($arcosa);
    $lc_clc = int($lc_clc + $lc_neo + 0.2);
    system("echo",$lc_clc);
    return;
  }
  
  if ( $lc_rg eq 'unasked' )
  {
    $lc_clc = &chobak_cstruc::counto($arcosa->{'deck'});
    $lc_neo = &chobak_cstruc::counto($arcosa->{'hand'});
    $lc_clc = int($lc_clc + $lc_neo + 0.2);
    system("echo",$lc_clc);
    return;
  }
  
  die "\nNo such stat: '" . $lc_rg . "':\n\n";
}

