use strict;
use me::longterm;
use argola;
use chobak_json;
use chobak_cstruc;
use me::extrac;
use me::core_take_cmd;

my $arcosa;
my $deckref;


$arcosa = &me::longterm::load();
&me::core_take_cmd::set_arcosa_var($arcosa);

$deckref = $arcosa->{'deck'};
while ( &argola::yet() )
{
  &me::core_take_cmd::one_round(&argola::getrg());
}



&me::longterm::save($arcosa);





