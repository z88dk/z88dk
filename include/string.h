#ifndef __STRING_H__
#define __STRING_H__

#include <sys/compiler.h>
#include <sys/types.h>

// First a list of functions using CALLER and FASTCALL linkage

extern int  __LIB__               strlen(const char *s) __z88dk_fastcall;
extern char __LIB__              *strcat(char *dst, const char *src) __smallc;
extern int  __LIB__               strcmp(const char *s1, const char *s2) __smallc;
extern char __LIB__              *strcpy(char *dst, const char *src) __smallc;
extern char __LIB__              *strncat(char *dst, const char src, size_t n) __smallc;
extern int  __LIB__               strncmp(char *dst, char *src, size_t n) __smallc;
extern char __LIB__              *strncpy(char *dst, char *src, size_t n) __smallc;
extern char __LIB__              *strrev(char *s) __z88dk_fastcall;
extern char __LIB__              *strchr(const char *haystack, int needle) __smallc;
extern char __LIB__              *strchrnul(const char *haystack, int needle) __smallc;
extern char __LIB__              *strrchr(const char *haystack, int needle) __smallc;
extern char __LIB__              *strrstrip(char *, char) __smallc;
extern char __LIB__              *strstrip(char *, uint) __smallc;
extern char __LIB__              *strstr(const char *haystack, const char *needle) __smallc;
extern char __LIB__              *strrstr(const char *haystack, const char *needle) __smallc;
extern char __LIB__              *strtok(char *s, const char *delim) __smallc;
extern char __LIB__              *strtok_r(char *s, const char *delim, char **saveptr) __smallc;
extern char __LIB__              *strtok_s(char *s, const char *delim, char **saveptr) __smallc;
extern char __LIB__              *strsep(char **dp, const char *delim) __smallc;
extern char __LIB__              *strpbrk(const char *s, const char *accept) __smallc;
extern int  __LIB__               strpos(const char *haystack, uint needle) __smallc;
extern int  __LIB__               strcspn(const char *s, const char *reject) __smallc;
extern int  __LIB__               strspn(const char *s, const char *accept) __smallc;
extern int  __LIB__               stricmp(const char *s1, const char *s2) __smallc;
extern int  __LIB__               strcasecmp(const char *s1, const char *s2) __smallc;
extern int  __LIB__               strnicmp(const char *s1, const char *s2, size_t n) __smallc;
extern int  __LIB__               strncasecmp(const char *s1, const char *s2, size_t n) __smallc;
extern char __LIB__              *strlwr(char *s) __z88dk_fastcall;
extern char __LIB__              *strupr(char *s) __z88dk_fastcall;
extern uint __LIB__               strlcat(char *dest, const char *src, size_t n) __smallc;
extern uint __LIB__               strlcpy(char *dest, const char *src, size_t n) __smallc;

extern void __LIB__              *memset(void *m, int c, size_t n) __smallc;
extern void __LIB__              *memcpy(void *dst, const void src,size_t n) __smallc;
extern void __LIB__              *memmove(void *dst, const void *src, size_t n) __smallc;
extern void __LIB__              *memchr(const void *, int c, size_t n) __smallc;
extern void __LIB__              *memrchr(const void *, int c, size_t n) __smallc;
extern int  __LIB__               memcmp(const void *, const void *, size_t n) __smallc;
extern void __LIB__              *memswap(void *, void *, size_t n) __smallc;
extern void __LIB__              *memopi(void *, void *, uint, uint) __smallc;
extern void __LIB__              *memopd(void *, void *, uint, uint) __smallc;

extern char __LIB__              *strdup(const char *) __z88dk_fastcall;

// And now a list of the same non-FASTCALL functions using CALLEE linkage

extern char __LIB__    *strcat_callee(char *dst, const char *src) __smallc __z88dk_callee;
extern int  __LIB__     strcmp_callee(const char *s1, const char *s2) __smallc __z88dk_callee;
extern char __LIB__    *strcpy_callee(char *dst, const char *src) __smallc __z88dk_callee;
extern char __LIB__    *strncat_callee(char *dst, const char *src, size_t n) __smallc __z88dk_callee;
extern int  __LIB__     strncmp_callee(const char *s1, const char *s2, size_t n) __smallc __z88dk_callee;
extern char __LIB__    *strncpy_callee(char *dst, const char *src, size_t n) __smallc __z88dk_callee;
extern char __LIB__    *strchr_callee(const char *s, int c) __smallc __z88dk_callee;
extern char __LIB__    *strchrnul_callee(const char *s, int c) __smallc __z88dk_callee;
extern char __LIB__    *strrchr_callee(const char *, int c) __smallc __z88dk_callee;
extern char __LIB__    *strrstrip_callee(char *s, int c) __smallc __z88dk_callee;
extern char __LIB__    *strstrip_callee(char *s, int c) __smallc __z88dk_callee;
extern char __LIB__    *strstr_callee(const char *haystack, const char *needle) __smallc __z88dk_callee;
extern char __LIB__    *strrstr_callee(const char *haystack, const char *needle) __smallc __z88dk_callee;
extern char __LIB__    *strtok_callee(char *s, const char *delim) __smallc __z88dk_callee;
extern char __LIB__    *strtok_r_callee(char *s, const char *delim, char **saveptr) __smallc __z88dk_callee;
extern char __LIB__    *strsep_callee(char **dp, const char *delim) __smallc __z88dk_callee;
extern char __LIB__    *strpbrk_callee(const char *s, const char *accept) __smallc __z88dk_callee;
extern int  __LIB__     strpos_callee(const char *s, int c) __smallc __z88dk_callee;
extern int  __LIB__     strcspn_callee(const char *s, const char *reject) __smallc __z88dk_callee;
extern int  __LIB__     strspn_callee(const char *s, const char *accept) __smallc __z88dk_callee;
extern int  __LIB__     stricmp_callee(const char *s1, const char *s2) __smallc __z88dk_callee;
extern int  __LIB__     strnicmp_callee(const char *s1, const char *s2, size_t n) __smallc __z88dk_callee;
extern uint __LIB__     strlcat_callee(char *dst, const char *src, size_t n) __smallc __z88dk_callee;
extern uint __LIB__     strlcpy_callee(char *dst, const char *src, size_t n) __smallc __z88dk_callee;

extern void __LIB__    *memset_callee(void *dst, int c, size_t n) __smallc __z88dk_callee;
extern void __LIB__    *memcpy_callee(void *dst, void *src,size_t n) __smallc __z88dk_callee;
extern void __LIB__    *memmove_callee(void *dst, void *src, size_t n) __smallc __z88dk_callee;
extern void __LIB__    *memchr_callee(const void *m, int c, size_t n) __smallc __z88dk_callee;
extern void __LIB__    *memrchr_callee(const void *m, int c, size_t n) __smallc __z88dk_callee;
extern int  __LIB__     memcmp_callee(const void *m1, const void *m2, size_t n) __smallc __z88dk_callee;
extern void __LIB__    *memswap_callee(void *, void *, size_t n) __smallc __z88dk_callee;
extern void __LIB__    *memopi_callee(void *, void *, uint, uint) __smallc __z88dk_callee;
extern void __LIB__    *memopd_callee(void *, void *, uint, uint) __smallc __z88dk_callee;


// And now we make CALLEE linkage default to make compiled progs shorter and faster
// These defines will generate warnings for function pointers but that's ok

#define strcat(a,b)         strcat_callee(a,b)
#define strcmp(a,b)         strcmp_callee(a,b)
#define strcpy(a,b)         strcpy_callee(a,b)
#define strncat(a,b,c)      strncat_callee(a,b,c)
#define strncmp(a,b,c)      strncmp_callee(a,b,c)
#define strncpy(a,b,c)      strncpy_callee(a,b,c)
#define strchr(a,b)         strchr_callee(a,b)
#define strchrnul(a,b)      strchrnul_callee(a,b)
#define strrchr(a,b)        strrchr_callee(a,b)
#define strrstrip(a,b)      strrstrip_callee(a,b)
#define strstrip(a,b)       strstrip_callee(a,b)
#define strstr(a,b)         strstr_callee(a,b)
#define strrstr(a,b)        strrstr_callee(a,b)
#define strtok(a,b)         strtok_callee(a,b)
#define strtok_r(a,b,c)     strtok_r_callee(a,b,c)
#define strtok_s(a,b,c)     strtok_r_callee(a,b,c)
#define strsep(a,b)         strsep_callee(a,b)
#define strpbrk(a,b)        strpbrk_callee(a,b)
#define strpos(a,b)         strpos_callee(a,b)
#define strcspn(a,b)        strcspn_callee(a,b)
#define strspn(a,b)         strspn_callee(a,b)
#define stricmp(a,b)        stricmp_callee(a,b)
#define strnicmp(a,b,c)     strnicmp_callee(a,b,c)
#define strcasecmp(a,b)     stricmp_callee(a,b)
#define strncasecmp(a,b,c)  strnicmp_callee(a,b,c)
#define strlcat(a,b,c)      strlcat_callee(a,b,c)
#define strlcpy(a,b,c)      strlcpy_callee(a,b,c)

#define memset(a,b,c)   memset_callee(a,b,c)
#define memcpy(a,b,c)   memcpy_callee(a,b,c)
#define memmove(a,b,c)  memmove_callee(a,b,c)
#define memchr(a,b,c)   memchr_callee(a,b,c)
#define memrchr(a,b,c)  memrchr_callee(a,b,c)
#define memcmp(a,b,c)   memcmp_callee(a,b,c)
#define memswap(a,b,c)  memswap_callee(a,b,c)
#define memopi(a,b,c,d) memopi_callee(a,b,c,d)
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


/*
 * Okay..some nice BSD-isms now..
 */

extern void __LIB__  *bzero(void *, size_t n) __smallc;
extern int  __LIB__   bcmp(const void *m1, const void *m2, size_t n) __smallc;
extern void __LIB__  *bcopy(void *, void *,size_t n) __smallc;
extern char __LIB__  *index(const char *s, int c) __smallc;
extern char __LIB__  *rindex(const char *s, int c) __smallc;

#define bzero(s,n)    memset_callee(s,0,n)
#define bcmp(s1,s2,n) memcmp_callee(s1,s2,n)
#define bcopy(s,d,l)  memcpy_callee(d,s,l)
#define index(s,b)    strchr_callee(s,b)
#define rindex(s,b)   strrchr_callee(s,b)


/*
 * Some more C legacy stuff
 */

extern void __LIB__   *strset(unsigned char *, unsigned char) __smallc;
extern void __LIB__   *strnset(unsigned char *, unsigned char, uint) __smallc;
extern int  __LIB__   strcmpi(const char *s1, const char *s2) __smallc;
extern int  __LIB__   strncmpi(const char *s1, const char *s2, size_t n) __smallc;
extern void __LIB__   *rawmemchr(const void *, uint c) __smallc;

#define strset(s,c)           memset_callee(s,c,sizeof(s)-1)
#define strnset(string,c,n)   memset_callee(string,c,n)
#define strcmpi(a,b)          stricmp_callee(a,b)
#define strncmpi(a,b)         strnicmp_callee(a,b)
#define rawmemchr(a,b)        memchr_callee(a,b,65535)

#endif
