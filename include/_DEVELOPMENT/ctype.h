
#ifndef _CTYPE_H
#define _CTYPE_H

#ifdef __SDCC

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

#ifdef __SDCC_ENABLE_FASTCALL

// SDCC FASTCALL LINKAGE

extern int isalnum_fastcall(int) __z88dk_fastcall;
extern int isalpha_fastcall(int) __z88dk_fastcall;
extern int isascii_fastcall(int) __z88dk_fastcall;
extern int isbdigit_fastcall(int) __z88dk_fastcall;
extern int isblank_fastcall(int) __z88dk_fastcall;
extern int iscntrl_fastcall(int) __z88dk_fastcall;
extern int isdigit_fastcall(int) __z88dk_fastcall;
extern int isgraph_fastcall(int) __z88dk_fastcall;
extern int islower_fastcall(int) __z88dk_fastcall;
extern int isodigit_fastcall(int) __z88dk_fastcall;
extern int isprint_fastcall(int) __z88dk_fastcall;
extern int ispunct_fastcall(int) __z88dk_fastcall;
extern int isspace_fastcall(int) __z88dk_fastcall;
extern int isupper_fastcall(int) __z88dk_fastcall;
extern int isxdigit_fastcall(int) __z88dk_fastcall;
extern int toascii_fastcall(int) __z88dk_fastcall;
extern int tolower_fastcall(int) __z88dk_fastcall;
extern int toupper_fastcall(int) __z88dk_fastcall;

// SDCC MAKE FASTCALL LINKAGE THE DEFAULT

#define isalnum(a)              isalnum_fastcall(a)
#define isalpha(a)              isalpha_fastcall(a)
#define isascii(a)              isascii_fastcall(a)
#define isbdigit(a)             isbdigit_fastcall(a)
#define isblank(a)              isblank_fastcall(a)
#define iscntrl(a)              iscntrl_fastcall(a)
#define isdigit(a)              isdigit_fastcall(a)
#define isgraph(a)              isgraph_fastcall(a)
#define islower(a)              islower_fastcall(a)
#define isodigit(a)             isodigit_fastcall(a)
#define isprint(a)              isprint_fastcall(a)
#define ispunct(a)              ispunct_fastcall(a)
#define isspace(a)              isspace_fastcall(a)
#define isupper(a)              isupper_fastcall(a)
#define isxdigit(a)             isxdigit_fastcall(a)
#define toascii(a)              toascii_fastcall(a)
#define tolower(a)              tolower_fastcall(a)
#define toupper(a)              toupper_fastcall(a)

#endif

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
