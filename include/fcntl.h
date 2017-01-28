/*
 *      Small C+ Library
 *
 *      fnctl.h - low level file routines
 *
 *      djm 27/4/99
 *
 *	$Id: fcntl.h,v 1.21 2016-07-14 17:44:17 pauloscustodio Exp $
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


extern int __LIB__ open(const char *name, int flags, mode_t mode) __smallc;
extern int __LIB__ creat(const char *name, mode_t mode) __smallc;
extern int __LIB__ close(int fd);
extern size_t __LIB__ read(int fd, void *ptr, size_t len) __smallc;
extern size_t __LIB__ write(int fd, const void *ptr, size_t len) __smallc;
extern long __LIB__ __SAVEFRAME__ lseek(int fd,long posn, int whence) __smallc;

extern int __LIB__  readbyte(int fd) __smallc __z88dk_fastcall;
extern int __LIB__ writebyte(int fd, int c) __smallc;


/* mkdir is defined in sys/stat.h */
/* extern int __LIB__ mkdir(char *, int mode); */

extern char __LIB__ *getcwd(char *buf, size_t maxlen) __smallc;

/* Following two only implemented for Sprinter ATM (20.11.2002) */
extern int  __LIB__ rmdir(const char *);
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

PUBLIC _RND_BLOCKSIZE
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
extern int  __LIB__ rnd_loadblock(char *name, size_t loadstart, size_t len) __smallc;
extern int  __LIB__ rnd_saveblock(char *name, size_t loadstart, size_t len) __smallc;
extern int  __LIB__  rnd_erase(char *name) __smallc __z88dk_fastcall;

/* ********************************************************* */

#endif /* _FCNTL_H */
