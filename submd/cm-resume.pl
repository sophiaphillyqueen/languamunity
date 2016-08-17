use strict;
use me::longterm;
use me::core_quiz_cmd;

my $arcosa;

$arcosa = &me::longterm::load();



&me::core_quiz_cmd::set_arcosa_var($arcosa);



while ( &me::core_quiz_cmd::anotround() ) { &me::core_quiz_cmd::enter_the_prompt(); }

system("clear");
&me::longterm::save($arcosa);





