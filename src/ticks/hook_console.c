
#include "ticks.h"

#include <stdio.h>


static void cmd_printchar(void)
{
    if ( l == '\n' || l == '\r' ) {
        fputc('\n',stdout);
    } else {
        fputc(l,stdout);
    }
    SET_ERROR(Z88DK_ENONE);
    fflush(stdout);
}


static void cmd_readkey(void)
{
    int   val;

    val = getchar();
    l = val % 256;
    h = val / 256;

    SET_ERROR(Z88DK_ENONE);
}

void hook_console_init(hook_command *cmds)
{
    cmds[CMD_PRINTCHAR] = cmd_printchar;
    cmds[CMD_READKEY] = cmd_readkey;
}
