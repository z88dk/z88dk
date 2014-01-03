/*
 *      Small C+ Library
 *
 *      fnctl.h - low level file routines
 *
 *      djm 27/4/99
 *
 *	$Id: fcntl.h,v 1.15 2014-01-03 15:20:42 stefano Exp $
 */


#ifndef __FCNTL_H__
#define __FCNTL_H__

#include <sys/compiler.h>
#include <sys/types.h>


#define O_RDONLY  0
#define O_WRONLY  1
#define O_APPEND  256

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

/* unsupported flags */
#define O_RDWR    2
#define O_ACCMODE 3


/* O_BINARY has no significence */
#define O_BINARY  0

typedef int mode_t;


extern int __LIB__ open(far char *name, int flags, mode_t mode) __SMALLCDECL;
extern int __LIB__ creat(far char *name, mode_t mode) __SMALLCDECL;
extern int __LIB__ close(int fd);
extern size_t __LIB__ read(int fd, void *ptr, size_t len) __SMALLCDECL;
extern size_t __LIB__ write(int fd, void *ptr, size_t len) __SMALLCDECL;
extern long __LIB__ lseek(int fd,long posn, int whence) __SMALLCDECL;

extern int __LIB__ __FASTCALL__ readbyte(int fd);
extern int __LIB__ writebyte(int fd, int c);

/* Open a file returning the explicit filename, with length len */

extern int __LIB__ open_z88(far char *name, int flags, mode_t mode, char *explicit, size_t len) __SMALLCDECL;

/* As above except the filename is near - good for ZSock devices (z88)*/

extern int __LIB__ nropen(char *name, int flags, mode_t mode, char *explicit, size_t len) __SMALLCDECL;

/* mkdir is defined in sys/stat.h */
/* extern int __LIB__ mkdir(char *, int mode); */

extern char __LIB__ *getcwd(char *buf, size_t maxlen) __SMALLCDECL;

/* Following two only implemented for Sprinter ATM (20.11.2002) */
extern int  __LIB__ rmdir(char *);
extern char __LIB__ *getwd(char *buf);


/* ********************************************************* */

/*
* Default block size for "gendos.lib"
* every single block (up to 36) is written in a separate file
* the bigger RND_BLOCKSIZE, bigger can be the output file size,
* but this comes at the cost of the malloc'd space for the internal buffer.
* The current block size is kept in a control block (just the RND_FILE structure saved in a separate file),
* so changing this value at runtime before creating a file is perfectly legal.

In the target's CRT0 stubs the following lines must exist:

XDEF _RND_BLOCKSIZE
_RND_BLOCKSIZE:	defw	1000

*/

extern unsigned int   RND_BLOCKSIZE;

/* Used in the generic random file access library only */
/* file will be split into blocks */

struct RND_FILE {
	char    name_prefix;   /* block name, including prefix char */
	char    name[15];         /* file name */
	u16_t	blocksize;
	unsigned char *blockptr;
	long    size;             /* file size */
	long    position;         /* current position in file */
	u16_t	pos_in_block;
	mode_t  mode;
};


/* The following three functions are target specific */
extern int  __LIB__ rnd_loadblock(char *name, size_t loadstart, size_t len) __SMALLCDECL;
extern int  __LIB__ rnd_saveblock(char *name, size_t loadstart, size_t len) __SMALLCDECL;
extern int  __LIB__ __FASTCALL__ rnd_erase(char *name);

/* ********************************************************* */

#endif /* _FCNTL_H */
