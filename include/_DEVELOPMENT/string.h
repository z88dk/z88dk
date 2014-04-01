
#ifndef _STRING_H
#define _STRING_H

#include <_DEVELOPMENT/stddef.h>

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

extern char   *_memlwr(void *p, size_t n);
extern char   *_memstrcpy(void *p, char *s, size_t n);
extern char   *_memupr(void *p, size_t n);
extern char   *_strrstrip(char *s);
extern int     ffs(int i);
extern int     ffsl(long i);
extern void   *memccpy(void *dst, void *src, int c, size_t n);
extern void   *memchr(void *s, int c, size_t n);
extern int     memcmp(void *s1, void *s2, size_t n);
extern void   *memcpy(void *dst, void *src, size_t n);
extern void   *memmem(void *haystack, size_t haystack_len, void *needle, size_t needle_len);
extern void   *memmove(void *dst, void *src, size_t n);
extern void   *memrchr(void *s, int c, size_t n);
extern void   *memset(void *s, int c, size_t n);
extern void   *memswap(void *s1, void *s2, size_t n);
extern char   *stpcpy(char *dst, char *src);
extern char   *stpncpy(char *dst, char *src, size_t n);
extern int     strcasecmp(char *s1, char *s2);
extern char   *strcat(char *dst, char *src);
extern char   *strchr(char *s, int c);
extern char   *strchrnul(char *s, int c);
extern int     strcmp(char *s1, char *s2);
extern int     strcoll(char *s1, char *s2);
extern char   *strcpy(char *dst, char *src);
extern size_t  strcspn(char *s, char *nspn);
extern char   *strdup(char *s);
extern char   *strerror(int errnum);
extern int     stricmp(char *s1, char *s2);
extern size_t  strlcat(char *dst, char *src, size_t n);
extern size_t  strlcpy(char *dst, char *src, size_t n);
extern size_t  strlen(char *s);
extern char    strlwr(char *s);
extern int     strncasecmp(char *s1, char *s2, size_t n);
extern char   *strncat(char *dst, char *src, size_t n);
extern char   *strnchr(char *s, size_t n, int c);
extern int     strncmp(char *s1, char *s2, size_t n);
extern char   *strncpy(char *dst, char *src, size_t n);
extern char   *strndup(char *s, size_t n);
extern int     strnicmp(char *s1, char *s2, size_t n);
extern size_t  strnlen(char *s, size_t max_len);
extern char    strpbrk(char *s, char *set);
extern char   *strrchr(char *s, int c);
extern size_t  strrcspn(char *s, char *set);
extern char   *strrev(char *s);
extern size_t  strrspn(char *s, char *set);
extern char   *strrstrip(char *s);
extern char   *strsep(char **s, char *delim);
extern size_t  strspn(char *s, char *pfx);
extern char   *strstr(char *s, char *subs);
extern char   *strstrip(char *s);
extern char   *strtok(char *s, char *delim);
extern char   *strtok_r(char *s, char *delim, char **last_s);
extern char    strupr(char *s);
extern size_t  strxfrm(char *dst, char *src, size_t n);

#else

// SCCZ80 

extern char   __LIB__               *_memlwr(void *p, size_t n);
extern char   __LIB__               *_memstrcpy(void *p, char *s, size_t n);
extern char   __LIB__               *_memupr(void *p, size_t n);
extern char   __LIB__ __FASTCALL__  *_strrstrip(char *s);
extern int    __LIB__ __FASTCALL__   ffs(int i);
extern int    __LIB__ __FASTCALL__   ffsl(long i);
extern void   __LIB__               *memccpy(void *dst, void *src, int c, size_t n);
extern void   __LIB__               *memchr(void *s, int c, size_t n);
extern int    __LIB__                memcmp(void *s1, void *s2, size_t n);
extern void   __LIB__               *memcpy(void *dst, void *src, size_t n);
extern void   __LIB__               *memmem(void *haystack, size_t haystack_len, void *needle, size_t needle_len);
extern void   __LIB__               *memmove(void *dst, void *src, size_t n);
extern void   __LIB__               *memrchr(void *s, int c, size_t n);
extern void   __LIB__               *memset(void *s, int c, size_t n);
extern void   __LIB__               *memswap(void *s1, void *s2, size_t n);
extern char   __LIB__               *stpcpy(char *dst, char *src);
extern char   __LIB__               *stpncpy(char *dst, char *src, size_t n);
extern int    __LIB__                strcasecmp(char *s1, char *s2);
extern char   __LIB__               *strcat(char *dst, char *src);
extern char   __LIB__               *strchr(char *s, int c);
extern char   __LIB__               *strchrnul(char *s, int c);
extern int    __LIB__                strcmp(char *s1, char *s2);
extern int    __LIB__                strcoll(char *s1, char *s2);
extern char   __LIB__               *strcpy(char *dst, char *src);
extern size_t __LIB__                strcspn(char *s, char *nspn);
extern char   __LIB__  __FASTCALL__ *strdup(char *s);
extern char   __LIB__  __FASTCALL__ *strerror(int errnum);
extern int    __LIB__                stricmp(char *s1, char *s2);
extern size_t __LIB__                strlcat(char *dst, char *src, size_t n);
extern size_t __LIB__                strlcpy(char *dst, char *src, size_t n);
extern size_t __LIB__  __FASTCALL__  strlen(char *s);
extern char   __LIB__  __FASTCALL__  strlwr(char *s);
extern int    __LIB__                strncasecmp(char *s1, char *s2, size_t n);
extern char   __LIB__               *strncat(char *dst, char *src, size_t n);
extern char   __LIB__               *strnchr(char *s, size_t n, int c);
extern int    __LIB__                strncmp(char *s1, char *s2, size_t n);
extern char   __LIB__               *strncpy(char *dst, char *src, size_t n);
extern char   __LIB__               *strndup(char *s, size_t n);
extern int    __LIB__                strnicmp(char *s1, char *s2, size_t n);
extern size_t __LIB__                strnlen(char *s, size_t max_len);
extern char   __LIB__                strpbrk(char *s, char *set);
extern char   __LIB__               *strrchr(char *s, int c);
extern size_t __LIB__                strrcspn(char *s, char *set);
extern char   __LIB__  __FASTCALL__ *strrev(char *s);
extern size_t __LIB__                strrspn(char *s, char *set);
extern char   __LIB__  __FASTCALL__ *strrstrip(char *s);
extern char   __LIB__               *strsep(char **s, char *delim);
extern size_t __LIB__                strspn(char *s, char *pfx);
extern char   __LIB__               *strstr(char *s, char *subs);
extern char   __LIB__  __FASTCALL__ *strstrip(char *s);
extern char   __LIB__               *strtok(char *s, char *delim);
extern char   __LIB__               *strtok_r(char *s, char *delim, char **last_s);
extern char   __LIB__  __FASTCALL__  strupr(char *s);
extern size_t __LIB__                strxfrm(char *dst, char *src, size_t n);

// SCCZ80 CALLEE LINKAGE

extern char   __LIB__ __CALLEE__    *_memlwr_callee(void *p, size_t n);
extern char   __LIB__ __CALLEE__    *_memstrcpy_callee(void *p, char *s, size_t n);
extern char   __LIB__ __CALLEE__    *_memupr_callee(void *p, size_t n);
extern void   __LIB__ __CALLEE__    *memccpy_callee(void *dst, void *src, int c, size_t n);
extern void   __LIB__ __CALLEE__    *memchr_callee(void *s, int c, size_t n);
extern int    __LIB__ __CALLEE__     memcmp_callee(void *s1, void *s2, size_t n);
extern void   __LIB__ __CALLEE__    *memcpy_callee(void *dst, void *src, size_t n);
extern void   __LIB__ __CALLEE__    *memmem_callee(void *haystack, size_t haystack_len, void *needle, size_t needle_len);
extern void   __LIB__ __CALLEE__    *memmove_callee(void *dst, void *src, size_t n);
extern void   __LIB__ __CALLEE__    *memrchr_callee(void *s, int c, size_t n);
extern void   __LIB__ __CALLEE__    *memset_callee(void *s, int c, size_t n);
extern void   __LIB__ __CALLEE__    *memswap_callee(void *s1, void *s2, size_t n);
extern char   __LIB__ __CALLEE__    *stpcpy_callee(char *dst, char *src);
extern char   __LIB__ __CALLEE__    *stpncpy_callee(char *dst, char *src, size_t n);
extern int    __LIB__ __CALLEE__     strcasecmp_callee(char *s1, char *s2);
extern char   __LIB__ __CALLEE__    *strcat_callee(char *dst, char *src);
extern char   __LIB__ __CALLEE__    *strchr_callee(char *s, int c);
extern char   __LIB__ __CALLEE__    *strchrnul_callee(char *s, int c);
extern int    __LIB__ __CALLEE__     strcmp_callee(char *s1, char *s2);
extern int    __LIB__ __CALLEE__     strcoll_callee(char *s1, char *s2);
extern char   __LIB__ __CALLEE__    *strcpy_callee(char *dst, char *src);
extern size_t __LIB__ __CALLEE__     strcspn_callee(char *s, char *nspn);
extern int    __LIB__ __CALLEE__     stricmp_callee(char *s1, char *s2);
extern size_t __LIB__ __CALLEE__     strlcat_callee(char *dst, char *src, size_t n);
extern size_t __LIB__ __CALLEE__     strlcpy_callee(char *dst, char *src, size_t n);
extern int    __LIB__ __CALLEE__     strncasecmp_callee(char *s1, char *s2, size_t n);
extern char   __LIB__ __CALLEE__    *strncat_callee(char *dst, char *src, size_t n);
extern char   __LIB__ __CALLEE__    *strnchr_callee(char *s, size_t n, int c);
extern int    __LIB__ __CALLEE__     strncmp_callee(char *s1, char *s2, size_t n);
extern char   __LIB__ __CALLEE__    *strncpy_callee(char *dst, char *src, size_t n);
extern char   __LIB__ __CALLEE__    *strndup_callee(char *s, size_t n);
extern int    __LIB__ __CALLEE__     strnicmp_callee(char *s1, char *s2, size_t n);
extern size_t __LIB__ __CALLEE__     strnlen_callee(char *s, size_t max_len);
extern char   __LIB__ __CALLEE__     strpbrk_callee(char *s, char *set);
extern char   __LIB__ __CALLEE__    *strrchr_callee(char *s, int c);
extern size_t __LIB__ __CALLEE__     strrcspn_callee(char *s, char *set);
extern size_t __LIB__ __CALLEE__     strrspn_callee(char *s, char *set);
extern char   __LIB__ __CALLEE__    *strsep_callee(char **s, char *delim);
extern size_t __LIB__ __CALLEE__     strspn_callee(char *s, char *pfx);
extern char   __LIB__ __CALLEE__    *strstr_callee(char *s, char *subs);
extern char   __LIB__ __CALLEE__    *strtok_callee(char *s, char *delim);
extern char   __LIB__ __CALLEE__    *strtok_r_callee(char *s, char *delim, char **last_s);
extern size_t __LIB__ __CALLEE__     strxfrm_callee(char *dst, char *src, size_t n);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

#define _memlwr(a,b)                 _memlwr_callee(a,b)
#define _memstrcpy(a,b,c)            _memstrcpy_callee(a,b,c)
#define _memupr(a,b)                 _memupr_callee(a,b)
#define memccpy(a,b,c,d)             memccpy_callee(a,b,c,d)
#define memchr(a,b,c)                memchr_callee(a,b,c)
#define memcmp(a,b,c)                memcmp_callee(a,b,c)
#define memcpy(a,b,c)                memcpy_callee(a,b,c)
#define memmem(a,b,c,d)              memmem_callee(a,b,c,d)
#define memmove(a,b,c)               memmove_callee(a,b,c)
#define memrchr(a,b,c)               memrchr_callee(a,b,c)
#define memset(a,b,c)                memset_callee(a,b,c)
#define memswap(a,b,c)               memswap_callee(a,b,c)
#define stpcpy(a,b)                  stpcpy_callee(a,b)
#define stpncpy(a,b,c)               stpncpy_callee(a,b,c)
#define strcasecmp(a,b)              strcasecmp_callee(a,b)
#define strcat(a,b)                  strcat_callee(a,b)
#define strchr(a,b)                  strchr_callee(a,b)
#define strchrnul(a,b)               strchrnul_callee(a,b)
#define strcmp(a,b)                  strcmp_callee(a,b)
#define strcoll(a,b)                 strcoll_callee(a,b)
#define strcpy(a,b)                  strcpy_callee(a,b)
#define strcspn(a,b)                 strcspn_callee(a,b)
#define stricmp(a,b)                 stricmp_callee(a,b)
#define strlcat(a,b,c)               strlcat_callee(a,b,c)
#define strlcpy(a,b,c)               strlcpy_callee(a,b,c)
#define strncasecmp(a,b,c)           strncasecmp_callee(a,b,c)
#define strncat(a,b,c)               strncat_callee(a,b,c)
#define strnchr(a,b,c)               strnchr_callee(a,b,c)
#define strncmp(a,b,c)               strncmp_callee(a,b,c)
#define strncpy(a,b,c)               strncpy_callee(a,b,c)
#define strndup(a,b)                 strndup_callee(a,b)
#define strnicmp(a,b,c)              strnicmp_callee(a,b,c)
#define strnlen(a,b)                 strnlen_callee(a,b)
#define strpbrk(a,b)                 strpbrk_callee(a,b)
#define strrchr(a,b)                 strrchr_callee(a,b)
#define strrcspn(a,b)                strrcspn_callee(a,b)
#define strrspn(a,b)                 strrspn_callee(a,b)
#define strsep(a,b)                  strsep_callee(a,b)
#define strspn(a,b)                  strspn_callee(a,b)
#define strstr(a,b)                  strstr_callee(a,b)
#define strtok(a,b)                  strtok_callee(a,b)
#define strtok_r(a,b,c)              strtok_r_callee(a,b,c)
#define strxfrm(a,b,c)               strxfrm_callee(a,b,c)

#endif

#endif
