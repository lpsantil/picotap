#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "tap.h"

int main( int argc, char** argv )
{
   plan( 2 );
   ok( 5 == 5, "5 equals 5" );
   printf( "Fail me because of bad input to tap!\n" );
   ok( true, "Fail here because of missing test" );

   return( 0 );
}
