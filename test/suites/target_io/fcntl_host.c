/*
 * Host-file fcntl backend for target_io (ticks SYSCALL via ticks_host_fcntl.asm).
 * Used when the target has no host-visible disk under ticks (e.g. RC2014 basic).
 */

#include "io_port.h"

extern int  host_open(const char *name, int flags, int mode);
extern int  host_creat(const char *name, int mode);
extern int  host_close(int fd);
extern int  host_read(int fd, void *buf, unsigned int len);
extern int  host_write(int fd, void *buf, unsigned int len);
extern long host_lseek(int fd, long posn, int whence);

int tio_open(const char *name, int flags, int mode)
{
    return host_open(name, flags, mode);
}

int tio_creat(const char *name, int mode)
{
    return host_creat(name, mode);
}

int tio_close(int fd)
{
    return host_close(fd);
}

int tio_read(int fd, void *buf, unsigned int len)
{
    return host_read(fd, buf, len);
}

int tio_write(int fd, void *buf, unsigned int len)
{
    return host_write(fd, buf, len);
}

long tio_lseek(int fd, long posn, int whence)
{
    return host_lseek(fd, posn, whence);
}
