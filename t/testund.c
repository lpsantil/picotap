#include <stdio.h>
#include <stdbool.h>
#include "tap.h"

int main( int argc, char** argv )
{
   plan( 3 );
   ok( 5 == 5, "5 equals 5" );
   ok( true, "Fail here because of missing test" );

   return( 0 );
}
