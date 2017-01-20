#ifndef __CTYPE_H__
#define __CTYPE_H__

#include <sys/compiler.h>


extern int __LIB__  isalnum(int) __z88dk_fastcall;
extern int __LIB__  isalpha(int) __z88dk_fastcall;
extern int __LIB__  isascii(int) __z88dk_fastcall;
extern int __LIB__  isbdigit(int) __z88dk_fastcall;
extern int __LIB__  iscntrl(int) __z88dk_fastcall;
extern int __LIB__  isdigit(int) __z88dk_fastcall;
extern int __LIB__  isgraph(int) __z88dk_fastcall;
extern int __LIB__  isupper(int) __z88dk_fastcall;
extern int __LIB__  islower(int) __z88dk_fastcall;
extern int __LIB__  isodigit(int) __z88dk_fastcall;
extern int __LIB__  isoob(int) __z88dk_fastcall;
extern int __LIB__  isprint(int) __z88dk_fastcall;
extern int __LIB__  ispunct(int) __z88dk_fastcall;
extern int __LIB__  isspace(int) __z88dk_fastcall;
extern int __LIB__  isxdigit(int) __z88dk_fastcall;
extern int __LIB__  toascii(int) __z88dk_fastcall;
extern int __LIB__  tolower(int) __z88dk_fastcall;
extern int __LIB__  toupper(int) __z88dk_fastcall;

#define isblank(a) isspace(a)

#endif
