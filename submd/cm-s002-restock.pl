use strict;
use argola;
use chobak_jsonf;
use chobak_json;
use me::longterm;
use File::Basename;
use Cwd qw(realpath);

use chobinfodig;

my $desired_quiz_size = 400;

my $cntrpram; # Parameters for opening the control file
my $cntrobj; # Control object for the control-file data
my $cntrd; # Hash of the control-file data

my $index; # The contents of the index file
my $quizfile; # The local-FS name of the quiz-file
my $lcnhash; # The hashed-by-lesson form of the index of lessons

my $critdir; # The directory of languamunity's local-to-account data
my $scratdir; # The scratchpad directory

my $lcnlist; # The list of lessons - the current belt
my $anitem; # The tracer variable for going through arrays
my @used_resd = ();



# First the litany that loads the Control File and the Index
# File - as well as identifies the locations of both those plus
# the Quizfile
$cntrpram = {
  'rtyp' => 'h',
  'create' => 'no',
};
if ( ! ( &chobak_jsonf::byref(&argola::getrg(),$cntrobj,$cntrpram) ) )
{
  die "\nFailed to open the file\n\n";
}
$cntrd = $cntrobj->cont();
$index = &chobak_json::readf($cntrd->{'indexfile'});
$quizfile = $cntrd->{'quizfile'};
if ( $quizfile eq '' ) { die "\nNo quiz-file specified:\n\n"; }


# And we gots to know where the scratch directory is
$critdir = &me::longterm::get_crit_d();
$scratdir = ( $critdir . '/restock-scratch' );

# Find the belt of lessons
$lcnlist = $cntrd->{'lcnon'};

# Now we will go and make a hashed form of the lessons in
# the index file.
$lcnhash = {};
{
  my $lc_a;
  my $lc_b;
  
  $lc_a = $index->{'lcnx'};
  foreach $lc_b (@$lc_a)
  {
    $lcnhash->{$lc_b->{'id'}} = $lc_b;
  }
}


# Now - before we find the new sources of names, let us
# purge previous names from the quiz-file
system("languamunity","clear-names",'-f',$quizfile);

# And we will now go through the list of lessons in the
# belt - and re-add the names to the quiz-file
foreach $anitem (@$lcnlist)
{
  my $lc_reco;
  my $lc_txres;
  my $lc_item;
  $lc_reco = $lcnhash->{$anitem};
  if ( ref($lc_reco) ne 'HASH' ) { $lc_reco = {}; }
  $lc_txres = $lc_reco->{'resrc'};
  if ( ref($lc_txres) ne 'ARRAY' ) { $lc_txres = []; }
  foreach $lc_item (@$lc_txres)
  {
    &add_the_res($lc_item);
  }
}
sub add_the_res {
  my $lc_item;
  my $lc_shorto;
  my $lc_fullo;
  foreach $lc_item (@used_resd)
  {
    if ( $lc_item eq $_[0] ) { return; }
  }
  
  $lc_shorto = $_[0];
  if ( substr($lc_shorto,0,1) ne '/' )
  {
    my @lc2_a;
    @lc2_a = fileparse($cntrd->{'indexfile'});
    $lc_shorto = $lc2_a[1] . $lc_shorto;
  }
  if ( !(-f $lc_shorto) ) { return; }
  $lc_fullo = realpath($lc_shorto);
  if ( !(-f $lc_fullo) ) { return; }
  
  # Add the item to the list of already-used resource files -
  # so as to avoid redundancies
  @used_resd = (@used_resd,$_[0]);
  system("languamunity","qsp-take",'-to',$quizfile,'-in',$lc_fullo);
}


&chobinfodig::dumpy('COOLBEANS',$lcnhash);



