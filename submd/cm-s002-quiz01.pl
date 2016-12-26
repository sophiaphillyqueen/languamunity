use strict;
# This command initiates a timed quiz.
use argola;
use chobak_jsonf;
use me::navig_index;
use me::scoring;

my $cntrpram;
my $cntrobj;
my $cntrd;
my $quizfile;
my $newrounds;
my $dam_set = 0;
my $dam_size;
my @quizcm;

$cntrpram = {
  'rtyp' => 'h',
  'create' => 'no',
};

if ( ! ( &chobak_jsonf::byref(&argola::getrg(),$cntrobj,$cntrpram) ) )
{
  die "\nFailed to open the file\n\n";
}
$cntrd = $cntrobj->cont();
$quizfile = $cntrd->{'quizfile'};
if ( $quizfile eq '' )
{
  die "\nFATAL ERROR: No quizfile assigned:\n\n";
}

sub opto__dam__do {
  $dam_size = &argola::getrg();
  $dam_set = 10;
} &argola::setopt('-dam',\&opto__dam__do);

&argola::runopts();


system("languamunity001","s002-restock",$cntrobj->reffile());

# Now we see how this effects our level
$cntrd = $cntrobj->refresh();
$newrounds = $cntrd->{'rounds-last-restock'};
while ( $newrounds > 0.5 )
{
  my $lc_a;
  my $lc_b;
  $lc_a = $cntrd->{'explevel'};
  $lc_b = &me::scoring::increment($lc_a);
  $cntrd->{'explevel'} = $lc_b;
  $newrounds = int($newrounds - 0.8);
}
$cntrobj->save();


@quizcm = ("languamunity001","resume","-quizfile",$quizfile,"-time",5,0);
if ( $dam_set > 5 ) { @quizcm = (@quizcm,"-dam",$dam_size); }
exec(@quizcm);




