use strict;
use me::pref_central;
use argola;


my $mainobj;
my $maindat;
my @cmdon;


$mainobj = &me::pref_central::getobj();
$maindat = $mainobj->cont();


if ( !defined($maindat->{'focus'}) )
{
  die("\nFATAL ERROR: No Langamunity control-file in focus.\n\n");
}
if ( !(&argola::yet()) )
{
  die("\n"
      . "FATAL ERROR: This G3 command requires a G2 command as its\n"
      . "    first argument ...... followed by all arguments that\n"
      . "    subsequently would be passed to that G2 command.\n"
  . "\n");
}

@cmdon = ("languamunity001",&argola::getrg(),$maindat->{'focus'});
while ( &argola::yet() )
{
  @cmdon = (@cmdon,&argola::getrg());
}



exec(@cmdon);





