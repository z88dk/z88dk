#ifndef __Z88STDIO_H__
#define __Z88STDIO_H__

/*
 * This file contains a few useful functions from the original
 * z88dk stdio library
 *
 * All these operate on a file handle fd (as supplied by open)
 * (or by the fopen in this file
 *
 * If porting, don't bother with these - more hassle than they're
 * worth!
 *
 * Use these routines by #define FDSTDIO and linking with -lz88
 *
 * Most of these return non-ANSI return values or are just very
 * slightly messed up!
 *
 * These routines are not supported!!!
 *
 * djm 4/4/2000
 *
 * $Id: z88stdio.h,v 1.4 2001-10-16 18:30:32 dom Exp $
 */


#include <sys/types.h>
#include <fcntl.h>

#ifndef NULL
#define NULL  ((void *)0)
#endif
#ifndef EOF
#define EOF (-1)
#endif

#define FILE int
extern  FILE  *_sgoioblk[3];

/*
 * Is 128 characters enough for a filename + path?
 * Comments please
 */
#define FILENAME_MAX 128

/*
 * Now stuff for stdin/out/err this block is in z88_crt0.asm
 */

#define stdin  (_sgoioblk[0])
#define stdout (_sgoioblk[1])
#define stderr (_sgoioblk[2])




#define fopen(a,b) zfdopen(a,b)
#define fopen_z88(a,b,c,d) zfdopen_z88(a,b,c,d)

extern FILE __LIB__ *zfdopen(far char *name, char *mode);
/* Open a file returning the explicit filename as well */
extern FILE __LIB__ *zfdopen_z88(far char *name, char *mode, char *explicit, size_t len);

/* fclose() here is the same as close() in fcntl */
#define fclose(f) close((int)f)

#define fgets(a,b,c) fdfgets(a,b,c)
extern char __LIB__ *fdfgets(char *, int, FILE *);
#define fputc(a,b) fdfputc(a,b)
extern __LIB__ fdfputc(int , FILE *);
#define fgetc(a,b) fdfgetc(a,b)
extern int __LIB__ fdfgetc(FILE *);
#define fputs(a,b) fdfputs(a,b)
extern __LIB__ fdfputs(unsigned char *, FILE *);
#define feof(a) fdfeof(a)
extern __LIB__ fdfeof(FILE *);
#define ftell(a) fdtell(a)
extern long __LIB__ fdtell(FILE *);
#define fgetpos(a,b) fdgetpos(a,b)
extern int __LIB__ fdgetpos(FILE *,fpos_t *);

/* These two returns are non-standard and return # of bytes read/written*/
#define fread(a,b,c,d) fdfread(a,b,c,d)
extern int __LIB__ fdfread(void *, int, int, FILE *);
#define fwrite(a,b,c,d) fdfwrite(a,b,c,d)
extern int __LIB__ fdfwrite(void *, int, int, FILE *);

/* Non-standard return values */
#define fsetpos(fp,pos) lseek(fp,pos,SEEK_SET)
#define fseek(fp,pos,whence) lseek(fp,pos,whence)

/* Our streams are unbuffered ATM */

#define fflush(a)


/* gets is a macro, this may change in the future!! */
/* This is non-standard once more! Takes length, but ANSI says it
 * shouldn't
 */

#ifdef SPECTRUM
extern int __LIB__ gets(unsigned char *, int);
#else
#define gets(s,n) fgets(s,n,stdin)
#endif

/* slightly more streamline putc now! */

#define putc(c) putc_cons(c)

#define printn(a,b,c) fdprintn(a,b,c)
extern __LIB__ fdprintn(int number, int radix,FILE *file);

/* Same as for other library */
extern int __LIB__ remove(far char *);
extern int __LIB__ rename(char *, char *);

#define printf printk
extern void __LIB__ printk(char *fmt,...);


/* Keyboard operations */

extern char __LIB__ getk(void);
#define getchar() fgetc_cons()
#define getkey() fgetc_cons()
#define getc() fgetc_cons()
extern char __LIB__ fgetc_cons(void);

/* Screen operations */

#define putchar(x) fputc_cons(x)
extern __LIB__ fputc_cons(char);

extern __LIB__ putn(int);
#define puts(a) fdputs(a)
extern __LIB__ fdputs(char *);
extern __LIB__ settxy(int, int);

/*
 * These functions are used for printf etc - don't use them yourself!
 */

#ifndef DEF_GETARG
#define DEF_GETARG
extern int __LIB__ getarg(void);
#endif

/*
 * Used by fread() and fwrite() to check the handle
 */
extern int __LIB__ fchkhdl(FILE *);


#endif /* Z88STDIO_H */

