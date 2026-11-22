
#include "ticks.h"
#include <time.h>
#include <sys/time.h>
#ifdef WIN32
#include <winsock2.h>
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

/*
 * -iotimer / -mmtimer. A write records st so the readable count becomes 0.
 * A read stores that count at -mmtimer as 8 little-endian bytes and returns 0.
 * st itself is left alone: -start/-end and the exit report keep the whole run.
 */
static long long timer_base = 0;

int hook_iotimer_out(int port, int value)
{
    (void)value;
    if (c_iotimer < 0 || (port & 0xff) != (c_iotimer & 0xff))
        return -1;
    timer_base = st;
    return 0;
}

int hook_iotimer_in(int port)
{
    unsigned long long count;
    unsigned addr;
    int i;

    if (c_iotimer < 0 || (port & 0xff) != (c_iotimer & 0xff))
        return -1;
    count = (unsigned long long)(st - timer_base);
    addr = (unsigned)c_mmtimer;
    for (i = 0; i < 8; i++) {
        put_memory((uint16_t)((addr + i) & 0xffff), (uint8_t)(count & 0xff));
        count >>= 8;
    }
    return 0;
}
