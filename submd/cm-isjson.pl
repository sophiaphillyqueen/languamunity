use strict;
use argola;
use wraprg;
use chobak_json;

my $the_file;
my $the_yes;
my $the_no;
my $ths_res;
my $cmdn;
my $cont;

$the_yes = '';
$the_no = '';

$the_file = &argola::getrg();
if ( &argola::yet() ) { $the_yes = &argola::getrg() . "\n"; }
if ( &argola::yet() ) { $the_no = &argola::getrg() . "\n"; }

$cmdn = "cat " . &wraprg::bsc($the_file);
$cont = `$cmdn`;
if ( &chobak_json::test($cont) )
{
  system("echo","-n",$the_yes);
  exit(0);
}
system("echo","-n",$the_no);
exit(4);



