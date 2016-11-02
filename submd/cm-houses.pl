use strict;
use argola;
use me::pref_central;

my $allhouses;


$allhouses = &me::pref_central::houses_alpb();

{
  my $lc_each;
  foreach $lc_each (@$allhouses)
  {
    &reporta($lc_each);
  }
}

sub reporta {
  system("echo",$_[0]);
}


