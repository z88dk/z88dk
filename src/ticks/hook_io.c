/* IO hooks for the test target */

#include "ticks.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>

#ifdef WIN32
#include        <io.h>
#include        <sys/stat.h>
#else
#include        <unistd.h>
#endif

#define CHECK_FD() do {                 \
        if ( slots[b] == - 1 ) { \
            SET_ERROR(Z88DK_EBADF);   \
            l = h = 255;                 \
        } \
    } while (0)

#define NUM_SLOTS 256
static int slots[NUM_SLOTS];


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

    for ( i = 0; i < NUM_SLOTS; i++ ) {
        if ( slots[i] == 0 ) {
            return i;
        }
    }
    return -1;
}

static void cmd_openfile(void)
{
    char *filename = (char *)mem + ( l | h <<8);
    int   flags = e | d << 8;
    int   mode = c | b << 8;
    int   slot = find_slot();

    l = h = 255; 

    if ( slot != -1 ) {
        int fd = open(filename, flags, mode);
        
        if ( fd != -1 ) {
            slots[slot] = fd;
            l = slot % 256;
            h = slot / 256;
            SET_ERROR(Z88DK_ENONE);
        } else {
            /* Do something */
        }
    } else {
        SET_ERROR(Z88DK_ENFILE);
    }
}

static void cmd_closefile(void)
{
    CHECK_FD();

    close(slots[b]);
    slots[b] = -1;
    l = h = 0;
    SET_ERROR(Z88DK_ENONE);
}

static void cmd_writebyte(void)
{
    char  val = l;
    int   result;

    CHECK_FD();
    result = write(slots[b], &val, 1);
    l = result % 256;
    h = result / 256;
    SET_ERROR(Z88DK_ENONE);
}

static void cmd_readbyte(void)
{
    char  val;
    int   ret = -1;

    CHECK_FD();

    if ( read(slots[b], &val, 1) == 1 ) {
        ret = val;
        SET_ERROR(Z88DK_ENONE);
    } else {
        SET_ERROR(normalise_errno());
    }
    l = ret;
    h = 0;
}

static void cmd_writeblock(void)
{
    int   ret = -1;

    CHECK_FD();

    ret = write(slots[b], (char *)mem + (e | d<<8), (l | h << 8));
    if ( ret != -1 ) {
        SET_ERROR(Z88DK_ENONE);
    } else {
        SET_ERROR(normalise_errno());
    }
    l = ret % 256;
    h = ret / 256;
}

static void cmd_readblock(void)
{
    int   ret = -1;

    CHECK_FD();

    ret = read(slots[b], (char *)mem + (e | d << 8), (l | h <<8));
    if ( ret != -1 ) {
        SET_ERROR(Z88DK_ENONE);
    } else {
        SET_ERROR(normalise_errno());
    }
    l = ret % 256;
    h = ret / 256;
}

static void cmd_seek(void)
{
    off_t  ret;
    off_t  dest = ( ( e | d << 8) << 16 ) | (l | h << 8);
    int    whence = -1;

    CHECK_FD();

    switch ( c ) {
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
        SET_ERROR(Z88DK_EINVAL);
        return;
    }


    ret = lseek(slots[b], dest, whence);

    if ( ret != -1 ) {
        int t = ( ret >> 16 ) & 0xffff;
        e = t % 256;
        e = t / 256;
        t = ( ret >> 0 ) & 0xffff;
        l = t % 256;
        h = t / 256;
        SET_ERROR(Z88DK_ENONE);
    } else {
        SET_ERROR(normalise_errno());
    }
}

void hook_io_init(hook_command *cmds)
{
    int  i;

    /* Reserve slots that are usually used for std* */
    slots[0] = fileno(stdin);
    slots[1] = fileno(stdout);
    slots[2] = fileno(stderr);
    for (i = 3; i < NUM_SLOTS; i++ ) {
        slots[i] = -1;
    }

    cmds[CMD_OPENF] = cmd_openfile;
    cmds[CMD_CLOSEF] = cmd_closefile;
    cmds[CMD_WRITEBYTE] = cmd_writebyte;
    cmds[CMD_READBYTE] = cmd_readbyte;
    cmds[CMD_SEEK] = cmd_seek;
}

