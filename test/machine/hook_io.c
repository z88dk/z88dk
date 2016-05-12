/* IO hooks for the test target */

#include "machine.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>


#define CHECK_FD(R) do {                 \
        if ( slots[R->BC.B.h] == - 1 ) { \
            SET_ERROR(R, Z88DK_EBADF);   \
            R->HL.W = -1;                \
        } \
    } while (0)


static int slots[256];


static int normalise_errno()
{
    switch ( errno ) {
    case EINVAL:
        return Z88DK_EINVAL;
    case EBADF:
        return Z88DK_EBADF;
    case EACCES:
        return Z88DK_EACCES;
    case ENFILE:
        return Z88DK_ENFILE;
    case ENOMEM:
        return Z88DK_ENOMEM;
    case 0:
        return Z88DK_ENONE;
    default:
        return EINVAL;
    }
}



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
    CHECK_FD(R);

    close(slots[R->BC.B.h]);
    slots[R->BC.B.h] = -1;
    R->HL.W = 0;
    SET_ERROR(R,Z88DK_ENONE);
}

static void cmd_writebyte(Z80 *R)
{
    char  val = R->HL.B.h;

    CHECK_FD(R);
    R->HL.W = write(slots[R->BC.B.h], &val, 1);
    SET_ERROR(R,Z88DK_ENONE);
}

static void cmd_readbyte(Z80 *R)
{
    char  val;
    int   ret = -1;

    CHECK_FD(R);

    if ( read(slots[R->BC.B.h], &val, 1) == 1 ) {
        ret = val;
        SET_ERROR(R,Z88DK_ENONE);
    } else {
        SET_ERROR(R, normalise_errno());
    }
    R->HL.W = ret;
}

static void cmd_writeblock(Z80 *R)
{
    int   ret = -1;

    CHECK_FD(R);

    ret = write(slots[R->BC.B.h], (char *)RAM + R->DE.W, R->HL.W);
    if ( ret != -1 ) {
        SET_ERROR(R,Z88DK_ENONE);
    } else {
        SET_ERROR(R, normalise_errno());
    }
    R->HL.W = ret;
}

static void cmd_readblock(Z80 *R)
{
    int   ret = -1;

    CHECK_FD(R);

    ret = read(slots[R->BC.B.h], (char *)RAM + R->DE.W, R->HL.W);
    if ( ret != -1 ) {
        SET_ERROR(R,Z88DK_ENONE);
    } else {
        SET_ERROR(R, normalise_errno());
    }
    R->HL.W = ret;
}

static void cmd_seek(Z80 *R)
{
    off_t  ret;
    off_t  dest = (R->DE.W << 16 ) | (R->HL.W );
    int    whence = -1;

    CHECK_FD(R);

    switch ( R->BC.B.l ) {
    case Z88DK_SEEK_SET:
        whence = SEEK_SET;
        break;
    case Z88DK_SEEK_CUR:
        whence = SEEK_CUR;
        break;
    case Z88DK_SEEK_END:
        whence = SEEK_END;
        break;
    default:
        SET_ERROR(R,Z88DK_EINVAL);
        return;
    }


    ret = lseek(slots[R->BC.B.h], dest, whence);

    if ( ret != -1 ) {
        R->DE.W = ( ret >> 16 ) & 0xffff;
        R->HL.W = ( ret >> 0 ) & 0xffff;
        SET_ERROR(R, Z88DK_ENONE);
    } else {
        SET_ERROR(R, normalise_errno());
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
    cmds[CMD_SEEK] = cmd_seek;
}

