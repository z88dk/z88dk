

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

#define SUSPECT_IMPL(m)

extern unsigned char a,b,c,d,e,h,l,j,k;
extern unsigned char a_,b_,c_,d_,e_,h_,l_,j_,k_;
extern unsigned char xh, xl, yh, yl;
extern unsigned char ioi, ioe, altd;

extern unsigned short ff, fr, fa, fb, fk, pc, sp, mp;
extern unsigned short ff_, fr_, fa_, fb_;
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
extern int         in(int port);

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

// ez80
extern void ez80_lea_rr_xyd(uint8_t opcode);
extern void ez80_lea_xy_xd(uint8_t opcode);
extern void ez80_lea_xy_yd(uint8_t opcode);
extern void ez80_pea_xyd(uint8_t opcode);
extern void ez80_ld_rr_ihl(uint8_t opcode);
extern void ez80_ld_xy_ihl(uint8_t opcode);
extern void ez80_ld_rr_ixyd(uint8_t opcode, uint8_t prefix);
extern void ez80_ld_ixyd_rr(uint8_t opcode, uint8_t prefix);
extern void ez80_otd2r(uint8_t opcode);
extern void ez80_ld_xy_ixyd(uint8_t opcode, uint8_t prefix);
extern void ez80_ld_ixyd_xy(uint8_t opcode, uint8_t prefix);
extern void ez80_ld_ihl_rr(uint8_t opcode);
extern void ez80_ld_ihl_xy(uint8_t opcode);
extern void ez80_stmix(uint8_t opcode);
extern void ez80_rsmix(uint8_t opcode);
extern void ez80_ini2(uint8_t opcode);
extern void ez80_ini2r(uint8_t opcode);
extern void ez80_outi2(uint8_t opcode);
extern void ez80_oti2r(uint8_t opcode);
extern void ez80_ind2(uint8_t opcode);
extern void ez80_ind2r(uint8_t opcode);
extern void ez80_outd2(uint8_t opcode);
extern void ez80_outd2r(uint8_t opcode);
extern void ez80_inirx(uint8_t opcode);
extern void ez80_otirx(uint8_t opcode);
extern void ez80_indrx(uint8_t opcode);
extern void ez80_otdrx(uint8_t opcode);
extern void ez80_ld_mb_a(uint8_t opcode);
extern void ez80_ld_a_mb(uint8_t opcode);
extern void ez80_ld_i_hl(uint8_t opcode);
extern void ez80_ld_hl_i(uint8_t opcode);
extern void ez80_inim(uint8_t opcode);
extern void ez80_inimr(uint8_t opcode);
extern void ez80_indm(uint8_t opcode);
extern void ez80_indmr(uint8_t opcode);

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

extern void r4k_ld_pd_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ldl_pd_rr(uint8_t opcode, uint8_t lsb, uint8_t msb);
extern void r4k_ld_a_ixya(uint8_t opcode, uint8_t lsb, uint8_t msb);
extern void r4k_push_ps(uint8_t opcode);
extern void r4k_pop_pd(uint8_t opcode);
extern void r4k_ldf_a_ilmn(uint8_t opcode);
extern void r4k_ldf_ilmn_a(uint8_t opcode);
extern void r4k_ldf_pd_ilmn(uint8_t opcode);
extern void r4k_ldf_ilmn_ps(uint8_t opcode);
extern void r4k_dwjnz(uint8_t opcode);
extern void r4k_push_mn(uint8_t opcode);
extern void r4k_ldf_hl_ilmn(uint8_t opcode);
extern void r4k_ldf_ilmn_hl(uint8_t opcode);

extern void r4k_ld_r32_ps(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_r32_ihl(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_r32_ipshl(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_r32_ipsd(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_ipdd_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_push_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_pop_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_ipdhl_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_ihl_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_r32_ixyd(uint8_t opcode, uint8_t lsb, uint8_t msb, uint8_t isjkhl);
extern void r4k_ld_ixyd_r32(uint8_t opcode, uint8_t lsb, uint8_t msb, uint8_t isjkhl);
extern void r4k_ldf_r32_ilmn(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ldf_ilmn_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_r32_ispn(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_ispn_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_r32_isphl(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_isphl_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_imn_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_r32_imn(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ex_jkhl_bcde(uint8_t opcode);
extern void r4k_ld_r32_d(uint8_t opcode, uint8_t isjkhl);
extern void r4k_ld_hl_isphl(uint8_t opcode);
extern void r4k_ex_jk_hl(uint8_t opcode);
extern void r4k_ex_jk1_hl(uint8_t opcode);
extern void r4k_ex_bc_hl(uint8_t opcode);
extern void r4k_mulu(uint8_t opcode);
extern void r4k_callxy(uint8_t opcode, uint8_t iy);
extern void r4k_rlc_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_rrc_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_rl_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_rr_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_sla_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_sra_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_sll_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_srl_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_rlb_a_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_rrb_a_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_jre(uint8_t opcode, uint8_t dojump);
extern void r4k_test_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_neg_r32(uint8_t opcode, uint8_t isjkhl);
extern void r4k_neg_hl(uint8_t opcode);
extern void r4k_test_hlxy(uint8_t opcode, uint8_t prefix);
extern void r4k_ldf_rr_ilmn(uint8_t opcode);
extern void r4k_ldf_ilmn_rr(uint8_t opcode);
extern void r4k_convc(uint8_t opcode);
extern void r4k_convd(uint8_t opcode);
extern void r4k_ld_a_htr(uint8_t opcode);
extern void r4k_ld_htr_a(uint8_t opcode);
extern void r4k_cp_hl_d(uint8_t opcode);
extern void r4k_cp_hl_de(uint8_t opcode);
extern void r4k_cp_jkhl_bcde(uint8_t opcode);
extern void r4k_copy(uint8_t opcode);
extern void r4k_copyr(uint8_t opcode);
extern void r4k_ld_hl_lxpc(uint8_t opcode);
extern void r4k_ld_lxpc_hl(uint8_t opcode);
extern void r4k_alu_jkhl_bcde(uint8_t opcode);
extern void r4k_setusrp_mn(uint8_t opcode);
extern void r4k_fsyscall(uint8_t opcode);
extern void r4k_syscall(uint8_t opcode);
extern void r4k_sysret(uint8_t opcode);
extern void r4k_llret(uint8_t opcode);
extern void r4k_lljp(uint8_t opcode, uint8_t dojump);
extern void r4k_llcall(uint8_t opcode);
extern void r4k_llcall_jkhl(uint8_t opcode);
extern void r4k_cbm(uint8_t opcode);
extern void r4k_sbox_a(uint8_t opcode);
extern void r4k_ibox_a(uint8_t opcode);
extern void r4k_ld_pd_ihtrhl(uint8_t opcode);
extern void r4k_xor_hl_de(uint8_t opcode);
extern void r4k_flag_cc_hl(uint8_t opcode, uint8_t set);
extern void r4k_setsysp_mn(uint8_t opcode);
extern void r4k_exp(uint8_t opcode);

// rxk
extern void rxk_ld_hl_ispn(uint8_t opcode, uint8_t ih, uint8_t iy);
extern void rxk_ld_ispn_hl(uint8_t opcode, uint8_t ih, uint8_t iy);
extern void rxk_bool(uint8_t opcode, uint8_t ih, uint8_t iy);
extern void rxk_and_hlxy_de(uint8_t opcode, uint8_t ih, uint8_t iy);
extern void rxk_or_hlxy_de(uint8_t opcode, uint8_t ih, uint8_t iy);
extern void rxk_ld_hl_ihlxyd(uint8_t opcode, uint8_t prefix);
extern void rxk_ld_ihlxyd_hl(uint8_t opcode, uint8_t prefix);
extern void rxk_ld_hl_xy(uint8_t opcode, uint8_t prefix);
extern void rxk_ld_xy_hl(uint8_t opcode, uint8_t prefix);
extern void rxk_add_sp_d(uint8_t opcode);
extern void rxk_mul(uint8_t opcode);
extern void rxk_ld_xpc_a(uint8_t opcode);
extern void rxk_ld_a_xpc(uint8_t opcode);
extern void rxk_push_ip(uint8_t opcode);
extern void rxk_pop_ip(uint8_t opcode);
extern void rxk_ldp_hl_irr(uint8_t opcode, uint8_t prefix);
extern void rxk_ldp_rr_inm(uint8_t opcode, uint8_t prefix);
extern void rxk_ldp_inm_rr(uint8_t opcode, uint8_t prefix);
extern void rxk_ldp_irr_hl(uint8_t opcode, uint8_t prefix);
extern void rxk_lret(uint8_t opcode);
extern void rxk_lcall(uint8_t opcode);
extern void rxk_ljp(uint8_t opcode);
extern void rxk_ipset(uint8_t opcode);
extern void rxk_ipres(uint8_t opcode);
extern void rxk_ld_eir_a(uint8_t opcode);
extern void rxk_ld_iir_a(uint8_t opcode);
extern void rxk_ld_a_eir(uint8_t opcode);
extern void rxk_ld_a_iir(uint8_t opcode);

extern void r3k_push_su(uint8_t opcode);
extern void r3k_pop_su(uint8_t opcode);
extern void r3k_ldisr(uint8_t opcode);
extern void r3k_lddsr(uint8_t opcode);
extern void r3k_uma(uint8_t opcode);
extern void r3k_ums(uint8_t opcode);
extern void r3k_lsidr(uint8_t opcode);
extern void r3k_lsddr(uint8_t opcode);
extern void r3k_lsir(uint8_t opcode);
extern void r3k_lsdr(uint8_t opcode);
extern void r3k_setusr(uint8_t opcode);
extern void r3k_rdmode(uint8_t opcode);
extern void r3k_sures(uint8_t opcode);

// z80n
extern void z80n_mirror(void);
extern void z80n_outinb(void);
extern void z80n_nextreg_8_8(void);
extern void z80n_nextreg_8_a(void);
extern void z80n_ldws(void);
extern void z80n_ldpirx(void);
extern void z80n_ldix(void);
extern void z80n_lddx(void);
extern void z80n_ldirx(void);
extern void z80n_lddrx(void);
extern void z80n_mul_d_e(void);
extern void z80n_add_hl_a(void);
extern void z80n_add_hl_mn(void);
extern void z80n_add_de_mn(void);
extern void z80n_add_bc_mn(void);
extern void z80n_push_mn(void);
extern void z80n_add_de_a(void);
extern void z80n_add_bc_a(void);

// gbz80
extern void gbz80_ld_inm_sp(void);
extern void gbz80_add_sp_d(void);
extern void gbz80_ld_hl_spd(void);
extern void gbz80_ld_inm_a(void);
extern void gbz80_ld_a_inm(void);

// r800
extern void r800_mulub(uint8_t opcode);
extern void r800_muluw(uint8_t opcode);

// z180
extern void z180_mlt(uint8_t opcode);
extern void z180_otim(uint8_t opcode);
extern void z180_otimr(uint8_t opcode);
extern void z180_otdm(uint8_t opcode);
extern void z180_otdmr(uint8_t opcode);
extern void z180_in0(uint8_t opcode);
extern void z180_out0(uint8_t opcode);
extern void z180_slp(uint8_t opcode);

// zilog
extern void zilog_daa(uint8_t opcode);
extern void zilog_rld(uint8_t opcode);
extern void zilog_rrd(uint8_t opcode);
extern void zilog_cpi(uint8_t opcode);
extern void zilog_cpd(uint8_t opcode);
extern void zilog_cpir(uint8_t opcode);
extern void zilog_cpdr(uint8_t opcode);
extern void zilog_ini(uint8_t opcode);
extern void zilog_ind(uint8_t opcode);
extern void zilog_inir(uint8_t opcode);
extern void zilog_indr(uint8_t opcode);
extern void zilog_outi(uint8_t opcode);
extern void zilog_outd(uint8_t opcode);
extern void zilog_otir(uint8_t opcode);
extern void zilog_otdr(uint8_t opcode);

// i8085
extern void i8085_rim(uint8_t opcode);
extern void i8085_sim(uint8_t opcode);
extern void i8085_rstv(uint8_t opcode);
extern void i8085_ld_de_hln(uint8_t opcode);
extern void i8085_ld_de_spn(uint8_t opcode);
extern void i8085_ld_hl_ide(uint8_t opcode);
extern void i8085_ld_ide_hl(uint8_t opcode);
extern void i8085_sub_hl_bc(uint8_t opcode);

// kc160
extern void kc160_ld_rr_ixysd(uint8_t opcode);
extern void kc160_ld_ixysd_rr(uint8_t opcode);
extern void kc160_ld_hxy_sp(uint8_t opcode);
extern void kc160_ld_xy_ixysd(uint8_t opcode);
extern void kc160_ld_ixysd_xy(uint8_t opcode);
extern void kc160_ldf_ilmn_rr(uint8_t opcode);
extern void kc160_ldf_rr_ilmn(uint8_t opcode);
extern void kc160_ldf_ilmn_xy(uint8_t opcode);
extern void kc160_ldf_xy_ilmn(uint8_t opcode);
extern void kc160_jp3(uint8_t opcode, uint8_t dojump);
extern void kc160_ld_ixysd_r24(uint8_t opcode);
extern void kc160_ld_r24_ixysd(uint8_t opcode);
extern void kc160_ld_r24_lmn(uint8_t opcode);
extern void kc160_ld_pp_pp(uint8_t opcode);
extern void kc160_ldf_ilmn_r24(uint8_t opcode);
extern void kc160_ldf_r24_ilmn(uint8_t opcode);
extern void kc160_div_hl_a(uint8_t opcode);
extern void kc160_divs_hl_a(uint8_t opcode);
extern void kc160_div_dehl_bc(uint8_t opcode);
extern void kc160_divs_dehl_bc(uint8_t opcode);
extern void kc160_mul_hl(uint8_t opcode);
extern void kc160_muls_hl(uint8_t opcode);
extern void kc160_mul_de_hl(uint8_t opcode);
extern void kc160_muls_de_hl(uint8_t opcode);
extern void kc160_tra(uint8_t opcode);
extern void kc160_im3(uint8_t opcode);
extern void kc160_call3(uint8_t opcode);
extern void kc160_ret3(uint8_t opcode);
extern void kc160_retn3(uint8_t opcode);

extern void kc160_ldi_xy(uint8_t opcode);
extern void kc160_ldir_xy(uint8_t opcode);
extern void kc160_ldd_xy(uint8_t opcode);
extern void kc160_lddr_xy(uint8_t opcode);
extern void kc160_cpi_x(uint8_t opcode);
extern void kc160_cpir_x(uint8_t opcode);
extern void kc160_cpd_x(uint8_t opcode);
extern void kc160_cpdr_x(uint8_t opcode);
extern void kc160_ini_x(uint8_t opcode);
extern void kc160_inir_x(uint8_t opcode);
extern void kc160_ind_x(uint8_t opcode);
extern void kc160_indr_x(uint8_t opcode);
extern void kc160_outi_x(uint8_t opcode);
extern void kc160_otir_x(uint8_t opcode);
extern void kc160_outd_x(uint8_t opcode);
extern void kc160_otdr_x(uint8_t opcode);

#ifndef WIN32
extern int kbhit();
extern int getch();
#else
#include <conio.h>
#endif

#endif
