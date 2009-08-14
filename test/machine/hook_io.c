/* IO hooks for the test target */

#include "machine.h"

#include <stdio.h>


static int slots[256];


int find_slot()
{
    int  i;

    for ( i = 0; i < sizeof(slots); i++ ) {
        if ( slots[i] == 0 ) {
            return i;
        }
    }
    return -1;
}

static void cmd_openfile(Z80 *R)
{
    char *filename = (char *)RAM + R->HL.W;
    int   flags = R->DE.W;
    int   mode = R->BC.W;
    int   slot = find_slot();

    R->HL.W = -1;

    if ( slot != -1 ) {
        int fd = open(filename, flags, mode);
        
        if ( fd != -1 ) {
            slots[slot] = fd;
            R->HL.W = slot;
            SET_ERROR(R,Z88DK_ENONE);
        } else {
            /* Do something */
        }
    } else {
        SET_ERROR(R,Z88DK_ENFILE);
    }
}

static void cmd_closefile(Z80 *R)
{
    R->HL.W = -1;
    if ( slots[R->BC.B.l] != -1 ) {
        close(slots[R->BC.B.l]);
        slots[R->BC.B.l] = -1;
        R->BC.W = 0;
    } else {
        SET_ERROR(R,Z88DK_EINVAL);
    }
}

static void cmd_writebyte(Z80 *R)
{
    char  val = R->HL.B.l;

    R->HL.W = -1;
    if ( slots[R->BC.B.l] != -1 ) {
        R->HL.W = write(slots[R->BC.B.l], &val, 1);
    } else {
        SET_ERROR(R,Z88DK_EINVAL);
    }
}

static void cmd_readbyte(Z80 *R)
{
    char  val;
    int   ret = -1;

    if ( slots[R->BC.B.l] != -1 ) {
        if ( read(slots[R->BC.B.l], &val, 1) == 1 ) {
            ret = val;
        }
    } else {
        SET_ERROR(R,Z88DK_EINVAL);
    }
    R->HL.W = ret;
}

static void cmd_writeblock(Z80 *R)
{
    int   ret = -1;

    if ( slots[R->BC.B.l] != -1 ) {
        ret = write(slots[R->BC.B.l], (char *)RAM + R->HL.W, R->DE.W);
    } else {
        SET_ERROR(R,Z88DK_EINVAL);
    }
    R->HL.W = ret;
}

static void cmd_readblock(Z80 *R)
{
    int   ret = -1;

    if ( slots[R->BC.B.l] != -1 ) {
        ret = read(slots[R->BC.B.l], (char *)RAM + R->HL.W, R->DE.W);
    } else {
        SET_ERROR(R,Z88DK_EINVAL);
    }
    R->HL.W = ret;
}

static void cmd_seek(Z80 *R)
{
    off_t  ret;

    if ( slots[R->BC.B.l] != -1 ) {

    } else {
        SET_ERROR(R,Z88DK_EINVAL);
    }

}


void hook_io_init(hook_command *cmds)
{
    int  i;

    /* Reserve slots that are usually used for std* */
    slots[0] = fileno(stdin);
    slots[1] = fileno(stdout);
    slots[2] = fileno(stderr);
    for (i = 3; i < sizeof(slots); i++ ) {
        slots[i] = -1;
    }

    cmds[CMD_OPENF] = cmd_openfile;
    cmds[CMD_CLOSEF] = cmd_closefile;
    cmds[CMD_WRITEBYTE] = cmd_writebyte;
    cmds[CMD_READBYTE] = cmd_readbyte;

}

