#ifndef __NC_H__
#define __NC_H__

/* Things relevant to the C library */

#define __STDIO_BINARY     1    /* We should consider binary/text differences */

extern int __LIB__ __FASTCALL__ _fdatestamp(const char *filename);
extern int __LIB__ __FASTCALL___fgetattr(const char *filename);
extern int __LIB__ _fsetattr(const char *filename, int attr);


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

extern int __LIB__ __FASTCALL__ _setdta(nc_findfirst *ptr);

extern unsigned int __LIB__ __FASTCALL__ _fsizehandle(unsigned int handle);
extern unsigned int __LIB__ __FASTCALL__ _fsize(const char *name);
extern unsigned int __LIB__ __FASTCALL__ nc_ltell(unsigned int handle);
extern unsigned int __LIB__ nc_lseek(unsigned int handle, unsigned int pos);
extern int __LIB__ __FASTCALL__ remove(const char *name);

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

extern DIR *opendir(const char *name);
extern int closedir(DIR *p);
extern struct dirent *readdir(DIR *p);
extern long telldir(DIR *p);
extern int seekdir(DIR *p, long v);


#endif