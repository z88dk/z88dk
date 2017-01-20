#ifndef __NC_H__
#define __NC_H__

#include <sys/compiler.h>


/* Things relevant to the C library */

#define __STDIO_BINARY     1    /* We should consider binary/text differences */

extern int __LIB__  _fdatestamp(const char *filename) __z88dk_fastcall;
extern int __LIB__  _fgetattr(const char *filename) __z88dk_fastcall;
extern int __LIB__ _fsetattr(const char *filename, int attr) __smallc;


#define NC_FATTR_SYSTEM		1
#define NC_FATTR_HIDDEN		2
#define NC_FATTR_BASIC		4
#define NC_FATTR_BINARY		8

struct nc_findfirst {
  char name[13];		/* Max 12 chars + \0 */
  char attr;
  unsigned int size;
  unsigned int time;
  unsigned int date;
  unsigned char _osflags;		/* Memory info (private) */
  unsigned char _oshandle;
};

typedef struct nc_findfirst nc_findfirst;

extern int __LIB__  _setdta(nc_findfirst *ptr) __z88dk_fastcall;

extern unsigned int __LIB__  _fsizehandle(unsigned int handle) __z88dk_fastcall;
extern unsigned int __LIB__  _fsize(const char *name) __z88dk_fastcall;
extern unsigned int __LIB__  nc_ltell(unsigned int handle) __z88dk_fastcall;
extern unsigned int __LIB__ nc_lseek(unsigned int handle, unsigned int pos) __smallc;
extern int __LIB__  remove(const char *name) __z88dk_fastcall;

//extern int __LIB__ rename(const char *old, const char *new);

#define NAME_MAX	12

struct dirent {
  unsigned int d_ino;
  char d_name[12];
  unsigned char d_attr;			/* Non portable bits */
  unsigned int d_size;
  unsigned int d_time;
  unsigned int d_date;
};

typedef unsigned int	 DIR;		/* compiler limit */

extern DIR __LIB__  *opendir(const char *name);
extern int  __LIB__ closedir(DIR *p);
extern struct dirent  __LIB__ *readdir(DIR *p);
extern long  __LIB__ telldir(DIR *p);
extern int  __LIB__ seekdir(DIR *p, long v);


#endif
