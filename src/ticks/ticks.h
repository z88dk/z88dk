

#ifndef MACHINE_H
#define MACHINE_H


#include "cmds.h"
#include <sys/types.h>
#include <inttypes.h>

extern unsigned char a,b,c,d,e,h,l;
extern unsigned char a_,b_,c_,d_,e_,h_,l_;
extern unsigned char xh, xl, yh, yl;
extern unsigned short ff, pc, sp;
extern unsigned char *mem;

#define SET_ERROR(error) do {                   \
        if ( (error) == Z88DK_ENONE ) {           \
            ff &= ~256;                           \
        } else {                                  \
            ff |= 256;                            \
            a = (error);                          \
        }                                         \
    } while (0)

#define CPU_Z80      1
#define CPU_Z180     2
#define CPU_R2K      4
#define CPU_R3K      8
#define CPU_Z80_ZXN  16

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
extern void      debugger_init();
extern void      debugger();
extern int       disassemble(int pc);
extern void      read_symbol_file(char *filename);
extern const char     *find_symbol(int addr);

#endif
