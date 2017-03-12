
#include "ticks.h"

#include <time.h>


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

void hook_misc_init(hook_command *cmds)
{
    cmds[CMD_GETTIME] = cmd_gettime;
}
