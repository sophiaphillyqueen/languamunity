#! /usr/bin/perl
use strict;
# This program is invoked to update the contents of a
# local copy of a course. It does so in two basic steps
# (1) it switches on the low-level-settings flag to
# do the update and (2) it then calls the function to
# process all such do-this-task-now settings. That
# function will itself switch the flag back off in
# the event of successful completion. (And if the
# program is interrupted before the update is complete,
# then the update will be attempted again automatically
# the next time a command that calls that function is
# invoked.)
use chobak_jsonf;
use argola;
use me::format_cntrol;
use me::chores_on_ctrl;

my $cntrpram;
my $cntrobj;
my $cntrd;

$cntrpram = {
  'rtyp' => 'h',
  'create' => 'no',
};

if ( ! ( &chobak_jsonf::byref(&argola::getrg(),$cntrobj,$cntrpram) ) )
{
  die "\nFailed to open the file\n\n";
}
$cntrd = $cntrobj->cont();
&me::format_cntrol::struct_the_ref($cntrd);


# First we flip the switch ----
$cntrd->{'llstng'}->{'on-content-update'} = 10;
$cntrobj->save();

# And now we run the function:
$cntrd = &me::chores_on_ctrl::pending($cntrobj);






