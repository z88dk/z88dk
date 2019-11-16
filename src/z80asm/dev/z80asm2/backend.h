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

// cpu control

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

// stack

// arithmetic

// logical

// rotate and shift

// bit manipulation

// block transfer

// search

// input/output

// jump

// call

// return

