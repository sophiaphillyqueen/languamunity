package me::head_elsewhere;
use strict;


sub haltquiz {
  my $lc_a;
  system("clear");
  &zarmsg(
    "Okay -- you have clarified",
    "that your mind is elsewhere now.",
    "You will therefore exit this quiz",
    "without saving.",
    "Any progress you just made",
    "along with any misses",
    "will be forgotten",
    "that next time you return",
    "it will be as though this round",
    "never happened.",
    "",
    "So go and do whatever you must",
    "to refresh your mind",
    "so that it can properly focus -",
    "and then return here to attempt",
    "another round at learning.",
  '');
  $lc_a = `date`; chomp($lc_a);
  &zarmsg(("The moment is: " . $lc_a),'');
  exit(0);
}

sub zarmsg {
  my $lc_each;
  foreach $lc_each (@_)
  {
    system("echo",(': ' . $lc_each . ' :'));
    sleep(1);
  }
}


1;
