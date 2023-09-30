

#ifndef MACHINE_H
#define MACHINE_H


#include "cmds.h"
#include "syms.h"
#include "cpu.h"
#include "memory.h"
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

extern unsigned char a,b,c,d,e,h,l,j,k;
extern unsigned char a_,b_,c_,d_,e_,h_,l_,j_,k_;
extern unsigned char xh, xl, yh, yl;
extern unsigned char ioi, ioe, altd;
extern unsigned short ff, pc, sp, mp;
extern long long st;


extern int trace;
extern int rom_size;		/* amount of memory in low addresses that is read-only */
extern int ioport;
extern int rc2014_mode;
extern int break_required;

extern uint8_t verbose;
extern char* script_file;

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
extern int       rabbit_get_ioi_reg(int reg);

// Rabbit registers
#define RABBIT_EDMR  0x0420    // If 0xc0 then R4K mode, otherwise in R2K




extern void        out(int port, int value);


extern uint8_t    *get_memory_addr(uint32_t pc, memtype type);

extern uint8_t     get_memory(uint32_t pc, memtype type);
#define get_memory_inst(x) get_memory(x, MEM_TYPE_INST)
#define get_memory_data(x) get_memory(x, MEM_TYPE_DATA)
extern uint8_t     put_memory(uint16_t pc, uint8_t b);

#define put_memory_physical(pc,b) *get_memory_addr(pc, MEM_TYPE_PHYSICAL) = b

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


// r4k
extern void r4k_handle_6d_page(void);
extern void r4k_ld_ipdd_hl(uint8_t opcode);
extern void r4k_ld_hl_ipsd(uint8_t opcode);
extern void r4k_ld_a_ipshl(uint8_t opcode);
extern void r4k_ld_ipdhl_a(uint8_t opcode);
extern void r4k_ld_a_ipsd(uint8_t opcode);
extern void r4k_ld_ipdd_a(uint8_t opcode);
extern void r4k_ldl_pd_mn(uint8_t opcode);
extern void r4k_ld_pd_klmn(uint8_t opcode);
extern void r4k_ldl_pd_ispn(uint8_t opcode);
extern void r4k_ld_pd_ispn(uint8_t opcode);
extern void r4k_ld_ispn_ps(uint8_t opcode);
extern void r4k_ld_hl_ipsbc(uint8_t opcode);
extern void r4k_ld_ipdbc_hl(uint8_t opcode);

extern void r4k_ld_pd_r32(uint8_t opcode, uint8_t iyprefix);
extern void r4k_ldl_pd_rr(uint8_t opcode, uint8_t lsb, uint8_t msb);
extern void r4k_ld_a_ixya(uint8_t opcode, uint8_t lsb, uint8_t msb);
extern void r4k_push_ps(uint8_t opcode);
extern void r4k_pop_pd(uint8_t opcode);
extern void r4k_ldf_a_ilmn(uint8_t opcode);
extern void r4k_ldf_ilmn_a(uint8_t opcode);
extern void r4k_ldf_pd_ilmn(uint8_t opcode);
extern void r4k_ldf_ilmn_ps(uint8_t opcode);
extern void r4k_dwjnz(uint8_t opcode);


extern void r4k_ld_r32_ps(uint8_t opcode, uint8_t iyprefix);
extern void r4k_ld_r32_ihl(uint8_t opcode, uint8_t iyprefix);
extern void r4k_ld_r32_ipshl(uint8_t opcode, uint8_t iyprefix);
extern void r4k_ld_r32_ipsd(uint8_t opcode, uint8_t iyprefix);
extern void r4k_ld_ipdd_r32(uint8_t opcode, uint8_t iyprefix);
extern void r4k_push_r32(uint8_t opcode, uint8_t iyprefix);
extern void r4k_pop_r32(uint8_t opcode, uint8_t iyprefix);
extern void r4k_ld_ipdhl_r32(uint8_t opcode, uint8_t iyprefix);
extern void r4k_ld_ihl_r32(uint8_t opcode, uint8_t iyprefix);

#ifndef WIN32
extern int kbhit();
extern int getch();
#else
#include <conio.h>
#endif

#endif
