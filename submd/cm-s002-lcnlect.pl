use strict;
use argola;
use chobak_json;
use chobak_jsonf;
use me::format_cntrol;
use chobinfodig;

my $cntrpram;
my $arg_is_01;
my $cntrobj;
my $cntrd;
my $index;

$cntrpram = {
  'rtyp' => 'h',
  'create' => 'no',
};

$arg_is_01 = &argola::getrg();
if ( ! ( &chobak_jsonf::byref($arg_is_01,$cntrobj,$cntrpram) ) )
{
  die("\nFailed to open the file: " . $arg_is_01 . ":\n\n");
}
$cntrd = $cntrobj->cont();
&me::format_cntrol::struct_the_ref($cntrd);
$index = &chobak_json::readf($cntrd->{'indexfile'});

sub opto__idcd_do {
  my $lc_a;
  $lc_a = &argola::getrg();
  &show_lesson_for_lit($lc_a);
} &argola::setopt('-idcd',\&opto__idcd_do);

argola::runopts();


sub show_lesson_for_lit {
  
}




