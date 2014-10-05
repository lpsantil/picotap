/*
 * Copyright (c) 2013, 2014, Louis P. Santillan <lpsantil@gmail.com>
 * All rights reserved.
 */

#ifndef __TAP_TIME_H__
#define __TAP_TIME_H__

#include <sys/types.h>
#include <sys/time.h>
#define TAP_time struct timeval
#define getTAPtime( t )  gettimeofday( t, NULL )

int time_sub( TAP_time *result,
              TAP_time *x,
              TAP_time *y );

#endif
