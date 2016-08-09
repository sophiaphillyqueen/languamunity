use strict;
use me::longterm;
use chobak_cstruc;

my $arcosa;
$arcosa = &me::longterm::load();

#system("echo",&chobak_json::tojson($arcosa));
system("echo","hand=" . &chobak_cstruc::counto($arcosa->{'hand'}));
system("echo","deck=" . &chobak_cstruc::counto($arcosa->{'deck'}));






