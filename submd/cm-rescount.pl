use strict;
use argola;
use chobak_json;
use me::extrac;

while ( &argola::yet() ) {
  my $lc_rg;
  $lc_rg = &argola::getrg();
  &tallyme($lc_rg);
}

sub tallyme {
  my $lc_rf;
  my @lc_rayo;
  my $lc_count;
  $lc_rf = &chobak_json::readf($_[0]);
  @lc_rayo = &me::extrac::hashfrom($lc_rf,
    {
      'typ' => ['name','keysub'],
    }
  );
  $lc_count = @lc_rayo;
  
  system("echo",(': ' . $_[0] . ' : ' . $lc_count . ' :'));
}



