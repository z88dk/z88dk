#ifndef _MV_H
#define _MV_H

#include <time.h>
#include <alloc/obstack.h>

#define FLAG_OVERWRITE_NO   0
#define FLAG_OVERWRITE_YES  1
#define FLAG_OVERWRITE_ASK  2

struct flag
{
   unsigned char backup;
   unsigned char overwrite;
   unsigned char slashes;
   unsigned char *suffix;
   unsigned char update;
   unsigned char verbose;
   unsigned char help;
   unsigned char version;
   unsigned char system;
};

extern struct flag flags;

#define FILE_TYPE_UNKNOWN    0
#define FILE_TYPE_NORMAL     1
#define FILE_TYPE_DIRECTORY  2

struct file
{
   unsigned char *name;
   unsigned char  type;
};

extern struct file *src;
extern unsigned char src_sz;
extern struct file dst;

struct file_info
{
   unsigned char *name;              // always present
   unsigned char *canonical_name;    // zero if not determined
   unsigned char  type;              // FILE_TYPE_NORMAL, FILE_TYPE_DIRECTORY
   unsigned char  exists;
   struct dos_tm  time;              // filled in if exists
};

extern unsigned char *cleanup_remove_name;
extern void close_open_files(void);

extern unsigned char *advance_past_drive(unsigned char *p);
extern unsigned char get_drive(unsigned char *p);

extern struct obstack *ob;

#endif
