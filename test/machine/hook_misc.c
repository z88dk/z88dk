
#include "machine.h"

#include <time.h>


static void cmd_gettime(Z80 *R)
{
    time_t  tim = time(NULL);

    R->HL.W = (tim % 65536);
    R->DE.W = (tim / 65536);

    SET_ERROR(R, Z88DK_ENONE);
}

void hook_misc_init(hook_command *cmds)
{
    cmds[CMD_GETTIME] = cmd_gettime;
}
