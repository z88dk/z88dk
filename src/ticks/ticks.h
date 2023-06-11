

#ifndef MACHINE_H
#define MACHINE_H


#include "cmds.h"
#include "syms.h"
#include "cpu.h"
#include <sys/types.h>
#include <inttypes.h>

#include "uthash.h"
#include "utlist.h"

#define SYM_TAB_SIZE    0x10000

#if defined(_WIN32) || defined(WIN32)

#ifndef strcasecmp
#define strcasecmp(a,b) stricmp(a,b)
#endif

#ifndef strncasecmp
#define strncasecmp(a,b,c) strnicmp(a,b,c)
#endif

#endif

extern unsigned char a,b,c,d,e,h,l;
extern unsigned char a_,b_,c_,d_,e_,h_,l_;
extern unsigned char xh, xl, yh, yl;
extern unsigned short ff, pc, sp;
extern long long st;


extern int trace;
extern int rom_size;		/* amount of memory in low addresses that is read-only */
extern int ioport;
extern int rc2014_mode;
extern int break_required;

extern uint8_t verbose;

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
extern void      hook_rc2014(void);
extern void      hook_console_init(hook_command *cmds);

extern void memory_init(char *model);
extern void memory_handle_paging(int port, int value);
extern void memory_reset_paging();


extern void        out(int port, int value);


extern uint8_t    *get_memory_addr(int pc);

extern uint8_t     get_memory(uint16_t pc);
extern uint8_t     put_memory(uint16_t pc, uint8_t b);

// acia
extern int acia_out(int port, int value);
extern int acia_in(int port);

// am9511
extern int apu_out(int port, int value);
extern int apu_in(int port);
extern void apu_reset(void);
extern uint8_t apu_read_status(void);
extern uint8_t apu_read_data();
extern void apu_write_data(uint8_t data);
extern void apu_write_command(uint8_t cmd);

extern int hook_console_out(int port, int value);
extern int hook_console_in(int port);

#ifndef WIN32
extern int kbhit();
extern int getch();
#else
#include <conio.h>
#endif

#endif
