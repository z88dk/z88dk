

#ifndef MACHINE_H
#define MACHINE_H


#include "cmds.h"

extern unsigned char a,b,c,d,e,h,l;
extern unsigned short ff;
extern unsigned char *mem;

#define SET_ERROR(error) do {                   \
        if ( (error) == Z88DK_ENONE ) {           \
            ff &= ~256;                           \
        } else {                                  \
            ff |= 256;                            \
            a = (error);                          \
        }                                         \
    } while (0)


#define Z88DK_SEEK_SET 0
#define Z88DK_SEEK_END 1
#define Z88DK_SEEK_CUR 2


#define Z88DK_ENONE    0
#define Z88DK_EACCES   1
#define Z88DK_EBADF    2
#define Z88DK_EDEVNF   3
#define Z88DK_EINVAL   4
#define Z88DK_ENFILE   5
#define Z88DK_ENOMEM   6

typedef void (*hook_command)(void);

extern void      PatchZ80(void);
extern void      hook_init(void);
extern void      hook_io_init(hook_command *cmds);
extern void      hook_misc_init(hook_command *cmds);
extern void      hook_console_init(hook_command *cmds);


#endif
