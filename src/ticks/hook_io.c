/* IO hooks for the test target */

#include "ticks.h"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>

#ifdef WIN32
#include        <io.h>
#else
#include        <unistd.h>
#endif

#define CHECK_FD() do {                 \
        if ( slots[b] == -1 ) { \
            SET_ERROR(Z88DK_EBADF);   \
            l = h = 255;                 \
        } \
    } while (0)

#define NUM_SLOTS 256
static int slots[NUM_SLOTS];

static int selected_unit = 0;
static int devices[2];


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
        if ( slots[i] == -1 ) {
            return i;
        }
    }
    return -1;
}

static void cmd_openfile(void)
{
    uint16_t filename_addr = (uint16_t)(l | h << 8);
    char *filename = malloc(65536);
    int filename_len;
    int   z88dk_flags = e | d << 8;
    int   flags = O_RDONLY;
    int   mode = c | b << 8;
    int   slot = find_slot();

    if ( z88dk_flags & Z88DK_O_WRONLY ) flags = O_WRONLY;
    if ( z88dk_flags & Z88DK_O_RDWR ) flags = O_RDWR;
    if ( z88dk_flags & Z88DK_O_TRUNC ) flags |= O_TRUNC;
    if ( z88dk_flags & Z88DK_O_APPEND ) flags |= O_APPEND;
    if ( z88dk_flags & Z88DK_O_CREAT ) flags |= O_CREAT;

    l = h = 255;
    if ( filename == NULL ) {
        errno = ENOMEM;
        SET_ERROR(normalise_errno());
        return;
    }
    for ( filename_len = 0; filename_len < 65536; filename_len++ ) {
        filename[filename_len] = get_memory_inst((uint16_t)(filename_addr + filename_len));
        if ( filename[filename_len] == 0 ) break;
    }
    if ( filename_len == 65536 ) {
        free(filename);
        SET_ERROR(Z88DK_EINVAL);
        return;
    }
    if ( slot != -1 ) {
#ifdef WIN32
        int fd = open(filename, flags|O_BINARY, _S_IREAD | _S_IWRITE);
#else
        int fd = open(filename, flags, S_IRWXU);
#endif
        
        if ( fd != -1 ) {
            slots[slot] = fd;
            l = slot % 256;
            h = slot / 256;
            SET_ERROR(Z88DK_ENONE);
        } else {
            SET_ERROR(Z88DK_ENFILE);
            /* Do something */
        }
    } else {
        SET_ERROR(Z88DK_ENFILE);
    }
    free(filename);
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
    int ret;

    CHECK_FD();
    if ( read(slots[b], &val, 1) == 1 ) {
        ret = val;
        SET_ERROR(Z88DK_ENONE);
    } else {
        ret = 65535;
        SET_ERROR(normalise_errno());
    }
    l = ret % 256;
    h = ret / 256;
}

static void cmd_writeblock(void)
{
    int ret = -1;

    CHECK_FD();

    {
        uint16_t addr = (uint16_t)(e | d << 8);
        unsigned int len = (unsigned int)(l | h << 8), i;
        uint8_t *buffer = malloc(len ? len : 1);
        if ( buffer == NULL ) { errno = ENOMEM; ret = -1; }
        else {
            for ( i = 0; i < len; i++ ) buffer[i] = get_memory_inst((uint16_t)(addr + i));
            ret = write(slots[b], buffer, len);
            free(buffer);
        }
    }
    if ( ret != -1 ) {
        SET_ERROR(Z88DK_ENONE);
    } else {
        ret = 65535;
        SET_ERROR(normalise_errno());
    }
    l = ret % 256;
    h = ret / 256;
}

static void cmd_readblock(void)
{
    int   ret = -1;

    CHECK_FD();

    {
        uint16_t addr = (uint16_t)(e | d << 8);
        unsigned int len = (unsigned int)(l | h << 8), i;
        uint8_t *buffer = malloc(len ? len : 1);
        if ( buffer == NULL ) { errno = ENOMEM; ret = -1; }
        else {
            ret = read(slots[b], buffer, len);
            if ( ret > 0 ) for ( i = 0; i < (unsigned int)ret; i++ ) put_memory((uint16_t)(addr + i), buffer[i]);
            free(buffer);
        }
    }
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
        d = t / 256;
        t = ( ret >> 0 ) & 0xffff;
        l = t % 256;
        h = t / 256;
        SET_ERROR(Z88DK_ENONE);
    } else {
        SET_ERROR(normalise_errno());
    }
}

static void cmd_ide_identify(void)
{

}

static void cmd_ide_select(void)
{
    selected_unit = l & 1;

    SET_ERROR(Z88DK_ENONE);
}

static void cmd_ide_read(void)
{
    off_t  dest = (( ( c | b << 8) << 16 ) | (l | h << 8)) * 512;

    if ( lseek(devices[selected_unit], dest, SEEK_SET) != dest ) {
        SET_ERROR(normalise_errno());
        return;
    }
    {
        uint8_t buffer[512];
        int i;
        if ( read(devices[selected_unit], buffer, sizeof(buffer)) != sizeof(buffer) ) {
            SET_ERROR(normalise_errno());
            return;
        }
        for ( i = 0; i < sizeof(buffer); i++ ) put_memory((uint16_t)((e | d << 8) + i), buffer[i]);
    }
    SET_ERROR(Z88DK_ENONE);
}

static void cmd_ide_write(void)
{
    off_t  dest = (( ( c | b << 8) << 16 ) | (l | h << 8)) * 512;

    if ( lseek(devices[selected_unit], dest, SEEK_SET) != dest ) {
        SET_ERROR(normalise_errno());
        return;
    }
    {
        uint8_t buffer[512];
        int i;
        for ( i = 0; i < sizeof(buffer); i++ ) buffer[i] = get_memory_inst((uint16_t)((e | d << 8) + i));
        if ( write(devices[selected_unit], buffer, sizeof(buffer)) != sizeof(buffer) ) {
            SET_ERROR(normalise_errno());
            return;
        }
    }
    SET_ERROR(Z88DK_ENONE);
}

void hook_io_set_ide_device(int unit, const char *file)
{
    devices[unit] = open(file, O_RDWR);
    if ( devices[unit] == -1 ) {
        printf("Cannot open <%s>",file);
        exit(1);
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
    cmds[CMD_READBLOCK] = cmd_readblock;
    cmds[CMD_WRITEBLOCK] = cmd_writeblock;

    cmds[CMD_IDE_SELECT] = cmd_ide_select;
    cmds[CMD_IDE_ID] = cmd_ide_identify;
    cmds[CMD_IDE_READ] = cmd_ide_read;
    cmds[CMD_IDE_WRITE] = cmd_ide_write;
}

