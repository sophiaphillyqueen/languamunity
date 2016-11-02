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

$crucdat->{'houses'}->{$pickname}->{'mode'} = 'reset';

$crucobj->save();

&me::pref_central::full_housekeeping();



