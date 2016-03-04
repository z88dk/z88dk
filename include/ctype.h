#ifndef __CTYPE_H__
#define __CTYPE_H__

#include <sys/compiler.h>


extern int __LIB__ __FASTCALL__ isalnum(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isalpha(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isascii(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isbdigit(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ iscntrl(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isdigit(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isgraph(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isupper(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ islower(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isodigit(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isoob(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isprint(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ ispunct(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isspace(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ isxdigit(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ toascii(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ tolower(int) __SMALLCFASTCALL;
extern int __LIB__ __FASTCALL__ toupper(int) __SMALLCFASTCALL;

#define isblank(a) isspace(a)

#endif
