/*
 *  dirent.h
 *  Just a placeholder for now
 *
 *	$Id: dirent.h,v 1.1 2012-04-20 15:46:39 stefano Exp $
 */

#ifndef __DIRENT_H__
#define __DIRENT_H__

#include <sys/compiler.h>

#if !defined(MAXNAMLEN)
#define MAXNAMLEN 12
#endif

struct DIR;
struct dirent;
typedef struct DIR DIR;


extern int __LIB__ closedir(DIR *);
extern DIR __LIB__ *opendir(const char *);
extern struct dirent __LIB__ *readdir(DIR *);

extern void __LIB__ rewinddir(DIR *);
extern int __LIB__ seekdir(DIR *, long int) __smallc;
extern long int __LIB__ telldir(DIR *);


#endif
