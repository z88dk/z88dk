/*
 *      Small C+ Library
 *
 *      fnctl.h - low level file routines
 *
 *      djm 27/4/99
 *
 *	$Id: fcntl.h,v 1.3 2001-04-20 16:04:24 dom Exp $
 */


#ifndef _FCNTL_H
#define _FCNTL_H

#include <sys/types.h>


#define O_RDONLY  0
#define O_WRONLY  1
#define O_APPEND  256

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2


/* O_BINARY has no significence */
#define O_BINARY  0

typedef int mode_t;


extern int __LIB__ open(far char *name, int flags, mode_t mode);
extern int __LIB__ creat(far char *name, mode_t mode);
extern int __LIB__ close(int fd);
extern size_t __LIB__ read(int fd, void *ptr, size_t len);
extern size_t __LIB__ write(int fd, void *ptr, size_t len);
extern long __LIB__ lseek(int fd,long posn, int whence);

extern int __LIB__ __FASTCALL__ readbyte(int fd);
extern int __LIB__ writebyte(int fd, int c);

/* Open a file returning the explicit filename, with length len */

extern int __LIB__ open_z88(far char *name, int flags, mode_t mode, char *explicit, size_t len);

/* As above except the filename is near - good for ZSock devices (z88)*/

extern int __LIB__ nropen(char *name, int flags, mode_t mode, char *explicit, size_t len);

#endif /* _FCNTL_H */
