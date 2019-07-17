

#ifndef MACHINE_H
#define MACHINE_H


#include "cmds.h"
#include <sys/types.h>
#include <inttypes.h>

#include "uthash.h"
#include "utlist.h"

typedef enum {
    SYM_ANY = 0,
    SYM_CONST = 1,
    SYM_ADDRESS = 2,
} symboltype;

typedef struct symbol_s symbol;

struct symbol_s {
    const char    *name;
    const char    *file;
    const char    *module;
    int            address;
    symboltype     symtype;
    char           islocal;
    const char    *section;
    symbol        *next;
    UT_hash_handle hh;
};


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
extern long long st;


#define is8080() ( (c_cpu & CPU_8080) == CPU_8080 )
#define isgbz80() ( (c_cpu & CPU_GBZ80) == CPU_GBZ80 )
#define isr800() ( (c_cpu & CPU_R800) == CPU_R800 )
#define israbbit() ( c_cpu & (CPU_R2K|CPU_R3K))
#define israbbit3k() ( c_cpu & (CPU_R3K))
#define isz180() ( c_cpu & (CPU_Z180))
#define isez80() ( c_cpu & (CPU_EZ80))
#define canaltreg() ( ( c_cpu & (CPU_8080|CPU_GBZ80)) == 0 )
#define canindex() ( ( c_cpu & (CPU_8080|CPU_GBZ80)) == 0 )
#define canixh() ( c_cpu & (CPU_Z80|CPU_Z80N|CPU_R800|CPU_EZ80))
#define cansll() ( c_cpu & (CPU_Z80|CPU_Z80N))
#define canz180() ( c_cpu & (CPU_Z180|CPU_EZ80))
#define cancbundoc() ( c_cpu & (CPU_Z80|CPU_Z80N))

extern int c_cpu;
extern int trace;
extern int debugger_active;

/* Break down flags */
extern int f(void);
extern int f_(void);

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
#define CPU_Z80N     16
#define CPU_R800     32
#define CPU_GBZ80    64
#define CPU_8080     128
#define CPU_EZ80     256

#define Z88DK_O_RDONLY 0
#define Z88DK_O_WRONLY 1
#define Z88DK_O_RDWR   2
#define Z88DK_O_TRUNC  512
#define Z88DK_O_APPEND 256
#define Z88DK_O_CREAT  1024

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
extern void      hook_io_set_ide_device(int unit, const char *file);
extern void      hook_misc_init(hook_command *cmds);
extern void      hook_cpm(void);
extern void      hook_console_init(hook_command *cmds);
extern void      debugger_init();
extern void      debugger();
extern int       disassemble(int pc, char *buf, size_t buflen);
extern int       disassemble2(int pc, char *buf, size_t buflen);
extern void      read_symbol_file(char *filename);
extern const char     *find_symbol(int addr, symboltype preferred_symtype);
extern symbol   *find_symbol_byname(const char *name);
extern int symbol_resolve(char *name);
extern char **parse_words(char *line, int *argc);

extern void memory_init(char *model);
extern void memory_handle_paging(int port, int value);
extern void memory_reset_paging();


extern void        out(int port, int value);


extern uint8_t    *get_memory_addr(int pc);
extern uint8_t     get_memory(int pc);
extern uint8_t     put_memory(int pc, uint8_t b);

#endif
