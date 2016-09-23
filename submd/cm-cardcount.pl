use strict;
use argola;
use wraprg;

my $argum;

while ( &argola::yet() )
{
  $argum = &argola::getrg();
  if ( -f $argum )
  {
    my $lc2_a;
    my $lc2_b;
    $lc2_a = "languamunity agri -f " . &wraprg::bsc($argum) . " -cnt";
    $lc2_b = `$lc2_a`; chomp($lc2_b);
    system("echo",(": " . $argum . " : " . $lc2_b . " :"));
  }
}





