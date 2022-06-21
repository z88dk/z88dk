
#include "ticks.h"
#include <time.h>
#include <sys/time.h>
#ifdef _MSC_VER
#include <WinSock2.h>
#endif

static time_t start_time = 0;


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
