
#include "machine.h"

#include <stdio.h>


static void cmd_printchar(Z80 *R)
{
    if ( R->HL.B.l == '\n' || R->HL.B.l == '\r' ) {
        fputc('\n',stdout);
    } else {
        fputc(R->HL.B.l,stdout);
    }
    SET_ERROR(R,Z88DK_ENONE);
    fflush(stdout);
}


static void cmd_readkey(Z80 *R)
{
    int   val;

    val = getchar();
    R->HL.W = val;

    SET_ERROR(R, Z88DK_ENONE);
}

void hook_console_init(hook_command *cmds)
{
    cmds[CMD_PRINTCHAR] = cmd_printchar;
    cmds[CMD_READKEY] = cmd_readkey;
}
