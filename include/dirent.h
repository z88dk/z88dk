/*
 *  dirent.h
 */

#ifndef __DIRENT_H__
#define __DIRENT_H__

#include <sys/compiler.h>


struct DIR;
typedef struct DIR DIR;

extern int __LIB__ closedir(DIR *);
extern DIR __LIB__ *opendir(const char *);
extern struct dirent __LIB__ *readdir(DIR *);

extern void __LIB__ rewinddir(DIR *);
extern int __LIB__ seekdir(DIR *, long int) __smallc;
extern long int __LIB__ telldir(DIR *);


#endif
