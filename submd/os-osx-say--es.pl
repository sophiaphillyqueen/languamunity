use strict;
use argola;

my $vario_gselc;
my $vario_chosen;
my $vario_csid;
my $end_voice;
my $ratego;

$ratego = 180;

my $vario_voxs = ['Juan','Angelica'];

$vario_gselc = &argola::getrg();
if ( !(&argola::yet()) ) { exit(0); }

sub zoomify {
  $vario_chosen = 0;
  if ( $vario_gselc eq 'm' ) { $vario_csid = 0; $vario_chosen = 10; }
  if ( $vario_gselc eq 'f' ) { $vario_csid = 1; $vario_chosen = 10; }
  if ( $vario_chosen < 5 ) { $vario_csid = ((int(rand(80))) % 2); }
  $end_voice = $vario_voxs->[$vario_csid];
}
if ( $vario_gselc eq 'r1' ) { &zoomify(); }


#while ( &argola::yet() )
#{
sub opto__tx_do {
  my $lc_cont;
  if ( $vario_gselc ne 'r1' ) { &zoomify(); }
  $lc_cont = &argola::getrg();
  system("say","-v",$end_voice,"-r",$ratego,(' ' . $lc_cont));
} &argola::setopt('-tx',\&opto__tx_do);
#}

&argola::runopts();

