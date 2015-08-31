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

__DPROTO(int,,bcmp,void *b1,void *b2,size_t len)
__DPROTO(void,,bcopy,const void *src,void *dst,size_t len)
__DPROTO(void,,bzero,void *mem,size_t n)
__DPROTO(char,*,index,char *s,int c)
__DPROTO(char,*,rindex,char *s,int c)
__DPROTO(char,*,strset,char *s,int c)
__DPROTO(char,*,strnset,char *s,int c,size_t n)
__DPROTO(void,*,rawmemchr,const void *mem,int c)

__DPROTO(char,*,_memlwr_,void *p,size_t n)
__DPROTO(char,*,_memstrcpy_,void *p,char *s,size_t n)
__DPROTO(char,*,_memupr_,void *p,size_t n)
__DPROTO(char,*,_strrstrip_,char *s)
__DPROTO(int,,ffs,int i)
__DPROTO(int,,ffsl,long i)
__DPROTO(void,*,memccpy,void *dst,void *src,int c,size_t n)
__DPROTO(void,*,memchr,void *s,int c,size_t n)
__DPROTO(int,,memcmp,void *s1,void *s2,size_t n)
__DPROTO(void,*,memcpy,void *dst,void *src,size_t n)
__DPROTO(void,*,memmem,void *haystack,size_t haystack_len,void *needle,size_t needle_len)
__DPROTO(void,*,memmove,void *dst,void *src,size_t n)
__DPROTO(void,*,memrchr,void *s,int c,size_t n)
__DPROTO(void,*,memset,void *s,int c,size_t n)
__DPROTO(void,*,memswap,void *s1,void *s2,size_t n)
__DPROTO(char,*,stpcpy,char *dst,char *src)
__DPROTO(char,*,stpncpy,char *dst,char *src,size_t n)
__DPROTO(int,,strcasecmp,char *s1,char *s2)
__DPROTO(char,*,strcat,char *dst,char *src)
__DPROTO(char,*,strchr,char *s,int c)
__DPROTO(char,*,strchrnul,char *s,int c)
__DPROTO(int,,strcmp,char *s1,char *s2)
__DPROTO(int,,strcoll,char *s1,char *s2)
__DPROTO(char,*,strcpy,char *dst,char *src)
__DPROTO(size_t,,strcspn,char *s,char *nspn)
__DPROTO(char,*,strdup,char *s)
__DPROTO(char,*,strerror,int errnum)
__DPROTO(int,,stricmp,char *s1,char *s2)
__DPROTO(size_t,,strlcat,char *dst,char *src,size_t n)
__DPROTO(size_t,,strlcpy,char *dst,char *src,size_t n)
__DPROTO(size_t,,strlen,char *s)
__DPROTO(char,*,strlwr,char *s)
__DPROTO(int,,strncasecmp,char *s1,char *s2,size_t n)
__DPROTO(char,*,strncat,char *dst,char *src,size_t n)
__DPROTO(char,*,strnchr,char *s,size_t n,int c)
__DPROTO(int,,strncmp,char *s1,char *s2,size_t n)
__DPROTO(char,*,strncpy,char *dst,char *src,size_t n)
__DPROTO(char,*,strndup,char *s,size_t n)
__DPROTO(int,,strnicmp,char *s1,char *s2,size_t n)
__DPROTO(size_t,,strnlen,char *s,size_t max_len)
__DPROTO(char,,strpbrk,char *s,char *set)
__DPROTO(char,*,strrchr,char *s,int c)
__DPROTO(size_t,,strrcspn,char *s,char *set)
__DPROTO(char,*,strrev,char *s)
__DPROTO(size_t,,strrspn,char *s,char *set)
__DPROTO(char,*,strrstrip,char *s)
__DPROTO(char,*,strsep,char **s,char *delim)
__DPROTO(size_t,,strspn,char *s,char *pfx)
__DPROTO(char,*,strstr,char *s,char *subs)
__DPROTO(char,*,strstrip,char *s)
__DPROTO(char,*,strtok,char *s,char *delim)
__DPROTO(char,*,strtok_r,char *s,char *delim,char **last_s)
__DPROTO(char,*,strupr,char *s)
__DPROTO(size_t,,strxfrm,char *dst,char *src,size_t n)

#ifdef __SDCC

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
