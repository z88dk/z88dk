#ifndef _FIND_H
#define _FIND_H

#include <alloc/obstack.h>
#include <arch/zxn/esxdos.h>
#include "directory.h"

extern struct obstack *ob;

#define FLAG_LFN_OFF   1
#define FLAG_LFN_ON    2
#define FLAG_LFN_BOTH  3

struct flag
{
   // search depth
   
   unsigned char mindepth;
   unsigned char maxdepth;
   
   // lfn mode for printed filename
   
   unsigned char lfn;
   
   // change directory if found (count if > 0)
   
   unsigned int cd;
   
   // other
   
   unsigned char help;
   unsigned char version;
};

extern struct flag flags;

extern struct dir_record *dir;      // directory being visited

extern struct esx_dirent dirent_sfn;       // file entry being visited
extern struct esx_dirent_lfn dirent_lfn;   // file entry being visited

extern unsigned char *advance_past_drive(unsigned char *p);

#endif
