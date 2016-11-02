use strict;
use me::pref_central;
use argola;
use chobak_flf;

my $mainobj;
my $maindat;
my $fcsobj;
my $sfcloc;


$mainobj = &me::pref_central::getobj();
$maindat = $mainobj->cont();

$fcsobj = &argola::getrg();
if ( !(-f $fcsobj) ) { die("\nNo such control file: " . $fcsobj . "\n\n"); }

$sfcloc = &chobak_flf::realpath($fcsobj);
$maindat->{'focus'} = $sfcloc;
$mainobj->save();


