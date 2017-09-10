

#ifndef MACHINE_H
#define MACHINE_H


#include "cmds.h"
#include <sys/types.h>
#include <inttypes.h>

#include "uthash.h"
#include "utlist.h"

typedef enum {
    SYM_CONST = 1,
    SYM_ADDRESS = 2,
} symboltype;

typedef struct {
    const char    *name;
    const char    *file;
    int            address;
    symboltype     symtype;
    char           islocal;
    const char    *section;
} symbol;


typedef struct {
    int             line;
    int             address;
    UT_hash_handle hh;
} cline;

typedef struct {
    char          *file;
    cline         *lines;
    UT_hash_handle hh;
} cfile;

extern unsigned char a,b,c,d,e,h,l;
extern unsigned char a_,b_,c_,d_,e_,h_,l_;
extern unsigned char xh, xl, yh, yl;
extern unsigned short ff, pc, sp;
extern unsigned char *mem;
extern long long st;

extern int c_cpu;

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
extern int       disassemble(int pc, char *buf, size_t buflen);
extern void      read_symbol_file(char *filename);
extern const char     *find_symbol(int addr);
extern symbol   *find_symbol_byname(const char *name);
extern int symbol_resolve(char *name);
extern uint8_t   get_memory(int pc);
extern char **parse_words(char *line, int *argc);

#endif
