use strict;
use argola;
use me::pref_central;

my $pickname;
my $pickurl;
my $crucobj;
my $crucdat;

$pickname = &argola::getrg();
$pickurl = &argola::getrg();


$crucobj = &me::pref_central::getobj();
$crucdat = $crucobj->cont();
if ( !defined($crucdat->{'houses'}->{$pickname}) )
{
  die("\nHouse Name \"" . $pickname . "\" Not Found:\n\n");
}

&me::pref_central::full_housekeeping();

exec("languamunity","s003-focus",(&me::pref_central::house_loc($pickname) . '/ctrol.ref'));




sub DEBUG_venter {
  system("edit -w ~/.chobakwrap/languamunity/central-pref*.json");
}

