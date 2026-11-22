#ifndef _RUN_H
#define _RUN_H

#include <arch/zxn/esxdos.h>

#define FLAG_OPTION_Q        0x01
#define FLAG_OPTION_PATH     0x02
#define FLAG_OPTION_CD       0x04
#define FLAG_OPTION_CWD      0x08

struct flag
{
   unsigned char option;
   unsigned int n;
};

extern struct flag flags;

struct type
{
   unsigned char *extension;
   void (*load)(void);
};

extern unsigned char mode48;

#define PATHSZ  192

extern unsigned char PATH[PATHSZ];
extern unsigned char cwd[ESX_PATHNAME_MAX + 1];
extern unsigned char buffer[512];

extern struct esx_dirent dirent_sfn;
extern struct esx_dirent_lfn dirent_lfn;

extern unsigned char current_drive[];

extern unsigned char *advance_past_drive(unsigned char *p);

#endif
