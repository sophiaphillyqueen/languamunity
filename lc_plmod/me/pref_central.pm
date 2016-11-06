package me::pref_central;
use strict;
use chobak_jsonf;
use me::format_central;
use chobak_cstruc;
use wraprg;


# Has this module been initialized yet?
my $beeninit = 0;


# The location of the central directory:
my $cntrdir;

# The location of the central file-referemce:
my $cntrfloc;

# Location of the main object module:
my $cntrobj;


sub getobj {
  &initthis();
  return $cntrobj;
}

sub getdat {
  &initthis();
  return($cntrobj->cont());
}


sub initthis {
  my $lc_cntrpram;
  my $lc_data;
  
  # Let us not run this function twice:
  if ( $beeninit > 5 ) { $beeninit = 10; return(2>1); }
  # Yes - in the first draft of this module this was all
  # done in extrafunctional space --- but it was moved
  # into a function that only does anything the first
  # time it is invoked so that a failure would not
  # interfere with the compilation of the full PERL
  # program.
  $beeninit = 10;
  # This last line to prevent infinite recursive-function
  # loop in case this function is called from one of the
  # functions that it itself calls.
  
  # First - we identify where the central directory is
  $cntrdir = $ENV{'HOME'};
  if ( $cntrdir eq '' )
  {
    $cntrdir = `echo ~`; chomp($cntrdir);
  }
  $cntrdir .= '/.chobakwrap/languamunity';
  system("mkdir","-p",$cntrdir);
  
  # Then - we identify where the central file is
  $cntrfloc = $cntrdir . '/central-pref.ref';
  
  # Setting up the main pref file:
  $lc_cntrpram = {
    'rtyp' => 'h',
    'create' => 'yes',
  };
  if ( ! ( &chobak_jsonf::byref($cntrfloc,$cntrobj,$lc_cntrpram) ) )
  {
    die "\nFailed to open the central preference file\n\n";
  }
  
  $lc_data = $cntrobj->cont();
  &me::format_central::struct_the_ref($lc_data);
  
  $beeninit = 10; return(2>1);
}


sub houselist {
  my $lc_ref;
  
  &initthis();
  $lc_ref = $cntrobj->cont();
  return &chobak_cstruc::keyref($lc_ref->{'houses'});
}

sub houses_alpb {
  my $lc_a;
  my @lc_b;
  my @lc_c;
  
  $lc_a = &houselist();
  @lc_b = @$lc_a;
  @lc_c = sort { lc($a) cmp lc($b) } @lc_b;
  $lc_a = [@lc_c];
  return $lc_a;
}

sub house_name_ok {
  my $lc_loc;
  my $lc_chr;
  my $lc_nchr;
  my $lc_ok;
  $lc_loc = $_[0];
  
  if ( $lc_loc eq '' ) { return(1>2); }
  
  while ( $lc_loc ne '' )
  {
    $lc_chr = chop($lc_loc);
    $lc_nchr = ord($lc_chr);
    $lc_ok = 0;
    
    if ( ( $lc_nchr > (ord('a') - 0.5) ) && ( $lc_nchr < (ord('z') + 0.5) ) ) { $lc_ok = 10; }
    if ( ( $lc_nchr > (ord('0') - 0.5) ) && ( $lc_nchr < (ord('9') + 0.5) ) ) { $lc_ok = 10; }
    
    if ( $lc_ok < 5 ) { return(1>2); }
  }
  return(2>1);
}

sub full_housekeeping {
  my $lc_all;
  my $lc_each;
  
  $lc_all = &houselist();
  foreach $lc_each (@$lc_all)
  {
    &inspect_house($lc_each);
  }
  $cntrobj->save();
}

sub inspect_house {
  my $lc_dat;
  my $lc_house;
  &initthis();
  
  $lc_dat = $cntrobj->cont();
  if ( !defined($lc_dat->{'houses'}->{$_[0]}) ) { return; }
  $lc_house = $lc_dat->{'houses'}->{$_[0]};
  
  if ( $lc_house->{'mode'} eq 'clear' )
  {
    &clear_house($_[0],$lc_house);
    $cntrobj->save();
    return;
  }
  
  if ( $lc_house->{'mode'} eq 'reset' )
  {
    &reset_house($_[0],$lc_house);
    $cntrobj->save();
    return;
  }
}

sub house_loc {
  &initthis();
  return($cntrdir . '/house-' . $_[0]);
}

sub clear_house {
  my $lc_ldir;
  my $lc_dat;
  $lc_ldir = &house_loc($_[0]);
  system("rm","-rf",$lc_ldir);
  if ( -d $lc_ldir ) { return; }
  if ( -f $lc_ldir ) { return; }
  $lc_dat = $cntrobj->cont();
  delete $lc_dat->{'houses'}->{$_[0]};
  $cntrobj->save();
}

sub reset_house {
  my $lc_ldir;
  my $lc_ok;
  $lc_ldir = &house_loc($_[0]);
  system("rm","-rf",$lc_ldir);
  system("mkdir","-p",$lc_ldir);
  $lc_ok = 0;
  
  if ( $_[1]->{'srctyp'} eq 'git' )
  {
    system("git","clone",$_[1]->{'srcloc'},($lc_ldir . "/course"));
    $lc_ok = 10;
  }
  
  system("languamunity","s002-setng",($lc_ldir . "/ctrol.ref")
    ,'-indexfile',($lc_ldir . "/course/index.json")
    ,'-quizfile',($lc_ldir . "/quizfile.json")
    ,'-method','git'
  );
  
  system("languamunity","s003-focus",($lc_ldir . "/ctrol.ref"));
  $cntrobj->refresh();
  
  #$_[1]->{'mode'} = 'ok';
  &enforce_house_ok($_[0]);
}

sub enforce_house_ok {
  my $lc_a = $cntrobj->cont();
  $lc_a->{'houses'}->{$_[0]}->{'mode'} = 'ok';
  $cntrobj->save();
}


1;
