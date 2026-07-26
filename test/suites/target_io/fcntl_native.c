/*
 * Native fcntl backend for target_io (CP/M, and any target with open/creat).
 */

#include "io_port.h"
#include <fcntl.h>

int tio_open(const char *name, int flags, int mode)
{
    return open(name, flags, mode);
}

int tio_creat(const char *name, int mode)
{
    return creat(name, mode);
}

int tio_close(int fd)
{
    return close(fd);
}

int tio_read(int fd, void *buf, unsigned int len)
{
    return (int)read(fd, buf, len);
}

int tio_write(int fd, void *buf, unsigned int len)
{
    return (int)write(fd, buf, len);
}

long tio_lseek(int fd, long posn, int whence)
{
    return lseek(fd, posn, whence);
}
