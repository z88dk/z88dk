/*
 * Portable file I/O port for the target_io suite.
 *
 * Shared tests call tio_* only.  Each target links either:
 *   - fcntl_native.c  (classic/native open/creat/… — e.g. CP/M)
 *   - fcntl_host.c + ticks_host_fcntl.asm  (ticks SYSCALL host files)
 *
 * Define at compile time:
 *   TIO_LABEL   short tag used in messages (e.g. "CPM", "RC2014")
 *   TIO_USE_HOST_FCNTL  if using the ticks SYSCALL backend
 */

#ifndef IO_PORT_H
#define IO_PORT_H

#ifndef TIO_LABEL
#define TIO_LABEL "TIO"
#endif

/* 8.3-safe names so CP/M and longer-name targets share one suite */
#define TIO_TEST_FILE "suite.dat"
#define TIO_FILE_A    "a.dat"
#define TIO_FILE_B    "b.dat"

#define TIO_PAYLOAD   "DISK-TEST-PAYLOAD!"
#define TIO_SEEK_OFF  4

int  tio_open(const char *name, int flags, int mode);
int  tio_creat(const char *name, int mode);
int  tio_close(int fd);
int  tio_read(int fd, void *buf, unsigned int len);
int  tio_write(int fd, void *buf, unsigned int len);
long tio_lseek(int fd, long posn, int whence);

#ifdef TIO_USE_HOST_FCNTL
/* Match src/ticks/ticks.h Z88DK_O_* / Z88DK_SEEK_* */
#define TIO_O_RDONLY  0
#define TIO_O_WRONLY  1
#define TIO_O_RDWR    2
#define TIO_SEEK_SET  0
#define TIO_SEEK_END  1
#define TIO_SEEK_CUR  2
#else
#include <fcntl.h>
#define TIO_O_RDONLY  O_RDONLY
#define TIO_O_WRONLY  O_WRONLY
#define TIO_O_RDWR    O_RDWR
#define TIO_SEEK_SET  SEEK_SET
#define TIO_SEEK_END  SEEK_END
#define TIO_SEEK_CUR  SEEK_CUR
#endif

#endif
