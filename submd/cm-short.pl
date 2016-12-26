use strict;
use argola;

my @cmdo;

@cmdo = ("languamunity001","resume");
while ( &argola::yet() )
{
  @cmdo = (@cmdo,&argola::getrg());
}

exec(@cmdo);

