use strict;
# This command is very simple. All it does is output the
# full list of code-names of lessons on your belt - from
# the earliest last-added to the latest last-added.
# It does so in that order - without respect to whether
# or not the lessons are currently eligible to re-add.
use argola;
use chobak_jsonf;


my $cntrpram;
my $arg_is_01;
my $cntrobj;
my $cntrd;

# Here comes the litany by which the control file and then
# the index file are opened.
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

{
  my $lc_a;
  my $lc_b;
  $lc_a = $cntrd->{'lcnon'};
  foreach $lc_b (@$lc_a)
  {
    &atryit($lc_b);
  }
}

sub atryit {
  my $lc_rg;
  my $lc_tp;
  
  $lc_rg = $_[0];
  $lc_tp = ref($lc_rg);
  
  if ( $lc_tp eq '' )
  {
    system("echo",$lc_rg);
    return;
  }
}



