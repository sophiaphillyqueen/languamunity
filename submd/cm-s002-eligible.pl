use strict;
# This command lists all lessons (by lesson ID-code) that are not
# currently on your lesson belt, but which are eligible to add
# the next time you add a lesson. (However - it does not assess
# whether or not you have been on the current level long enough
# to be eligible to do so).
#   The only argument this sub-command needs is the location of
# your control file.
use argola;
use chobak_json;
use chobak_jsonf;
use me::navig_index;
use chobinfodig;

my $arg_is_01; # The one argument - which specifies the control file
my $cntrpram; # Hash of parameters by which the control file is opened.
my $cntrobj; # File I/O control object for the control-file data
my $cntrd; # Data tree of the control-file.
my $index; # Data tree of the index file.
my $lesson_belt; # The belt of all so-far-added lessons
my $lesson_ctlg; # The catalogue of all lessons in the index file
my $lesson_rec; # The record of this individual lesson

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
$index = &chobak_json::readf($cntrd->{'indexfile'});

$lesson_belt = $cntrd->{'lcnon'};
$lesson_ctlg = $index->{'lcnx'};


#&chobinfodig::refxx('ZALKI',@$lesson_belt);
#&chobinfodig::refxx('BALKO',@$lesson_ctlg->{'id'});
foreach $lesson_rec (@$lesson_ctlg) { &atempto($lesson_rec); }
sub atempto {
  my $lc_lcnrec;
  my $lc_oldlcn;
  my $lc_ifc;
  $lc_lcnrec = $_[0];
  
  # We gots to make sure that this program does not output
  # the ID of any lesson already added:
  foreach $lc_oldlcn (@$lesson_belt)
  {
    if ( $lc_oldlcn eq $lc_lcnrec->{'id'} ) { return; }
  }
  
  # We also don't want to show anything who's prerequisites
  # are not met.
  $lc_ifc = {
    'index' => $index,
    'ctrol' => $cntrd,
    'prereq' => $lc_lcnrec->{'prereq'},
  };
  if ( !(&me::navig_index::lesson_allowed($lc_ifc)) ) { return; }
  
  
  system("echo",$lc_lcnrec->{'id'});
}