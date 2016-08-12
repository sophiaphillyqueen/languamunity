use strict;
use argola;

my @cmdo;

@cmdo = ("languamunity","resume");
while ( &argola::yet() )
{
  @cmdo = (@cmdo,&argola::getrg());
}

exec(@cmdo);

