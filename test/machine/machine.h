

#ifndef MACHINE_H
#define MACHINE_H

#include "Z80/Z80.h"

#include "cmds.h"

#define SET_ERROR(R,error) do {                   \
        if ( (error) == Z88DK_ENONE ) {           \
            (R)->AF.B.l &= ~C_FLAG;               \
        } else {                                  \
            (R)->AF.B.l |= C_FLAG;                \
            (R)->AF.B.h = (error);                \
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

typedef void (*hook_command)(Z80 *R);

extern byte RAM[65536];

/* hook_io.c */

extern void      hook_io_init(hook_command *cmds);

extern void      hook_misc_init(hook_command *cmds);

extern void      hook_console_init(hook_command *cmds);


#endif
