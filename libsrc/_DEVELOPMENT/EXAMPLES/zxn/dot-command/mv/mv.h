#ifndef _MV_H
#define _MV_H

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

extern unsigned char *advance_past_drive(unsigned char *p);

#endif
