#ifndef __STRING_H__
#define __STRING_H__

#include <sys/compiler.h>
#include <sys/types.h>

extern int __LIB__ bcmp(const void *b1,const void *b2,size_t len) __smallc;
extern int __LIB__ bcmp_callee(const void *b1,const void *b2,size_t len) __smallc __z88dk_callee;
#define bcmp(a,b,c) bcmp_callee(a,b,c)


extern void __LIB__ bcopy(const void *src,void *dst,size_t len) __smallc;
#if !__GBZ80__
extern void __LIB__ bcopy_callee(const void *src,void *dst,size_t len) __smallc __z88dk_callee; 
#define bcopy(a,b,c) bcopy_callee(a,b,c)
#endif


extern void __LIB__ bzero(void *mem,size_t n) __smallc;
extern void __LIB__ bzero_callee(void *mem,size_t n) __smallc __z88dk_callee;
#define bzero(a,b) bzero_callee(a,b)


extern char __LIB__ *index(const char *s,int c) __smallc;
extern char __LIB__ *index_callee(const char *s,int c) __smallc __z88dk_callee;
#define index(a,b) index_callee(a,b)


extern char __LIB__ *rindex(const char *s,int c) __smallc;
extern char __LIB__ *rindex_callee(const char *s,int c) __smallc __z88dk_callee;
#define rindex(a,b) rindex_callee(a,b)


extern char __LIB__ *strset(char *s,int c) __smallc;
extern char __LIB__ *strset_callee(char *s,int c) __smallc __z88dk_callee;
#define strset(a,b) strset_callee(a,b)


extern char __LIB__ *strnset(char *s,int c,size_t n) __smallc;
#if !__GBZ80__
extern char __LIB__ *strnset_callee(char *s,int c,size_t n) __smallc __z88dk_callee;
#define strnset(a,b,c) strnset_callee(a,b,c)
#endif


extern void __LIB__ *rawmemchr(const void *mem,int c) __smallc;
extern void __LIB__ *rawmemchr_callee(const void *mem,int c) __smallc __z88dk_callee;
#define rawmemchr(a,b) rawmemchr_callee(a,b)



extern char __LIB__ *_memlwr_(void *p,size_t n) __smallc;
extern char __LIB__ *_memlwr__callee(void *p,size_t n) __smallc __z88dk_callee;
#define _memlwr_(a,b) _memlwr__callee(a,b)


extern char __LIB__ *_memstrcpy_(void *p,const char *s,size_t n) __smallc;
#if !__GBZ80__
extern char __LIB__ *_memstrcpy__callee(void *p,const char *s,size_t n) __smallc __z88dk_callee;
#define _memstrcpy_(a,b,c) _memstrcpy__callee(a,b,c)
#endif


extern char __LIB__ *_memupr_(void *p,size_t n) __smallc;
extern char __LIB__ *_memupr__callee(void *p,size_t n) __smallc __z88dk_callee;
#define _memupr_(a,b) _memupr__callee(a,b)


extern char __LIB__  *_strrstrip_(char *s) __smallc __z88dk_callee __z88dk_fastcall;


extern int __LIB__  ffs(int i) __smallc __z88dk_callee __z88dk_fastcall;


extern int __LIB__  ffsl(long i) __smallc __z88dk_callee __z88dk_fastcall;


extern void __LIB__ *memccpy(void *dst,const void *src,int c,size_t n) __smallc;
extern void __LIB__ *memccpy_callee(void *dst,const void *src,int c,size_t n) __smallc __z88dk_callee;
#define memccpy(a,b,c,d) memccpy_callee(a,b,c,d)


extern void __LIB__ *memchr(const void *s,int c,size_t n) __smallc;
#if !__GBZ80__
extern void __LIB__ *memchr_callee(const void *s,int c,size_t n) __smallc __z88dk_callee;
#define memchr(a,b,c) memchr_callee(a,b,c)
#endif


extern int __LIB__ memcmp(const void *s1,const void *s2,size_t n) __smallc;
#if !__GBZ80__
extern int __LIB__ memcmp_callee(const void *s1,const void *s2,size_t n) __smallc __z88dk_callee;
#define memcmp(a,b,c) memcmp_callee(a,b,c)
#endif


extern void __LIB__ *memcpy(void *dst,const void *src,size_t n) __smallc;
#if !__GBZ80__
extern void __LIB__ *memcpy_callee(void *dst,const void *src,size_t n) __smallc __z88dk_callee;
#define memcpy(a,b,c) memcpy_callee(a,b,c)
#endif

#if !__GBZ80__ && !__8080__ && !__8085__
extern void __LIB__ *memmem(const void *haystack,size_t haystack_len,const void *needle,size_t needle_len) __smallc;
extern void __LIB__ *memmem_callee(const void *haystack,size_t haystack_len,const void *needle,size_t needle_len) __smallc __z88dk_callee;
#define memmem(a,b,c,d) memmem_callee(a,b,c,d)
#endif

extern void __LIB__ *memmove(void *dst,const void *src,size_t n) __smallc;
#if !__GBZ80__
extern void __LIB__ *memmove_callee(void *dst,const void *src,size_t n) __smallc __z88dk_callee;
#define memmove(a,b,c) memmove_callee(a,b,c)
#endif


extern void __LIB__ *memrchr(const void *s,int c,size_t n) __smallc;
#if !__GBZ80__
extern void __LIB__ *memrchr_callee(const void *s,int c,size_t n) __smallc __z88dk_callee;
#define memrchr(a,b,c) memrchr_callee(a,b,c)
#endif


extern void __LIB__ *memset(void *s,int c,size_t n) __smallc;
#if !__GBZ80__
extern void __LIB__ *memset_callee(void *s,int c,size_t n) __smallc __z88dk_callee;
#define memset(a,b,c) memset_callee(a,b,c)
#endif

/* memset_wr() is less optimised than memset (in Z80), but should be used when the
 * area being cleared can't be read (eg VRAM in certain machines).
 * for INTEL / GBZ80 it is faster than memset().
 */
extern void __LIB__ *memset_wr(volatile void *s,int c,size_t n) __smallc;
#if !__GBZ80__
extern void __LIB__ *memset_wr_callee(volatile void *s,int c,size_t n) __smallc __z88dk_callee;
#define memset_wr(a,b,c) memset_wr_callee(a,b,c)
#endif

extern void __LIB__ *memswap(void *s1,void *s2,size_t n) __smallc;
#if !__GBZ80__
extern void __LIB__ *memswap_callee(void *s1,void *s2,size_t n) __smallc __z88dk_callee;
#define memswap(a,b,c) memswap_callee(a,b,c)
#endif

extern char __LIB__ *stpcpy(char *dst,const char *src) __smallc;
extern char __LIB__ *stpcpy_callee(char *dst,const char *src) __smallc __z88dk_callee;
#define stpcpy(a,b) stpcpy_callee(a,b)


extern char __LIB__ *stpncpy(char *dst,const char *src,size_t n) __smallc;
#if !__GBZ80__
extern char __LIB__ *stpncpy_callee(char *dst,const char *src,size_t n) __smallc __z88dk_callee;
#define stpncpy(a,b,c) stpncpy_callee(a,b,c)
#endif


extern int __LIB__ strcasecmp(const char *s1,const char *s2) __smallc;
extern int __LIB__ strcasecmp_callee(const char *s1,const char *s2) __smallc __z88dk_callee;
#define strcasecmp(a,b) strcasecmp_callee(a,b)


extern char __LIB__ *strcat(char *dst,const char *src) __smallc;
extern char __LIB__ *strcat_callee(char *dst,const char *src) __smallc __z88dk_callee;
#define strcat(a,b) strcat_callee(a,b)


extern char __LIB__ *strchr(const char *s,int c) __smallc;
extern char __LIB__ *strchr_callee(const char *s,int c) __smallc __z88dk_callee;
#define strchr(a,b) strchr_callee(a,b)


extern char __LIB__ *strchrnul(const char *s,int c) __smallc;
extern char __LIB__ *strchrnul_callee(const char *s,int c) __smallc __z88dk_callee;
#define strchrnul(a,b) strchrnul_callee(a,b)


extern int __LIB__ strcmp(const char *s1,const char *s2) __smallc;
extern int __LIB__ strcmp_callee(const char *s1,const char *s2) __smallc __z88dk_callee;
#define strcmp(a,b) strcmp_callee(a,b)


extern int __LIB__ strcoll(const char *s1,const char *s2) __smallc;
extern int __LIB__ strcoll_callee(const char *s1,const char *s2) __smallc __z88dk_callee;
#define strcoll(a,b) strcoll_callee(a,b)


extern char __LIB__ *strcpy(char *dst,const char *src) __smallc;
extern char __LIB__ *strcpy_callee(char *dst,const char *src) __smallc __z88dk_callee;
#define strcpy(a,b) strcpy_callee(a,b)


extern size_t __LIB__ strcspn(const char *s,const char *nspn) __smallc;
extern size_t __LIB__ strcspn_callee(const char *s,const char *nspn) __smallc __z88dk_callee;
#define strcspn(a,b) strcspn_callee(a,b)


extern char __LIB__  *strdup(const char *s) __smallc __z88dk_fastcall;


extern char __LIB__  *strerror(int errnum) __smallc __z88dk_fastcall;


extern int __LIB__ stricmp(const char *s1,const char *s2) __smallc;
extern int __LIB__ stricmp_callee(const char *s1,const char *s2) __smallc __z88dk_callee;
#define stricmp(a,b) stricmp_callee(a,b)


extern size_t __LIB__ strlcat(char *dst,const char *src,size_t n) __smallc;
#if !__GBZ80__
extern size_t __LIB__ strlcat_callee(char *dst,const char *src,size_t n) __smallc __z88dk_callee;
#define strlcat(a,b,c) strlcat_callee(a,b,c)
#endif


extern size_t __LIB__ strlcpy(char *dst,const char *src,size_t n) __smallc;
#if !__GBZ80__
extern size_t __LIB__ strlcpy_callee(char *dst,const char *src,size_t n) __smallc __z88dk_callee;
#define strlcpy(a,b,c) strlcpy_callee(a,b,c)
#endif


extern size_t __LIB__  strlen(const char *s) __smallc __z88dk_fastcall;


extern char __LIB__  *strlwr(char *s) __smallc __z88dk_fastcall;


extern int __LIB__ strncasecmp(const char *s1,const char *s2,size_t n) __smallc;
#if !__GBZ80__
extern int __LIB__ strncasecmp_callee(const char *s1,const char *s2,size_t n) __smallc __z88dk_callee;
#define strncasecmp(a,b,c) strncasecmp_callee(a,b,c)
#endif


extern char __LIB__ *strncat(char *dst,const char *src,size_t n) __smallc;
#if !__GBZ80__
extern char __LIB__ *strncat_callee(char *dst,const char *src,size_t n) __smallc __z88dk_callee;
#define strncat(a,b,c) strncat_callee(a,b,c)
#endif


extern char __LIB__ *strnchr(const char *s,size_t n,int c) __smallc;
#if !__GBZ80__
extern char __LIB__ *strnchr_callee(const char *s,size_t n,int c) __smallc __z88dk_callee;
#define strnchr(a,b,c) strnchr_callee(a,b,c)
#endif


extern int __LIB__ strncmp(const char *s1,const char *s2,size_t n) __smallc;
#if !__GBZ80__
extern int __LIB__ strncmp_callee(const char *s1,const char *s2,size_t n) __smallc __z88dk_callee;
#define strncmp(a,b,c) strncmp_callee(a,b,c)
#endif


extern char __LIB__ *strncpy(char *dst,const char *src,size_t n) __smallc;
#if !__GBZ80__
extern char __LIB__ *strncpy_callee(char *dst,const char *src,size_t n) __smallc __z88dk_callee;
#define strncpy(a,b,c) strncpy_callee(a,b,c)
#endif


extern char __LIB__ *strndup(const char *s,size_t n) __smallc;
extern char __LIB__ *strndup_callee(const char *s,size_t n) __smallc __z88dk_callee;
#define strndup(a,b) strndup_callee(a,b)


extern int __LIB__ strnicmp(const char *s1,const char *s2,size_t n) __smallc;
extern int __LIB__ strnicmp_callee(const char *s1,const char *s2,size_t n) __smallc __z88dk_callee;
#define strnicmp(a,b,c) strnicmp_callee(a,b,c)


extern size_t __LIB__ strnlen(const char *s,size_t max_len) __smallc;
extern size_t __LIB__ strnlen_callee(const char *s,size_t max_len) __smallc __z88dk_callee;
#define strnlen(a,b) strnlen_callee(a,b)


extern char __LIB__ *strpbrk(const char *s,const char *set) __smallc;
extern char __LIB__ *strpbrk_callee(const char *s,const char *set) __smallc __z88dk_callee;
#define strpbrk(a,b) strpbrk_callee(a,b)


extern char __LIB__ *strrchr(const char *s,int c) __smallc;
extern char __LIB__ *strrchr_callee(const char *s,int c) __smallc __z88dk_callee;
#define strrchr(a,b) strrchr_callee(a,b)


extern size_t __LIB__ strrcspn(const char *s,const char *set) __smallc;
extern size_t __LIB__ strrcspn_callee(const char *s,const char *set) __smallc __z88dk_callee;
#define strrcspn(a,b) strrcspn_callee(a,b)


extern char __LIB__  *strrev(char *s) __smallc __z88dk_fastcall;


extern size_t __LIB__ strrspn(const char *s,const char *set) __smallc;
extern size_t __LIB__ strrspn_callee(const char *s,const char *set) __smallc __z88dk_callee;
#define strrspn(a,b) strrspn_callee(a,b)


extern char __LIB__  *strrstrip(char *s) __smallc __z88dk_fastcall;


extern char __LIB__ *strsep(char **s,const char *delim) __smallc;
extern char __LIB__ *strsep_callee(char **s,const char *delim) __smallc __z88dk_callee;
#define strsep(a,b) strsep_callee(a,b)


extern size_t __LIB__ strspn(const char *s,const char *pfx) __smallc;
extern size_t __LIB__ strspn_callee(const char *s,const char *pfx) __smallc __z88dk_callee;
#define strspn(a,b) strspn_callee(a,b)


extern char __LIB__ *strstr(const char *s,const char *subs) __smallc;
extern char __LIB__ *strstr_callee(const char *s,const char *subs) __smallc __z88dk_callee;
#define strstr(a,b) strstr_callee(a,b)


extern char __LIB__  *strstrip(char *s) __smallc __z88dk_fastcall;


extern char __LIB__ *strtok(char *s,const char *delim) __smallc;
extern char __LIB__ *strtok_callee(char *s,const char *delim) __smallc __z88dk_callee;
#define strtok(a,b) strtok_callee(a,b)


extern char __LIB__ *strtok_r(char *s,const char *delim,char **last_s) __smallc;
#if !__GBZ80__
extern char __LIB__ *strtok_r_callee(char *s,const char *delim,char **last_s) __smallc __z88dk_callee;
#define strtok_r(a,b,c) strtok_r_callee(a,b,c)
#endif


extern char __LIB__  *strupr(char *s) __smallc __z88dk_fastcall;


extern size_t __LIB__ strxfrm(char *dst,const char *src,size_t n) __smallc;
#if !__GBZ80__
extern size_t __LIB__ strxfrm_callee(char *dst,const char *src,size_t n) __smallc __z88dk_callee;
#define strxfrm(a,b,c) strxfrm_callee(a,b,c)
#endif

extern char __LIB__    *strrstr(const char *haystack, const char *needle) __smallc;
extern char __LIB__    *strrstr_callee(const char *haystack, const char *needle) __smallc __z88dk_callee;
#define strrstr(a,b)   strrstr_callee(a,b)


extern void __LIB__    *memopi(void *, void *, uint, uint) __smallc;
extern void __LIB__    *memopi_callee(void *, void *, uint, uint) __smallc __z88dk_callee;
#define memopi(a,b,c,d) memopi_callee(a,b,c,d)

extern void __LIB__    *memopd(void *, void *, uint, uint) __smallc;
extern void __LIB__    *memopd_callee(void *, void *, uint, uint) __smallc __z88dk_callee;
#define memopd(a,b,c,d) memopd_callee(a,b,c,d)

/*
 * Now handle far stuff
 */

#ifdef FARDATA

#define strlen(s) strlen_far(s)
extern int __LIB__ strlen_far(far char *);

#undef strcat
#define strcat(s1,s2) strcat_far(s1,s2)
extern far char __LIB__ *strcat_far(far char *, far char *) __smallc;

#undef strcpy
#define strcpy(s1,s2) strcpy_far(s1,s2)
extern far char __LIB__ *strcpy_far(far char *, far char *) __smallc;

#undef strncat
#define strncat(s1,s2) strncat_far(s1,s2,n)
extern far char __LIB__ *strncat_far(far char *, far char *, int) __smallc;

#undef strncpy
#define strncpy(s1,s2) strncpy_far(s1,s2,n)
extern far char __LIB__ *strncpy_far(far char *, far char *, int) __smallc;

#define strlwr(s) strlwr_far(s)
extern far char __LIB__ *strlwr_far(far char *);

#define strupr(s) strupr_far(s)
extern far char __LIB__ *strupr_far(far char *);

#undef strchr
#define strchr(s,c) strchr_far(s1,c)
extern far char __LIB__ *strchr_far(far unsigned char *, unsigned char) __smallc;

#undef strrchr
#define strrchr(s,c) strrchr_far(s1,c)
extern far char __LIB__ *strrchr_far(far unsigned char *, unsigned char) __smallc;

#define strdup(s) strdup_far(s)
extern far char __LIB__ *strdup_far(far char *);

#endif




#ifdef __SCCZ80

   #ifndef __DISABLE_BUILTIN

   #ifndef __DISABLE_BUILTIN_MEMSET
   #undef  memset
   #define memset(a,b,c)   __builtin_memset(a,b,c)
   extern void __LIB__    *__builtin_memset(void *dst, int c, size_t n) __smallc;
   #endif

   #ifndef __DISABLE_BUILTIN_MEMCPY
   #undef  memcpy
   #define memcpy(a,b,c)   __builtin_memcpy(a,b,c)
   extern void __LIB__    *__builtin_memcpy(void *dst, void *src,size_t n) __smallc;
   #endif
   
   #ifndef __DISABLE_BUILTIN_STRCPY
   #undef  strcpy
   #define strcpy(a,b)     __builtin_strcpy(a,b)
   extern char __LIB__    *__builtin_strcpy(char *dst, const char *src) __smallc;
   #endif
   
   #ifndef __DISABLE_BUILTIN_STRCHR
   #undef  strchr
   #define strchr(a,b)     __builtin_strchr(a,b)
   extern char __LIB__    *__builtin_strchr(const char *haystack, int needle) __smallc;
   #endif

   #endif

#endif

#ifdef __SDCC

   extern int ffsll(long long i) __preserves_regs(b,c);
   extern int ffsll_callee(long long i) __preserves_regs(b,c) __z88dk_callee;
   #define ffsll(a) ffsll_callee(a)
   #define __DISABLE_BUILTIN

   #ifndef __DISABLE_BUILTIN

   #ifndef __DISABLE_BUILTIN_MEMCPY
   #undef  memcpy
   #define memcpy(dst, src, n)    __builtin_memcpy(dst, src, n)
   #endif
   
   #ifndef __DISABLE_BUILTIN_STRCPY
   #undef  strcpy
   #define strcpy(dst, src)       __builtin_strcpy(dst, src)
   #endif
   
   #ifndef __DISABLE_BUILTIN_STRNCPY
   #undef  strncpy
   #define strncpy(dst, src, n)   __builtin_strncpy(dst, src, n)
   #endif
   
   #ifndef __DISABLE_BUILTIN_STRCHR
   #undef  strchr
   #define strchr(s, c)           __builtin_strchr(s, c)
   #endif
   
   #ifndef __DISABLE_BUILTIN_MEMSET
   #undef  memset
   #define memset(dst, c, n)      __builtin_memset(dst, c, n)
   #endif

   #endif

#endif

#endif
