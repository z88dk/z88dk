#ifndef GLOBALS_H
#define GLOBALS_H

#include <arch/zxn/esxdos.h>

extern unsigned char cwd[ESX_PATHNAME_MAX];

extern unsigned char fin;
extern unsigned char fdir;

extern unsigned char program_name[ESX_PATHNAME_MAX];
extern unsigned char *command_line;

extern unsigned char PATH[512];

extern unsigned char buf[64];

extern unsigned char cursor[5];
extern unsigned char cpos;

#endif
