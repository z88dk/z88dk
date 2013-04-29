#ifndef __STRING_H__
#define __STRING_H__

/*
 *	This is strings.h
 *
 *	We have virtually a full set of these routines!
 *	Most of the common ones have been tested and
 *	used in my programs (dom).
 *
 *	BSDisms are catered for by #defines..
 *
 *	$Id: string.h,v 1.23 2013-04-29 16:51:27 stefano Exp $
 */

#include <sys/compiler.h>
#include <sys/types.h>

// First a list of functions using CALLER and FASTCALL linkage

extern int  __LIB__ __FASTCALL__  strlen(char *);
extern char __LIB__              *strcat(char *, char *);
extern int  __LIB__               strcmp(char *, char *);
extern char __LIB__              *strcpy(char *, char *);
extern char __LIB__              *strncat(char *, char *, uint);
extern int  __LIB__               strncmp(char *, char *, uint);
extern char __LIB__              *strncpy(char *, char *, uint);
extern char __LIB__ __FASTCALL__ *strrev(char *);
extern char __LIB__              *strchr(unsigned char *, unsigned char);
extern char __LIB__              *strchrnul(unsigned char *, unsigned char);
extern char __LIB__              *strrchr(unsigned char *, unsigned char);
extern char __LIB__              *strrstrip(char *, char);
extern char __LIB__              *strstrip(char *, uint);
extern char __LIB__              *strstr(char *, char *);
extern char __LIB__              *strrstr(char *, char *);
extern char __LIB__              *strtok(char *, char *);
extern char __LIB__              *strtok_r(char *, char *, char **);
extern char __LIB__              *strtok_s(char *, char *, char **);
extern char __LIB__              *strsep(char **, char *);
extern char __LIB__              *strpbrk(char *, char *);
extern int  __LIB__               strpos(char *, uint);
extern int  __LIB__               strcspn(char *, char *);
extern int  __LIB__               strspn(char *, char *);
extern int  __LIB__               stricmp(char *, char *);
extern int  __LIB__               strcasecmp(char *, char *);
extern int  __LIB__               strnicmp(char *, char *, uint);
extern int  __LIB__               strncasecmp(char *, char *, uint);
extern char __LIB__ __FASTCALL__ *strlwr(char *);
extern char __LIB__ __FASTCALL__ *strupr(char *);
extern uint __LIB__               strlcat(char *, char *, uint);
extern uint __LIB__               strlcpy(char *, char *, uint);

extern void __LIB__              *memset(void *, unsigned char, uint);
extern void __LIB__              *memcpy(void *, void *,uint);
extern void __LIB__              *memmove(void *, void *, uint);
extern void __LIB__              *memchr(void *, unsigned char, uint);
extern void __LIB__              *memrchr(void *, unsigned char, uint);
extern int  __LIB__               memcmp(void *, void *, uint);
extern void __LIB__              *memswap(void *, void *, uint);
extern void __LIB__              *memopi(void *, void *, uint, uint);
extern void __LIB__              *memopd(void *, void *, uint, uint);

extern char __LIB__ __FASTCALL__ *strdup(char *);

// And now a list of the same non-FASTCALL functions using CALLEE linkage

extern char __LIB__ __CALLEE__   *strcat_callee(char *, char *);
extern int  __LIB__ __CALLEE__    strcmp_callee(char *, char *);
extern char __LIB__ __CALLEE__   *strcpy_callee(char *, char *);
extern char __LIB__ __CALLEE__   *strncat_callee(char *, char *, uint);
extern int  __LIB__ __CALLEE__    strncmp_callee(char *, char *, uint);
extern char __LIB__ __CALLEE__   *strncpy_callee(char *, char *, uint);
extern char __LIB__ __CALLEE__   *strchr_callee(unsigned char *, unsigned char);
extern char __LIB__ __CALLEE__   *strchrnul_callee(unsigned char *, unsigned char);
extern char __LIB__ __CALLEE__   *strrchr_callee(unsigned char *, unsigned char);
extern char __LIB__ __CALLEE__   *strrstrip_callee(char *, char);
extern char __LIB__ __CALLEE__   *strstrip_callee(char *, uint);
extern char __LIB__ __CALLEE__   *strstr_callee(char *, char *);
extern char __LIB__ __CALLEE__   *strrstr_callee(char *, char *);
extern char __LIB__ __CALLEE__   *strtok_callee(char *, char *);
extern char __LIB__ __CALLEE__   *strtok_r_callee(char *, char *, char **);
extern char __LIB__ __CALLEE__   *strsep_callee(char **, char *);
extern char __LIB__ __CALLEE__   *strpbrk_callee(char *, char *);
extern int  __LIB__ __CALLEE__    strpos_callee(char *, uint);
extern int  __LIB__ __CALLEE__    strcspn_callee(char *, char *);
extern int  __LIB__ __CALLEE__    strspn_callee(char *, char *);
extern int  __LIB__ __CALLEE__    stricmp_callee(char *, char *);
extern int  __LIB__ __CALLEE__    strnicmp_callee(char *, char *, uint);
extern uint __LIB__ __CALLEE__    strlcat_callee(char *, char *, uint);
extern uint __LIB__ __CALLEE__    strlcpy_callee(char *, char *, uint);

extern void __LIB__ __CALLEE__   *memset_callee(void *, unsigned char, uint);
extern void __LIB__ __CALLEE__   *memcpy_callee(void *, void *,uint);
extern void __LIB__ __CALLEE__   *memmove_callee(void *, void *, uint);
extern void __LIB__ __CALLEE__   *memchr_callee(void *, unsigned char, uint);
extern void __LIB__ __CALLEE__   *memrchr_callee(void *, unsigned char, uint);
extern int  __LIB__ __CALLEE__    memcmp_callee(void *, void *, uint);
extern void __LIB__ __CALLEE__   *memswap_callee(void *, void *, uint);
extern void __LIB__ __CALLEE__   *memopi_callee(void *, void *, uint, uint);
extern void __LIB__ __CALLEE__   *memopd_callee(void *, void *, uint, uint);


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
extern far char __LIB__ *strcat_far(far char *, far char *);

#undef strcpy
#define strcpy(s1,s2) strcpy_far(s1,s2)
extern far char __LIB__ *strcpy_far(far char *, far char *);

#undef strncat
#define strncat(s1,s2) strncat_far(s1,s2,n)
extern far char __LIB__ *strncat_far(far char *, far char *, int);

#undef strncpy
#define strncpy(s1,s2) strncpy_far(s1,s2,n)
extern far char __LIB__ *strncpy_far(far char *, far char *, int);

#define strlwr(s) strlwr_far(s)
extern far char __LIB__ *strlwr_far(far char *);

#define strupr(s) strupr_far(s)
extern far char __LIB__ *strupr_far(far char *);

#undef strchr
#define strchr(s,c) strchr_far(s1,c)
extern far char __LIB__ *strchr_far(far unsigned char *, unsigned char);

#undef strrchr
#define strrchr(s,c) strrchr_far(s1,c)
extern far char __LIB__ *strrchr_far(far unsigned char *, unsigned char);

#define strdup(s) strdup_far(s)
extern far char __LIB__ *strdup_far(far char *);

#endif


/*
 * Okay..some nice BSD-isms now..
 */

extern void __LIB__  *bzero(void *, uint);
extern int  __LIB__   bcmp(void *, void *, uint);
extern void __LIB__  *bcopy(void *, void *,uint);
extern char __LIB__  *index(unsigned char *, unsigned char);
extern char __LIB__  *rindex(unsigned char *, unsigned char);

#define bzero(s,n)    memset_callee(s,0,n)
#define bcmp(s1,s2,n) memcmp_callee(s1,s2,n)
#define bcopy(s,d,l)  memcpy_callee(d,s,l)
#define index(s,b)    strchr_callee(s,b)
#define rindex(s,b)   strrchr_callee(s,b)


/*
 * Some more C legacy stuff
 */

extern void __LIB__   *strset(unsigned char *, unsigned char);
extern void __LIB__   *strnset(unsigned char *, unsigned char, uint);
extern int  __LIB__   strcmpi(char *, char *);
extern int  __LIB__   strncmpi(char *, char *, uint);
extern void __LIB__   *rawmemchr(void *, unsigned char);

#define strset(s,c)           memset_callee(s,c,sizeof(s)-1)
#define strnset(string,c,n)   memset_callee(string,c,n)
#define strcmpi(a,b)          stricmp_callee(a,b)
#define strncmpi(a,b)         strnicmp_callee(a,b)
#define rawmemchr(a,b)        memchr_callee(a,b,65535)

#endif
