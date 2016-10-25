use strict;
# This command adds a lesson to the belt - and does so without regard
# to whether or not that is legal. (It is higher-level commands that
# will provide deference to such matters.) All this command verifies
# is that the lesson in question in fact exists.
use argola;
use chobak_jsonf;
use me::navig_index;
use me::scoring;
use me::format_cntrol;

my $cntrobj;
my $cntrpram;
my $cntrd;
my $index;
my $lessongoal;
my $lessonrec;
my $quizfile;
my $iface;
my $arg_is_01;

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

&me::navig_index::mem_index($index);

$lessongoal = &argola::getrg();
if ( !(&me::navig_index::find_the_lesson($lessonrec,$index,$lessongoal)) )
{
  die("\nFATAL ERROR: No such lesson: " . $lessongoal . ":\n\n");
}


# On second thought - we do care if the lesson is allowed.
$iface = {
  'index' => $index,
  'ctrol' => $cntrd,
  'prereq' => $lessonrec->{'prereq'},
};
if ( !(&me::navig_index::lesson_allowed($iface)) )
{
  die "\nFATAL ERROR: Not yet permitted to add: " . $lessongoal . ":\n\n";
}


{
  my $lc_olist;
  my @lc_nlist;
  my $lc_itm;
  
  $lc_olist = $cntrd->{'lcnon'};
  @lc_nlist = ();
  foreach $lc_itm (@$lc_olist)
  {
    if ( $lc_itm ne $lessongoal )
    {
      @lc_nlist = (@lc_nlist,$lc_itm);
    }
  }
  @lc_nlist = (@lc_nlist,$lessongoal);
  $cntrd->{'lcnon'} = [@lc_nlist];
}

# Make sure the scoring starts from the default spot
$cntrd->{'explevel'} = &me::scoring::new_raw_score();

$cntrobj->save();
$quizfile = $cntrd->{'quizfile'};
if ( $quizfile ne '' )
{
  system("languamunity","clear-quiz","-f",$quizfile,"-pmiss");
  system("languamunity","s002-restock",$cntrobj->reffile());
}

system("echo",("ADDED LESSON: " . $lessongoal));





