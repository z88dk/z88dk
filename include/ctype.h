#ifndef __CTYPE_H__
#define __CTYPE_H__

#include <sys/compiler.h>


extern int __LIB__ isalnum(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isalnum_fastcall(int) __z88dk_fastcall;
#define isalnum(a) isalnum_fastcall(a)
#endif


extern int __LIB__ isalpha(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isalpha_fastcall(int) __z88dk_fastcall;
#define isalpha(a) isalpha_fastcall(a)
#endif


extern int __LIB__ isascii(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isascii_fastcall(int) __z88dk_fastcall;
#define isascii(a) isascii_fastcall(a)
#endif


extern int __LIB__ isbdigit(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isbdigit_fastcall(int) __z88dk_fastcall;
#define isbdigit(a) isbdigit_fastcall(a)
#endif


extern int __LIB__ isblank(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isblank_fastcall(int) __z88dk_fastcall;
#define isblank(a) isblank_fastcall(a)
#endif


extern int __LIB__ iscntrl(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int iscntrl_fastcall(int) __z88dk_fastcall;
#define iscntrl(a) iscntrl_fastcall(a)
#endif


extern int __LIB__ isdigit(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isdigit_fastcall(int) __z88dk_fastcall;
#define isdigit(a) isdigit_fastcall(a)
#endif


extern int __LIB__ isgraph(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isgraph_fastcall(int) __z88dk_fastcall;
#define isgraph(a) isgraph_fastcall(a)
#endif


extern int __LIB__ islower(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int islower_fastcall(int) __z88dk_fastcall;
#define islower(a) islower_fastcall(a)
#endif


extern int __LIB__ isodigit(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isodigit_fastcall(int) __z88dk_fastcall;
#define isodigit(a) isodigit_fastcall(a)
#endif


extern int __LIB__ isprint(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isprint_fastcall(int) __z88dk_fastcall;
#define isprint(a) isprint_fastcall(a)
#endif


extern int __LIB__ ispunct(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int ispunct_fastcall(int) __z88dk_fastcall;
#define ispunct(a) ispunct_fastcall(a)
#endif


extern int __LIB__ isspace(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isspace_fastcall(int) __z88dk_fastcall;
#define isspace(a) isspace_fastcall(a)
#endif


extern int __LIB__ isupper(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isupper_fastcall(int) __z88dk_fastcall;
#define isupper(a) isupper_fastcall(a)
#endif


extern int __LIB__ isxdigit(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int isxdigit_fastcall(int) __z88dk_fastcall;
#define isxdigit(a) isxdigit_fastcall(a)
#endif


extern int __LIB__ toascii(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int toascii_fastcall(int) __z88dk_fastcall;
#define toascii(a) toascii_fastcall(a)
#endif


extern int __LIB__ tolower(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int tolower_fastcall(int) __z88dk_fastcall;
#define tolower(a) tolower_fastcall(a)
#endif


extern int __LIB__ toupper(int) __smallc ;
#ifndef __STDC_ABI_ONLY
extern int toupper_fastcall(int) __z88dk_fastcall;
#define toupper(a) toupper_fastcall(a)
#endif

#endif
