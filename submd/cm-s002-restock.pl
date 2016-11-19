use strict;
use argola;
use wraprg;
use chobak_jsonf;
use chobak_json;
use chobak_routines;
use me::longterm;
use me::valus;
use File::Basename;
use Cwd qw(realpath);
use me::vrsflow;

use chobinfodig;

#my $desired_quiz_size = 400;
my $rt_max_questions;
my $max_questions;

my $control_file; # The control-file as obtained from command-line:

my $cntrpram; # Parameters for opening the control file
my $cntrobj; # Control object for the control-file data
my $cntrd; # Hash of the control-file data

my $index; # The contents of the index file
my $quizfile; # The local-FS name of the quiz-file
my $lcnhash; # The hashed-by-lesson form of the index of lessons

my $critdir; # The directory of languamunity's local-to-account data
my $scratdir; # The scratchpad directory
my $scratfile; # A JSON file within the scratch directory

my $lcnlist; # The list of lessons - the current belt
my $anitem; # The tracer variable for going through arrays
my @used_resd = ();

my $countor = 0; # How many rounds of material have been added so far?

# SHRINKAGE VARIAGLES:
my $shrink_not_too_much_again;
my $shrink_new_lesson_code;
my $shrink_pro_max;
my $shrink_pro_count;

# Some variables are initiated from the 'me::valus' module:
$rt_max_questions = &me::valus::look('min-unasked-cards');

# Some variables are initialized based on others:
$max_questions = $rt_max_questions;

# Now let us deal with the command line:
$control_file = &argola::getrg();

sub opto__mj_do {
  my $lc_upgr;
  my $lc_max;
  
  $lc_max = 10;
  $lc_upgr = &argola::getrg();
  $lc_upgr = ((int((10 * $lc_upgr) + 0.45)) / 10);
  if ( $lc_upgr < 1 ) { $lc_upgr = 1; }
  if ( $lc_upgr > $lc_max ) { $lc_upgr = $lc_max; }
  $max_questions = int(($rt_max_questions * $lc_upgr) + 0.2);
} &argola::setopt('-mj',\&opto__mj_do);

sub opto__bk_do {
  my $lc_upgr;
  my $lc_max;
  
  $lc_max = int(($rt_max_questions * 9) + 0.2);
  $lc_upgr = &argola::getrg();
  $lc_upgr = int($lc_upgr + 0.45);
  if ( $lc_upgr < 0 ) { $lc_upgr = 0; }
  if ( $lc_upgr > $lc_max ) { $lc_upgr = $lc_max; }
  $max_questions = int($rt_max_questions + $lc_upgr + 0.2);
} &argola::setopt('-bk',\&opto__bk_do);

sub opto__major_do {
  $max_questions = int(($rt_max_questions * 10) + 0.2);
} &argola::setopt('-major',\&opto__major_do);

&argola::runopts();


# First the litany that loads the Control File and the Index
# File - as well as identifies the locations of both those plus
# the Quizfile
$cntrpram = {
  'rtyp' => 'h',
  'create' => 'no',
};
if ( ! ( &chobak_jsonf::byref($control_file,$cntrobj,$cntrpram) ) )
{
  die "\nFailed to open the file\n\n";
}
$cntrd = $cntrobj->cont();
$index = &chobak_json::readf($cntrd->{'indexfile'});
$quizfile = $cntrd->{'quizfile'};
if ( $quizfile eq '' ) { die "\nNo quiz-file specified:\n\n"; }


&me::vrsflow::do_replace($index,$cntrd);
$cntrobj->save();

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
sub relativo {
  my @lc_a;
  my $lc_b;
  if ( substr($_[0],0,1) eq '/' ) { return $_[0]; }
  @lc_a = fileparse($_[1]);
  $lc_b = ( $lc_a[1] . $_[0] );
  return $lc_b;
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
  
  $lc_shorto = &relativo($lc_shorto,$cntrd->{'indexfile'});
  
  if ( !(-f $lc_shorto) ) { return; }
  $lc_fullo = realpath($lc_shorto);
  if ( !(-f $lc_fullo) ) { return; }
  
  # Add the item to the list of already-used resource files -
  # so as to avoid redundancies
  @used_resd = (@used_resd,$_[0]);
  system("languamunity","qsp-take",'-to',$quizfile,'-in',$lc_fullo);
}
sub howmany {
  my $lc_cm;
  my $lc_rt;
  $lc_cm = "languamunity statlli -f " . &wraprg::bsc($quizfile) . " unasked";
  $lc_rt = `$lc_cm`;
  chomp($lc_rt);
  return $lc_rt;
}

# The following function is a filter that allows the new representation of
# a file (a hash that specifies file-location and symbolic file-id) while
# also supporting backwards compatibility with the old form that treats
# it as just a scalar.
sub extrac_f_loc {
  my $lc_rg;
  $lc_rg = $_[0];
  if ( ref($lc_rg) eq 'HASH' ) { return $lc_rg->{'f'}; }
  return $lc_rg;
}

while ( ( &howmany() < $max_questions ) && ( $countor < $max_questions ) )
{
  my $lc_lcn_tag;
  $countor = int($countor + 1.2);
  system("echo",('Restock Round ' . $countor . ':'));
  
  system('rm','-rf',$scratdir);
  system('mkdir',$scratdir);
  $scratfile = $scratdir . '/holding.json';
  &reset_shrinkage_global_vars();
  foreach $lc_lcn_tag (@$lcnlist) { &agri_one_lesson($lc_lcn_tag); }
  system("languamunity",'qsp-take','-to',$quizfile,'-in',$scratfile);
}

sub reset_shrinkage_global_vars {
  $shrink_not_too_much_again = 0;
  $shrink_pro_max = 2;
  $shrink_pro_count = 0;
}


sub time_to_shrink
{
  system('languamunity','agri','-ft',$scratfile,'-lm',&me::valus::look('max-deck-postshort'));
}

sub agri_one_lesson {
  my $lc_lcn_rec;
  my $lc_file_array;
  my $lc_file_item;
  my $lc_file_location;
  
  $shrink_new_lesson_code = $_[0];
  
  
  &time_to_shrink();
  system("echo",("Adding content for lesson: " . $shrink_new_lesson_code . ":"));
  
  $lc_lcn_rec = $lcnhash->{$_[0]};
  if ( ref($lc_lcn_rec) ne 'HASH' ) { return; }
  $lc_file_array = $lc_lcn_rec->{'txtres'};
  if ( ref($lc_file_array) ne 'ARRAY' ) { return; }
  
  foreach $lc_file_item (@$lc_file_array)
  {
    $lc_file_location = &relativo(&extrac_f_loc($lc_file_item),$cntrd->{'indexfile'});
    system("languamunity",'agri','-ft',$scratfile,'-f',$lc_file_location);
  }
}


# Other higher-level commands that do leveling may need to know
# now many rounds this took:
$cntrd = $cntrobj->refresh();
$cntrd->{'rounds-last-restock'} = $countor;
$cntrobj->save();
#&chobinfodig::dumpy('COOLBEANS',$lcnhash);



