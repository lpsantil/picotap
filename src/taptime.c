/*
 * Copyright (c) 2013, 2014, Louis P. Santillan <lpsantil@gmail.com>
 * All rights reserved.
 */

#include "taptime.h"

#ifdef __WATCOMC__
#include <sys/timeb.h>

/* <= POSIX 2001 */
int time_sub( TAP_time *result,
              TAP_time *x,
              TAP_time *y )
{
   long rt;
   rt = ( x->time * 1000 + x->millitm ) -
        ( y->time * 1000 + y->millitm );

   result->millitm = rt % 1000;
   result->time    = rt / 1000;

   /* Return 1 if result is negative. */
   return( rt < 0 );
}

#else
#include <sys/types.h>
#include <sys/time.h>

/* >= POSIX 2008 */
int time_sub( TAP_time *result,
              TAP_time *x,
              TAP_time *y )
{
   /* Perform the carry for the later subtraction by updating y. */
   if( x->tv_usec < y->tv_usec )
   {
      int nsec = ( y->tv_usec - x->tv_usec ) / 1000000 + 1;
      y->tv_usec -= 1000000 * nsec;
      y->tv_sec += nsec;
   }
   if( x->tv_usec - y->tv_usec > 1000000 )
   {
      int nsec = ( x->tv_usec - y->tv_usec ) / 1000000;
      y->tv_usec += 1000000 * nsec;
      y->tv_sec -= nsec;
   }

   /* Compute the time remaining to wait.
      tv_usec is certainly positive. */
   result->tv_sec = x->tv_sec - y->tv_sec;
   result->tv_usec = x->tv_usec - y->tv_usec;

   /* Return 1 if result is negative. */
   return x->tv_sec < y->tv_sec;
}

#endif
