
#ifndef _CTYPE_H
#define _CTYPE_H

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern int isalnum(int);
extern int isalpha(int);
extern int isascii(int);
extern int isbdigit(int);
extern int isblank(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isodigit(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int toascii(int);
extern int tolower(int);
extern int toupper(int);

#else

// SCCZ80

extern int __LIB__ __FASTCALL__ isalnum(int);
extern int __LIB__ __FASTCALL__ isalpha(int);
extern int __LIB__ __FASTCALL__ isascii(int);
extern int __LIB__ __FASTCALL__ isbdigit(int);
extern int __LIB__ __FASTCALL__ isblank(int);
extern int __LIB__ __FASTCALL__ iscntrl(int);
extern int __LIB__ __FASTCALL__ isdigit(int);
extern int __LIB__ __FASTCALL__ isgraph(int);
extern int __LIB__ __FASTCALL__ islower(int);
extern int __LIB__ __FASTCALL__ isodigit(int);
extern int __LIB__ __FASTCALL__ isprint(int);
extern int __LIB__ __FASTCALL__ ispunct(int);
extern int __LIB__ __FASTCALL__ isspace(int);
extern int __LIB__ __FASTCALL__ isupper(int);
extern int __LIB__ __FASTCALL__ isxdigit(int);
extern int __LIB__ __FASTCALL__ toascii(int);
extern int __LIB__ __FASTCALL__ tolower(int);
extern int __LIB__ __FASTCALL__ toupper(int);

#endif

#endif
