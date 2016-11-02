use strict;
use argola;
use me::pref_central;

my $pickname;
my $pickurl;
my $crucobj;
my $crucdat;

$pickname = &argola::getrg();
$pickurl = &argola::getrg();

if ( !(&me::pref_central::house_name_ok($pickname)) )
{
  die("\nInvalid House Name: \"" . $pickname . "\":\n\n");
}

$crucobj = &me::pref_central::getobj();
$crucdat = $crucobj->cont();
if ( defined($crucdat->{'houses'}->{$pickname}) )
{
  die("\nHouse Name \"" . $pickname . "\" Already in Use:\n\n");
}

$crucdat->{'houses'}->{$pickname} = {
  'srctyp' => 'git',
  'srcloc' => $pickurl,
  'mode' => 'reset',
};

$crucobj->save();

&me::pref_central::full_housekeeping();



