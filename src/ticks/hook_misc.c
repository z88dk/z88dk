
#include "ticks.h"
#include <time.h>


static time_t start_time = 0;

#ifdef WIN32
#ifdef __MINGW32__
#include <sys/time.h>
#else
// Extracted from: https://stackoverflow.com/questions/10905892/equivalent-of-gettimeday-for-windows
#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <stdint.h> // portable: uint64_t   MSVC: __int64 

// MSVC defines this in winsock2.h!?
typedef struct timeval {
    long tv_sec;
    long tv_usec;
} timeval;

int gettimeofday(struct timeval * tp, struct timezone * tzp)
{
    // Note: some broken versions only have 8 trailing zero's, the correct epoch has 9 trailing zero's
    // This magic number is the number of 100 nanosecond intervals since January 1, 1601 (UTC)
    // until 00:00:00 January 1, 1970 
    static const uint64_t EPOCH = ((uint64_t) 116444736000000000ULL);

    SYSTEMTIME  system_time;
    FILETIME    file_time;
    uint64_t    time;

    GetSystemTime( &system_time );
    SystemTimeToFileTime( &system_time, &file_time );
    time =  ((uint64_t)file_time.dwLowDateTime )      ;
    time += ((uint64_t)file_time.dwHighDateTime) << 32;

    tp->tv_sec  = (long) ((time - EPOCH) / 10000000L);
    tp->tv_usec = (long) (system_time.wMilliseconds * 1000);
    return 0;
}
#endif

#else
#include <sys/time.h>
#endif

static void cmd_gettime(void)
{
    time_t  tim = time(NULL);
    int     t;

    t = (tim % 65536);
    l = t % 256;
    h = t / 256;
    t = (tim / 65536);
    e = t % 256;
    d = t / 256;

    SET_ERROR(Z88DK_ENONE);
}

static void cmd_getclock(void)
{
    struct timeval tv;
    uint32_t tim;
    int     t;

    gettimeofday(&tv, NULL);

    tim = (tv.tv_sec - start_time) * 1000 + tv.tv_usec / 1000;

    t = (tim % 65536);
    l = t % 256;
    h = t / 256;
    t = (tim / 65536);
    e = t % 256;
    d = t / 256;

    SET_ERROR(Z88DK_ENONE);
}

void hook_misc_init(hook_command *cmds)
{
    start_time = time(NULL);
    cmds[CMD_GETTIME] = cmd_gettime;
    cmds[CMD_GETCLOCK] = cmd_getclock;
}
