use strict;
use me::longterm;
use argola;
use chobak_json;
use me::extrac;

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
    @$deckref = (@$deckref,&me::extrac::hashfrom($eachfcon,{
      'typ' => ['smtx'],
    }));
  }
}


&me::longterm::save($arcosa);





