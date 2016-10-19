use strict;
use argola;
use chobak_jsonf;
use me::format_cntrol;
use chobinfodig;

my $cntrpram;
my $arg_is_01;
my $cntrobj;
my $cntrd;
my $exlist = [];
my $coollist;
my @neolist = ();

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

while ( &argola::yet() ) { @$exlist = (@$exlist,&argola::getrg()); }

$coollist = $cntrd->{'lcnon'};
{
  my $lc_a;
  foreach $lc_a (@$coollist) { &zandar($lc_a); }
}
sub zandar {
  my $lc_each;
  foreach $lc_each (@$exlist)
  {
    if ( $lc_each eq $_[0] ) { return; }
  }
  @neolist = (@neolist,$_[0]);
}

@$coollist = @neolist;

$cntrobj->save();




