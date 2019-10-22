/*
 * Copyright (c) 1982, 1986 The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *    This product includes software developed by the University of
 *    California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *    @(#)time.h    7.6 (Berkeley) 2/22/91
 */

/* messed about with substantially by @feilipu October 2019 */

#ifndef _SYS_TIME_H_
#define _SYS_TIME_H_

#include <sys/types.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Structure returned by clock_gettime() system call
 * and used in other calls.
 */
 
struct timespec {
    time_t      tv_sec;     /* seconds */
    nseconds_t  tv_nsec;    /* and nanoseconds */
};

enum clock_id {
    CLOCK_REALTIME,
    CLOCK_MONOTONIC,
    CLOCK_PROCESS_CPUTIME_ID,
    CLOCK_THREAD_CPUTIME_ID,
    CLOCK_MONOTONIC_RAW,
    CLOCK_REALTIME_COARSE,
    CLOCK_MONOTONIC_COARSE
};

/*
 * Convenience macros for operations on timevals
 * NOTE: `timercmp' does not work for >= or <=
 */

#define    timerisset(tvp)  ((tvp)->tv_sec || (tvp)->tv_nsec)
#define    timerclear(tvp)  ((tvp)->tv_sec = (tvp)->tv_nsec = 0)
#define    timercmp(a, b, CMP)                                  \
  (((a)->tv_sec == (b)->tv_sec) ?                               \
   ((a)->tv_nsec CMP (b)->tv_nsec) :                            \
   ((a)->tv_sec CMP (b)->tv_sec))
#define    timeradd(a, b, result)                               \
  do {                                                          \
    (result)->tv_sec = (a)->tv_sec + (b)->tv_sec;               \
    (result)->tv_nsec = (a)->tv_nsec + (b)->tv_nsec;            \
    if ((result)->tv_nsec >= 1000000000)                        \
      {                                                         \
    ++(result)->tv_sec;                                         \
    (result)->tv_nsec -= 1000000000;                            \
      }                                                         \
  } while (0)
#define    timersub(a, b, result)                               \
  do {                                                          \
    (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;               \
    (result)->tv_nsec = (a)->tv_nsec - (b)->tv_nsec;            \
    if ((a)->tv_nsec < ((b)->tv_nsec) {                         \
      --(result)->tv_sec;                                       \
      (result)->tv_nsec += 1000000000;                          \
    }                                                           \
  } while (0)


#ifdef __cplusplus
}
#endif
#endif /* !_SYS_TIME_H_ */
