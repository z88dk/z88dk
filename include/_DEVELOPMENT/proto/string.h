include(__link__.m4)

#ifndef _STRING_H
#define _STRING_H

#include <stddef.h>

#ifndef _SIZE_T_DEFINED
#define _SIZE_T_DEFINED
typedef unsigned int  size_t;
#endif

#ifndef NULL
#define NULL            ((void*)(0))
#endif

__DPROTO(,,int,,bcmp,const void *b1,const void *b2,size_t len)
__DPROTO(,,void,,bcopy,const void *src,void *dst,size_t len)
__DPROTO(,,void,,bzero,void *mem,size_t n)
__DPROTO(`d,e',`d,e',char,*,index,const char *s,int c)
__DPROTO(`d',`d',char,*,rindex,const char *s,int c)
__DPROTO(`b,c',`b,c',char,*,strset,char *s,int c)
__DPROTO(,,char,*,strnset,char *s,int c,size_t n)
__DPROTO(`d,e',`d,e',void,*,rawmemchr,const void *mem,int c)

__DPROTO(`d,e',`d,e',char,*,_memlwr_,void *p,size_t n)
__DPROTO(,,char,*,_memstrcpy_,void *p,const char *s,size_t n)
__DPROTO(`d,e',`d,e',char,*,_memupr_,void *p,size_t n)
__DPROTO(,,char,*,_strrstrip_,char *s)
__DPROTO(`b,c,d,e',`b,c,d,e',int,,ffs,int i)
__DPROTO(`b,c,d,e',`b,c',int,,ffsl,long i)
__DPROTO(,,void,*,memccpy,void *dst,const void *src,int c,size_t n)
__DPROTO(,,void,*,memchr,const void *s,int c,size_t n)
__DPROTO(,,int,,memcmp,const void *s1,const void *s2,size_t n)
__DPROTO(,,void,*,memcpy,void *dst,const void *src,size_t n)
__DPROTO(,,void,*,memmem,const void *haystack,size_t haystack_len,const void *needle,size_t needle_len)
__DPROTO(,,void,*,memmove,void *dst,const void *src,size_t n)
__DPROTO(,,void,*,memrchr,const void *s,int c,size_t n)
__DPROTO(,,void,*,memset,void *s,int c,size_t n)
__DPROTO(,,void,*,memswap,void *s1,void *s2,size_t n)
__DPROTO(,,char,*,stpcpy,char *dst,const char *src)
__DPROTO(,,char,*,stpncpy,char *dst,const char *src,size_t n)
__DPROTO(`b',`b',int,,strcasecmp,const char *s1,const char *s2)
__DPROTO(,,char,*,strcat,char *dst,const char *src)
__DPROTO(`d,e',`d,e',char,*,strchr,const char *s,int c)
__DPROTO(`d,e',`d,e',char,*,strchrnul,const char *s,int c)
__DPROTO(,,int,,strcmp,const char *s1,const char *s2)
__DPROTO(,,int,,strcoll,const char *s1,const char *s2)
__DPROTO(,,char,*,strcpy,char *dst,const char *src)
__DPROTO(,,size_t,,strcspn,const char *s,const char *nspn)
__DPROTO(,,char,*,strdup,const char *s)
__DPROTO(`d',`d',char,*,strerror,int errnum)
__DPROTO(`b',`b',int,,stricmp,const char *s1,const char *s2)
__DPROTO(,,size_t,,strlcat,char *dst,const char *src,size_t n)
__DPROTO(,,size_t,,strlcpy,char *dst,const char *src,size_t n)
__DPROTO(`d,e',`d,e',size_t,,strlen,const char *s)
__DPROTO(`b,c,d,e,h,l',`b,c,d,e',char,*,strlwr,char *s)
__DPROTO(,,int,,strncasecmp,const char *s1,const char *s2,size_t n)
__DPROTO(,,char,*,strncat,char *dst,const char *src,size_t n)
__DPROTO(,,char,*,strnchr,const char *s,size_t n,int c)
__DPROTO(,,int,,strncmp,const char *s1,const char *s2,size_t n)
__DPROTO(,,char,*,strncpy,char *dst,const char *src,size_t n)
__DPROTO(,,char,*,strndup,const char *s,size_t n)
__DPROTO(,,int,,strnicmp,const char *s1,const char *s2,size_t n)
__DPROTO(,,size_t,,strnlen,const char *s,size_t max_len)
__DPROTO(`b',`b',char,,strpbrk,const char *s,const char *set)
__DPROTO(`d',`d',char,*,strrchr,const char *s,int c)
__DPROTO(,,size_t,,strrcspn,const char *s,const char *set)
__DPROTO(`h,l',,char,*,strrev,char *s)
__DPROTO(,,size_t,,strrspn,const char *s,const char *set)
__DPROTO(`h,l',,char,*,strrstrip,char *s)
__DPROTO(,,char,*,strsep,char **s,const char *delim)
__DPROTO(,,size_t,,strspn,const char *s,const char *pfx)
__DPROTO(`b,c',`b,c',char,*,strstr,const char *s,const char *subs)
__DPROTO(`b,c,d,e',`b,c,d,e',char,*,strstrip,char *s)
__DPROTO(,,char,*,strtok,char *s,const char *delim)
__DPROTO(,,char,*,strtok_r,char *s,const char *delim,char **last_s)
__DPROTO(`b,c,d,e,h,l',`b,c,d,e',char,*,strupr,char *s)
__DPROTO(,,size_t,,strxfrm,char *dst,const char *src,size_t n)

#ifdef __CLANG

   extern int ffsll(long long i);
   
#endif

#ifdef __SDCC

   extern int ffsll(long long i) __preserves_regs(b,c);
   extern int ffsll_callee(long long i) __preserves_regs(b,c) __z88dk_callee;
   #define ffsll(a) ffsll_callee(a)

   #ifndef __SDCC_DISABLE_BUILTIN

   #undef memcpy
   #undef strcpy
   #undef strncpy
   #undef strchr
   #undef memset

   #define memcpy(dst, src, n)          __builtin_memcpy(dst, src, n)
   #define strcpy(dst, src)             __builtin_strcpy(dst, src)
   #define strncpy(dst, src, n)         __builtin_strncpy(dst, src, n)
   #define strchr(s, c)                 __builtin_strchr(s, c)
   #define memset(dst, c, n)            __builtin_memset(dst, c, n)

   #endif

#endif

#endif
