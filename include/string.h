#ifndef STRINGS_H
#define STRINGS_H

/*
 *	This is strings.h
 *
 *	We have virtually a full set of these routines!
 *	Most of the common ones have been tested and
 *	used in my programs
 *
 *	BSDisms are catered for by #defines..
 */


extern int __LIB__ strlen(char *);
extern char __LIB__ *strcat(char *, char *);
extern __LIB__ strcmp(char *, char *);
extern char __LIB__ *strcpy(char *, char *);
extern char __LIB__ *strncat(char *, char *);
extern __LIB__ strncmp(char *, char *, int);
extern char __LIB__ *strncpy(char *, char *, int);
extern __LIB__ reverse(char *);

extern char __LIB__ *strchr(unsigned char *, unsigned char);
extern char __LIB__ *strrchr(unsigned char *, unsigned char);
/* Makes sense to search for a char... */
extern char __LIB__ *strrstrip(char *, char);
extern char __LIB__ *strstrip(char *, int);
extern char __LIB__ *strstr(char *, char *);
extern char __LIB__ *strrstr(char *, char *);
extern char __LIB__ *strtok(char *, char *);
extern char __LIB__ *strpbrk(char *, char *);
extern __LIB__ strpos(char *, int);
extern __LIB__ strcspn(char *, char *);
extern __LIB__ strspn(char *, char *);
extern __LIB__ stricmp(char *, char *);
extern __LIB__ strnicmp(char *, char *,int);

extern char __LIB__ *strlwr(char *);
extern char __LIB__ *strupr(char *);

extern void __LIB__ *memset(void *, unsigned char, int);
extern void __LIB__ *memcpy(void *, void *,int);
extern void __LIB__ *memchr(void *, unsigned char, int);

extern char __LIB__ *strdup(char *);

/*
 * Now handle far stuff
 */

#ifdef FARDATA

#define strlen(s) strlen_far(s)
extern int __LIB__ strlen_far(far char *);
#define strcat(s1,s2) strcat_far(s1,s2)
extern far char __LIB__ *strcat_far(far char *, far char *);
#define strcpy(s1,s2) strcpy_far(s1,s2)
extern far char __LIB__ *strcpy_far(far char *, far char *);
#define strncat(s1,s2) strncat_far(s1,s2)
extern far char __LIB__ *strncat_far(far char *, far char *);
#define strncpy(s1,s2) strncpy_far(s1,s2)
extern far char __LIB__ *strncpy_far(far char *, far char *, int);
#define strlwr(s) strlwr_far(s)
extern far char __LIB__ *strlwr_far(far char *);
#define strupr(s) strupr_far(s)
extern far char __LIB__ *strupr_far(far char *);
#define strchr(s,c) strchr_far(s1,c)
extern far char __LIB__ *strchr_far(far unsigned char *, unsigned char);
#define strrchr(s,c) strrchr_far(s1,c)
extern far char __LIB__ *strrchr_far(far unsigned char *, unsigned char);
#define strdup(s) strdup_far(s)
extern far char __LIB__ *strdup_far(far char *);

#endif

/*
 * Now some defines (done down so far and near will work
 */

#define memcmp(a,b,c) strncmp(a,b,c)

/*
 * Okay..some nice BSD-isms now..
 */

#define bzero(s,n) memset(s,0,n)
#define bcopy(s,d,l) memcpy(d,s,l)
#define index(s,b) strchr(s,b)
#define rindex(s,b) strrchr(s,b)


#endif
