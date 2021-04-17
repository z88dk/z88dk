/*
 *  dirent.h
 */

#ifndef __DIRENT_H__
#define __DIRENT_H__

#include <sys/compiler.h>

#define MAXNAMLEN 32

struct DIR;
typedef struct DIR DIR;

struct dirent {
    ino_t   d_ino;
    char    d_name[MAXNAMLEN+1];
};


extern int __LIB__ closedir(DIR *);
extern DIR __LIB__ *opendir(const char *);
extern struct dirent __LIB__ *readdir(DIR *);

extern void __LIB__ rewinddir(DIR *);
extern int __LIB__ seekdir(DIR *, long int) __smallc;
extern long int __LIB__ telldir(DIR *);


#endif
