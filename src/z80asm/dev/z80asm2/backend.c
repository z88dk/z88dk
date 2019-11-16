//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#include "backend.h"
#include "frontend.h"
#include "utils.h"

#include <assert.h>
#include <stdio.h>

static FILE* output_file = NULL;

void init_backend(const char* output_filename) {
	if (output_file) fclose(output_file);
	output_file = safe_fopen(output_filename, "wb");
}

void emit(int b) {
	fputc(b & 0xff, output_file);
}

void emitw(int w) {
	emit(w);
	emit(w >> 8);
}

int get_pc(void) {
	return (int)ftell(output_file);
}

static void emit_idx_prefix(int x) {
	switch (x & IDX_MASK) {
	case IDX_HL: break;
	case IDX_IX: emit(0xdd); break;
	case IDX_IY: emit(0xfd); break;
	default: assert(0);
	}
}

static void emit_idx_dis(int x, int dis) {
	if (x & IDX_MASK) emit(dis);
}

static void emit_pre_inc_dec_ss(int rr) {
	if (rr & PRE_INC)	emit_inc_rr(rr);
	if (rr & PRE_DEC)	emit_dec_rr(rr);
}

static void emit_pos_inc_dec_ss(int rr) {
	if (rr & POS_INC)	emit_inc_rr(rr);
	if (rr & POS_DEC)	emit_dec_rr(rr);
}

bool emit_ld_r_r(int r1, int r2) {
	if ((r1 & R_MASK) == R_M && (r2 & R_MASK) == R_M) {			// move memory to memory
		error_illegal();
		return false;
	}
	else if (((r1 | r2) & IDX_MASK) == (IDX_IX | IDX_IY)) {		// ix-iy mismath
		error_illegal();
		return false;
	}
	else {
		emit_idx_prefix(r1 | r2);
		emit(0x40 + ((r1 & R_MASK) << 3) + (r2 & R_MASK));
		return true;
	}
}

bool emit_ld_r_n(int r, int n)
{
	emit_idx_prefix(r);
	emit(0x06 + (r << 3));
	emit(n);
	return true;
}

static bool emit_ld_r_indx_1(int opc, int r, int x, int dis) {
	if ((r & IDX_MASK) != IDX_HL) {
		error_illegal();
		return false;
	}
	else {
		emit_pre_inc_dec_ss(x);
		emit_idx_prefix(x);
		emit(opc);
		emit_idx_dis(x, dis);
		emit_pos_inc_dec_ss(x);
		return true;
	}
}

bool emit_ld_r_indx(int r, int x, int dis) {
	return emit_ld_r_indx_1(0x40 + (r << 3) + R_M, r, x, dis);
}

bool emit_ld_indx_r(int x, int dis, int r) {
	return emit_ld_r_indx_1(0x40 + (R_M << 3) + r, r, x, dis);
}

bool emit_ld_indx_n(int x, int dis, int n) {
	emit_pre_inc_dec_ss(x);
	emit_idx_prefix(x);
	emit(0x06 + (R_M << 3));
	emit_idx_dis(x, dis);
	emit(n);
	emit_pos_inc_dec_ss(x);
	return true;
}

static bool emit_ld_a_indrr_1(int opc, int rr) {
	if ((rr & IDX_MASK) != IDX_HL) {
		error_illegal();
		return false;
	}
	else if ((rr & RR_MASK) != RR_BC && (rr & RR_MASK) != RR_DE) {
		error_illegal();
		return false;
	}
	else {
		emit_pre_inc_dec_ss(rr);
		emit(opc + (rr << 4));
		emit_pos_inc_dec_ss(rr);
		return true;
	}
}

bool emit_ld_a_indrr(int rr) {
	return emit_ld_a_indrr_1(0x0a, rr);
}

bool emit_ld_indrr_a(int rr) {
	return emit_ld_a_indrr_1(0x02, rr);
}

static bool emit_ld_a_indnn_1(int opc, int nn) {
	emit(opc);
	emitw(nn);
	return true;
}

bool emit_ld_a_indnn(int nn) {
	return emit_ld_a_indnn_1(0x3a, nn);
}

bool emit_ld_indnn_a(int nn) {
	return emit_ld_a_indnn_1(0x32, nn);
}

bool emit_ld_rr_nn(int rr, int nn) {
	emit_idx_prefix(rr);
	emit(0x01 + (rr << 4));
	emitw(nn);
	return true;
}

static bool emit_ld_rr_indnn_1(int opc_hl, int opc_rr, int rr, int nn) {
	if ((rr & RR_MASK) == RR_HL) {
		emit_idx_prefix(rr);
		emit(opc_hl);
		emitw(nn);
		return true;
	}
	if ((rr & IDX_MASK) != IDX_HL) {
		error_illegal();
		return false;
	}
	else {
		emit(0xed);
		emit(opc_rr + (rr << 4));
		emitw(nn);
		return true;
	}
}

bool emit_ld_rr_indnn(int rr, int nn) {
	return emit_ld_rr_indnn_1(0x2a, 0x4b, rr, nn);
}

bool emit_ld_indnn_rr(int nn, int rr) {
	return emit_ld_rr_indnn_1(0x22, 0x43, rr, nn);
}

bool emit_ld_a_i(void) {
	emit(0xed);
	emit(0x57);
	return true;
}

bool emit_ld_a_r(void) {
	emit(0xed);
	emit(0x5f);
	return true;
}

bool emit_ld_i_a(void) {
	emit(0xed);
	emit(0x47);
	return true;
}

bool emit_ld_r_a(void) {
	emit(0xed);
	emit(0x4f);
	return true;
}

bool emit_ld_sp_x(int x) {
	emit_idx_prefix(x);
	emit(0xf9);
	return true;
}

static bool emit_inc_dec_r_1(int opc, int r) {
	emit_idx_prefix(r);
	emit(opc + ((r & R_MASK) << 3));
	return true;
}

bool emit_inc_r(int r) {
	return emit_inc_dec_r_1(0x04, r);
}

bool emit_dec_r(int r) {
	return emit_inc_dec_r_1(0x05, r);
}

static bool emit_inc_dec_indx_1(int opc, int x, int dis) {
	emit_pre_inc_dec_ss(x);
	emit_idx_prefix(x);
	emit(opc + (R_M << 3));
	emit_idx_dis(x, dis);
	emit_pos_inc_dec_ss(x);
	return true;
}

bool emit_inc_indx(int x, int dis) {
	return emit_inc_dec_indx_1(0x04, x, dis);
}

bool emit_dec_indx(int x, int dis) {
	return emit_inc_dec_indx_1(0x05, x, dis);
}

static bool emit_inc_dec_rr_1(int opc, int rr) {
	emit_idx_prefix(rr);
	emit(opc + ((rr & RR_MASK) << 4));
	return true;
}

bool emit_inc_rr(int rr) {
	return emit_inc_dec_rr_1(0x03, rr);

	emit_idx_prefix(rr);
	emit(0x03 + ((rr & RR_MASK) << 4));
	return true;
}

bool emit_dec_rr(int rr) {
	return emit_inc_dec_rr_1(0x0b, rr);
	
	emit_idx_prefix(rr);
	emit(0x0b + ((rr & RR_MASK) << 4));
	return true;
}
