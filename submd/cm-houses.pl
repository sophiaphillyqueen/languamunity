use strict;
use argola;
use me::pref_central;

my $allhouses;
my $show_method = 0;
my $show_locat = 0;
my $datasrc;

sub opto__v_do {
  $show_method = 10;
  $show_locat = 10;
} &argola::setopt('-v',\&opto__v_do);

&argola::runopts();


$datasrc = &me::pref_central::getdat();


$allhouses = &me::pref_central::houses_alpb();

{
  my $lc_each;
  foreach $lc_each (@$allhouses)
  {
    &reporta($lc_each);
  }
}

sub reporta {
  my $lc_disp;
  my $lc_srctyp;
  
  $lc_srctyp = $datasrc->{'houses'}->{$_[0]}->{'srctyp'};
  
  $lc_disp = $_[0];
  if ( $show_method > 5 )
  {
    $lc_disp .= ' ' . $lc_srctyp;
  }
  
  if ( $show_locat > 5 )
  {
    if ( $lc_srctyp eq 'git' ) { $lc_disp .= ' ' . $datasrc->{'houses'}->{$_[0]}->{'srcloc'}; }
  }
  
  system("echo",$lc_disp);
}


