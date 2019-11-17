//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#pragma once

#include <stdbool.h>

void init_backend(const char* output_filename);
void emit(int b);
void emitw(int w);
int get_pc(void);

// register modifier flags
enum { IDX_HL = 0, IDX_IX = 0x100, IDX_IY = 0x200, IDX_MASK = 0x300 };
enum { PRE_INC = 0x0400, PRE_DEC = 0x0800, PRE_MASK = 0x0c00 };
enum { POS_INC = 0x1000, POS_DEC = 0x2000, POS_MASK = 0x3000 };

// register and flags values
enum { R_B, R_C, R_D, R_E, R_H, R_L, R_M, R_A, R_MASK = 0x07 };
enum { RR_BC, RR_DE, RR_HL, RR_SP, RR_AF = RR_SP, RR_MASK = 0x03 };
enum { F_NZ, F_Z, F_NC, F_C, F_PO, F_NV = F_PO, F_PE, F_V = F_PE, F_P, F_M };

// operation codes
enum {
	OP_ADD = 0, OP_ADC, OP_SUB, OP_SBC, OP_AND, OP_XOR, OP_OR, OP_CP,
	OP_RLC = 0, OP_RRC, OP_RL, OP_RR, OP_SLA, OP_SRA, OP_SLL, OP_SLI = OP_SLL, OP_SRL,
	OP_BIT = 1, OP_RES, OP_SET,
};

// load
bool emit_ld_r_r(int r1, int r2);
bool emit_ld_r_n(int r, int n);
bool emit_ld_r_indx(int r, int x, int dis);
bool emit_ld_indx_r(int x, int dis, int r);
bool emit_ld_indx_n(int x, int dis, int n);
bool emit_ld_a_indrr(int rr);
bool emit_ld_indrr_a(int rr);
bool emit_ld_a_indnn(int nn);
bool emit_ld_indnn_a(int nn);
bool emit_ld_rr_nn(int rr, int nn);
bool emit_ld_rr_indnn(int rr, int nn);
bool emit_ld_indnn_rr(int nn, int rr);
bool emit_ld_a_i(void);
bool emit_ld_a_r(void);
bool emit_ld_i_a(void);
bool emit_ld_r_a(void);
bool emit_ld_sp_x(int x);

// increment and decrement
bool emit_inc_r(int r);
bool emit_dec_r(int r);
bool emit_inc_indx(int x, int dis);
bool emit_dec_indx(int x, int dis);
bool emit_inc_rr(int rr);
bool emit_dec_rr(int rr);

// exchange
bool emit_ex_af_af1(void);
bool emit_ex_de_hl(int x);
bool emit_ex_indsp_hl(int x);
bool emit_exx(void);

// stack
bool emit_push_rr(int rr);
bool emit_pop_rr(int rr);

// arithmetic and logical
bool emit_alu_r(int op, int r);
bool emit_alu_indx(int op, int x, int dis);
bool emit_alu_n(int op, int n);
bool emit_add_x_rr(int x, int rr);
bool emit_adc_x_rr(int x, int rr);
bool emit_sbc_x_rr(int x, int rr);
bool emit_daa(void);
bool emit_cpl(void);
bool emit_neg(void);
bool emit_scf(void);
bool emit_ccf(void);

// rotate and shift
bool emit_rla(void);
bool emit_rra(void);
bool emit_rlca(void);
bool emit_rrca(void);
bool emit_rot_r(int op, int r);
bool emit_rot_indx(int op, int x, int dis);
bool emit_rot_indx_r(int op, int x, int dis, int r);
bool emit_rrd(void);
bool emit_rld(void);

// bit manipulation
bool emit_bit_r(int op, int bit, int r);
bool emit_bit_indx(int op, int bit, int x, int dis);
bool emit_bit_indx_r(int op, int bit, int x, int dis, int r);

// block transfer
bool emit_ldi(void);
bool emit_ldir(void);
bool emit_ldd(void);
bool emit_lddr(void);

// search
bool emit_cpi(void);
bool emit_cpir(void);
bool emit_cpd(void);
bool emit_cpdr(void);

// input/output
bool emit_in_f_indc(void);
bool emit_in_r_indc(int r);
bool emit_in_a_indn(int n);
bool emit_ini(void);
bool emit_inir(void);
bool emit_ind(void);
bool emit_indr(void);
bool emit_out_indc_n(int n);
bool emit_out_indc_r(int r);
bool emit_out_indn_a(int n);
bool emit_outi(void);
bool emit_otir(void);
bool emit_outd(void);
bool emit_otdr(void);

// cpu control
bool emit_nop(void);
bool emit_di(void);
bool emit_ei(void);
bool emit_halt(void);
bool emit_im(int im);

// jump
bool emit_jr_nn(int nn);
bool emit_jr_f_nn(int f, int nn);
bool emit_djnz_nn(int nn);
bool emit_jp_nn(int nn);
bool emit_jp_f_nn(int f, int nn);
bool emit_jp_x(int x);

// call
bool emit_call_nn(int nn);
bool emit_call_f_nn(int f, int nn);
bool emit_rst(int rst);

// return
bool emit_ret(void);
bool emit_reti(void);
bool emit_retn(void);
bool emit_ret_f(int f);
