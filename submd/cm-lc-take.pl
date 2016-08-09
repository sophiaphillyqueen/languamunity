use strict;
use me::longterm;
use argola;
use chobak_json;

my $arcosa;
my $deckref;
my $eachfile;
my $eachfcon;


$arcosa = &me::longterm::load();

$deckref = $arcosa->{'deck'};
while ( &argola::yet() )
{
  $eachfile = &argola::getrg();
  $eachfcon = &chobak_json::readf($eachfile);
  if ( ref($eachfcon) eq 'ARRAY' )
  {
    @$deckref = (@$deckref,@$eachfcon);
  }
}


&me::longterm::save($arcosa);





