package me::content_update;
use strict;
use wraprg;

use chobinfodig;

sub prima {
  my $this;
  my $lc_dat;
  my $lc_mth;
  $this = $_[0];
  
  $lc_dat = $this->cont();
  if ( !defined($lc_dat->{'method'}) ) { return(2>1); }
  $lc_mth = $lc_dat->{'method'};
  
  if ( $lc_mth eq 'git' ) { return &do_by_git($this); }
  
  return(1>2);
}


sub do_by_git {
  my $this;
  my $lc_dat;
  my $lc_cm;
  my $lc_dataloc;
  my $lc_gitbrnc;
  $this = $_[0];
  
  $lc_dat = $this->cont();
  
  if ( !defined($lc_dat->{'indexfile'}) ) { return(2>1); }
  if ( !defined($lc_dat->{'quizfile'}) ) { return(2>1); }
  
  # First, we get the directory where the index file is located.
  $lc_cm = "dirname " . &wraprg::bsc($lc_dat->{'indexfile'});
  $lc_dataloc = `$lc_cm`; chomp($lc_dataloc);
  
  # Now we find out what branch the GIT repo is on.
  $lc_cm = "( cd " . &wraprg::bsc($lc_dataloc);
  $lc_cm .= " && git rev-parse --abbrev-ref HEAD )";
  $lc_gitbrnc = `$lc_cm`; chomp($lc_gitbrnc);
  if ( $lc_gitbrnc eq '' ) { return(2>1); }
  
  # We now update the contents of the branch from 'origin'.
  $lc_cm = "( cd " . &wraprg::bsc($lc_dataloc) . ' && ';
  $lc_cm .= ' git pull origin ';
  $lc_cm .= &wraprg::bsc($lc_gitbrnc);
  $lc_cm .= ' )';
  system($lc_cm);
  
  # Finally - we clear the quiz-file contents and do a restock
  # of the quizfile.
  
  $lc_cm = 'languamunity clear-quiz -f ' . &wraprg::bsc($lc_dat->{'quizfile'});
  system($lc_cm);
  system("languamunity","s002-restock",$this->reffile());
  
  $lc_cm = 'languamunity clear-quiz -f ' . &wraprg::bsc($lc_dat->{'quizfile'});
  system($lc_cm);
  system("languamunity","s002-restock",$this->reffile());
  
  $lc_cm = 'languamunity clear-quiz -f ' . &wraprg::bsc($lc_dat->{'quizfile'});
  $lc_cm .= ' -pmiss';
  system($lc_cm);
  system("languamunity","s002-restock",$this->reffile());
  
  $lc_cm = 'languamunity clear-quiz -f ' . &wraprg::bsc($lc_dat->{'quizfile'});
  $lc_cm .= ' -pmiss';
  system($lc_cm);
  system("languamunity","s002-restock",$this->reffile());
  
  system("echo","\n\nCONTENT UPDATE COMPLETED\n\n");
  
  return(1>2);
}



1;
