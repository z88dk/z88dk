#ifndef __STDIO_H__
#define __STDIO_H__

#include <sys/compiler.h>

/* $Id: stdio.h,v 1.24 2013-06-11 09:17:15 stefano Exp $ */

#undef __STDIO_BINARY      /* By default don't consider binary/text file differences */
#undef __STDIO_CRLF        /* By default don't insert automatic linefeed in text mode */

#ifdef FDSTDIO
#include <z88stdio.h>
#else

#ifdef __SPECTRUM__
#include <spectrum.h>
#endif

#ifdef __ZX81__
#include <zx81.h>
#endif

#ifdef __ZX80__
#include <zx81.h>
#endif

#ifdef __CPM__
/* This will define __STDIO_BINARY, __STDIO_EOFMARKER and __STDIO_CRLF  */
#include <cpm.h>
#endif

#ifdef __MSX__
/* This will define __STDIO_BINARY, __STDIO_EOFMARKER and __STDIO_CRLF  */
#include <cpm.h>
#include <msx.h>
#endif

#ifdef __OSCA__
/* This will define __STDIO_BINARY, __STDIO_EOFMARKER and __STDIO_CRLF  */
#include <flos.h>
#endif

#ifdef ZXVGS
#include <zxvgs.h>
#endif


/*
 * This is the new stdio library - everything is pretty much
 * generic - just a few machine specific routines are needed
 * and these are clearly marked
 */

#include <sys/types.h>
#include <fcntl.h>

#ifndef NULL
#define NULL ((void *)0)
#endif

#ifndef EOF
#define EOF (-1)
#endif

#define FILENAME_MAX    128

/* If you change this then you also have to pad out {zcc}/lib/stdio_fp.asm,
 * recompile the libs and fiddle with app_crt0.asm - best leave it!
 */
#define FOPEN_MAX       10

/* Indicate to the frontend that we want the new streams stuff */
#pragma output ANSIstdio

struct filestr {
        union f0xx {
                int     fd;
                u8_t    *ptr;
        } desc;
        u8_t    flags;
        u8_t    ungetc;
};

/* For asm routines kinda handy to have a nice DEFVARS of the structure*/
#ifdef STDIO_ASM
#asm
DEFVARS 0 {
	fp_desc		ds.w	1
	fp_flags	ds.b	1
	fp_ungetc	ds.b	1
}
#endasm
#endif


#define FILE struct filestr 

/* System is used for initial std* streams 
 * Network streams do not set IOREAD/IOWRITE, it is assumed that
 * they are read/write always
 */

#define _IOUSE          1
#define _IOREAD         2
#define _IOWRITE        4
#define _IOEOF          8
#define _IOSYSTEM      16
#define _IONETWORK     32
#define _IOTEXT        64
#define _IOSTRING     128


extern struct filestr _sgoioblk[FOPEN_MAX];


#define stdin  &_sgoioblk[0]
#define stdout &_sgoioblk[1]
#define stderr &_sgoioblk[2]


/* Macros for things we don't use */

#define clearerr(f)
#ifdef NET_STDIO
extern int __LIB__ fflush(FILE *);
#else
#define fflush(f)
#endif

/* Our new and improved functions!! */

extern FILE __LIB__ *fopen(far char *name, unsigned char *mode);
extern FILE __LIB__ *fopen_z88(far char *name, unsigned char *mode, unsigned char *explicit, size_t len);
extern FILE __LIB__ *freopen(far char *name, unsigned char *mode, FILE *fp);
extern FILE __LIB__ *freopen_z88(far char *n, unsigned char *m, FILE *fp, unsigned char *explicit, size_t len);
extern FILE __LIB__ *fdopen(int fildes, unsigned char *mode);

extern int __LIB__ fclose(FILE *fp);

extern void __LIB__ closeall();


#ifndef __RCMX000__

/* --------------------------------------------------------------*/
/* Optimized stdio uses the 'CALLEE' convention here and there   */

extern char __LIB__ *fgets(unsigned char *s, int, FILE *fp);

extern int __LIB__ fputs(unsigned char *s,  FILE *fp);
extern int __LIB__ fputc(int c, FILE *fp) __SMALLCDECL;

extern int __LIB__ __CALLEE__ fputs_callee(unsigned char *s,  FILE *fp);
extern int __LIB__ __CALLEE__ fputc_callee(int c, FILE *fp);
extern int __LIB__ __FASTCALL__ fgetc(FILE *fp);
#define getc(f) fgetc(f)
extern int __LIB__ ungetc(int c, FILE *);
extern int __LIB__ feof(FILE *fp);
extern int __LIB__ puts(unsigned char *);

#define fputs(a,b)   fputs_callee(a,b)
#define fputc(a,b)   fputc_callee(a,b)

/* Some standard macros */
#define putc(bp,fp) fputc_callee(bp,fp)
#define putchar(bp) fputc_callee(bp,stdout)
#define getchar()  fgetc(stdin)

/* --------------------------------------------------------------*/

#else

/* --------------------------------------------------------------*/
/* The "8080" stdio lib is at the moment used only by the        */
/* Rabbit Control Module, which is not fully z80 compatible      */

extern char __LIB__ *fgets(unsigned char *s, int, FILE *fp);
extern int __LIB__ fputs(unsigned char *s,  FILE *fp);
extern int __LIB__ fputc(int c, FILE *fp) __SMALLCDECL;
extern int __LIB__ fgetc(FILE *fp);
#define getc(f) fgetc(f)
extern int __LIB__ ungetc(int c, FILE *);
extern int __LIB__ feof(FILE *fp);
extern int __LIB__ puts(unsigned char *);

/* Some standard macros */
#define putc(bp,fp) fputc(bp,fp)
#define putchar(bp) fputc(bp,stdout)
#define getchar()  fgetc(stdin)

/* --------------------------------------------------------------*/

#endif

/* Routines for file positioning */
extern fpos_t __LIB__ ftell(FILE *fp);
extern int __LIB__ fgetpos(FILE *fp, fpos_t *pos);
#define fsetpos(fp,pos) fseek(fp,pos,SEEK_SET)
#define rewind(fp) fseek(fp,0L,SEEK_SET)
extern int __LIB__ fseek(FILE *fp, fpos_t offset, int whence);

/* Block read/writing */
extern int __LIB__ fread(void *ptr, int size, int num, FILE *);
extern int __LIB__ fwrite(void *ptr, int size, int num, FILE *);


/* You shouldn't use gets. z88 gets() is limited to 255 characters */
extern char __LIB__ *gets(char *s);


/*
 * Yes! vfprintf is deliberately without a __LIB__ cos
 * a jp to the real routine is in the startup code
 */

extern int __LIB__ printf(char *,...);
extern int __LIB__ fprintf(FILE *,char *,...);
extern int __LIB__ sprintf(char *,char *,...);
extern int  vfprintf(FILE *,unsigned char *fmt,void *ap);
extern int __LIB__ vsprintf(char *str,unsigned char *fmt,void *ap);

#define vprintf(ctl,arg) vfprintf(stdout,ctl,arg)

/* real printf cores */

extern int __LIB__ vfprintf_mini(FILE *, unsigned char *, void *);
extern int __LIB__ vfprintf_comp(FILE *, unsigned char *, void *);
extern int __LIB__ vfprintf_fp(FILE *, unsigned char *, void *);

extern __LIB__ printn(int number, int radix,FILE *file);
extern int __LIB__ ltoa_any(long in,unsigned  char *str, int sz, unsigned int radix, int signflag);


/*
 * Scanf family 
 */

extern int __LIB__ scanf(unsigned char *fmt,...);
extern int __LIB__ fscanf(FILE *,unsigned char *fmt,...);
extern int __LIB__ sscanf(char *,unsigned char *fmt,...);
extern int __LIB__ vfscanf(FILE *, unsigned char *fmt, void *ap);
extern int __LIB__ vsscanf(char *str, unsigned char *fmt, void *ap);
#define vscanf(ctl,arg) vfscanf(stdout,ctl,arg)


/*
 * Used in variable argument lists
 */

#ifndef DEF_GETARG
#define DEF_GETARG
extern int __LIB__ getarg(void);
#endif


/*
 * Support routines
 *
 * fchkstd checks for std* varieties
 *
 * f(put|get)c_cons write/read byte to console (to avoid having
 * file open for them) used internally, but you could use them
 * (but may change etc etc)
 */

extern int __LIB__ fchkstd(FILE *);

/* All functions below here are machine specific */
extern int __LIB__ fgetc_cons();
extern int __LIB__ fputc_cons(char c);
extern int __LIB__ fgets_cons(char *s, int n);
/* Abandon file - can be the generic version */
extern void __LIB__ fabandon(FILE *);
/* Get file position for file handle fd */
extern long __LIB__ fdtell(int fd);
extern int __LIB__ fdgetpos(int fd, fpos_t *posn);
/* Rename a file */
extern int __LIB__ rename(char *s, char *d);
/* Remove a file */
extern int __LIB__ remove(char *name);

/*
 * Non-standard, but useful for games:
 *
 * getk() returns key currently pressed or 0 if none
 * getkey() waits for a key to be pressed before returning
 * puts_cons() is like puts() but o/p directly to screen
 * printk() is a printf directly to console (bypasses streams)
 * 	    this is not available for the ANSI terminal libraries
 */
extern int __LIB__ getk();
#define getkey() fgetc_cons()
extern void __LIB__ puts_cons(char *message);
extern void __LIB__ printk(char *fmt,...);


/*
 * Networking stdio routines
 */

#ifdef NET_STDIO
#include <net/stdio.h>
#endif

#endif /* !FDSTDIO */


/*
 *  MICRO C compatibility:  keep at bottom of this file
 *  Some of Dunfield's Micro C code can be ported with the '-DMICROC' parameter
 */

#ifdef MICROC
#include <microc.h>
#endif

#endif /* _STDIO_H */
