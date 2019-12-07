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
static char* output_filename = NULL;

static void close_output_file(bool delete_output) {
	if (output_file) {
		fclose(output_file);
		output_file = NULL;
	}
	if (delete_output && output_filename) {
		remove(output_filename);
	}
	if (output_filename) {
		free(output_filename);
		output_filename = NULL;
	}
}

void start_backend(const char* obj_filename) {
	close_output_file(false);
	output_filename = safe_strdup(obj_filename);
	output_file = safe_fopen(obj_filename, "wb");
}

void end_backend(bool delete_output) {
	close_output_file(delete_output);
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

static bool check_idx_r(int r1, int r2) {
	int x1 = r1 & IDX_MASK; r1 &= R_MASK;
	int x2 = r2 & IDX_MASK; r2 &= R_MASK;

	if (x1 == IDX_HL && x2 == IDX_HL)					
		return true;
	else if (x1 == x2)									
		return true;
	else if (x1 != IDX_HL && r2 != R_H && r2 != R_L)	
		return true;
	else if (x2 != IDX_HL && r1 != R_H && r1 != R_L)	
		return true;
	else												
		return false;
}

static bool check_idx_rr(int rr1, int rr2) {
	int x1 = rr1 & IDX_MASK; rr1 &= RR_MASK;
	int x2 = rr2 & IDX_MASK; rr2 &= RR_MASK;

	if (x1 == IDX_HL && x2 == IDX_HL)
		return true;
	else if (x1 == x2)
		return true;
	else if (x1 != IDX_HL && rr2 != RR_HL)
		return true;
	else if (x2 != IDX_HL && rr1 != RR_HL)
		return true;
	else
		return false;
}

static void emit_pre_inc_dec_rr(int rr) {
	if (rr & PRE_INC)	emit_inc_rr(rr);
	if (rr & PRE_DEC)	emit_dec_rr(rr);
}

static void emit_pos_inc_dec_rr(int rr) {
	if (rr & POS_INC)	emit_inc_rr(rr);
	if (rr & POS_DEC)	emit_dec_rr(rr);
}

bool emit_ld_r_r(int r1, int r2) {
	if ((r1 & R_MASK) == R_M && (r2 & R_MASK) == R_M) {			// move memory to memory
		illegal_opcode_error();
		return false;
	}
	else if (!check_idx_r(r1,r2)) {								// ix-iy mismath
		illegal_opcode_error();
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
		illegal_opcode_error();
		return false;
	}
	else {
		emit_pre_inc_dec_rr(x);
		emit_idx_prefix(x);
		emit(opc);
		emit_idx_dis(x, dis);
		emit_pos_inc_dec_rr(x);
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
	emit_pre_inc_dec_rr(x);
	emit_idx_prefix(x);
	emit(0x06 + (R_M << 3));
	emit_idx_dis(x, dis);
	emit(n);
	emit_pos_inc_dec_rr(x);
	return true;
}

static bool emit_ld_a_indrr_1(int opc, int rr) {
	if ((rr & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else if ((rr & RR_MASK) != RR_BC && (rr & RR_MASK) != RR_DE) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit_pre_inc_dec_rr(rr);
		emit(opc + (rr << 4));
		emit_pos_inc_dec_rr(rr);
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
		illegal_opcode_error();
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

bool emit_ld_hl_indnn(int nn) {
	return emit_ld_rr_indnn(RR_HL, nn);
}

bool emit_ld_indnn_rr(int nn, int rr) {
	return emit_ld_rr_indnn_1(0x22, 0x43, rr, nn);
}

bool emit_ld_indnn_hl(int nn) {
	return emit_ld_indnn_rr(nn, RR_HL);
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

bool emit_ld_sp_hl(void) {
	return emit_ld_sp_x(RR_HL);
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
	emit_pre_inc_dec_rr(x);
	emit_idx_prefix(x);
	emit(opc + (R_M << 3));
	emit_idx_dis(x, dis);
	emit_pos_inc_dec_rr(x);
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

bool emit_ex_af_af1(void) {
	emit(0x08);
	return true;
}

bool emit_ex_de_x(int x) {
	if ((x & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit(0xeb);
		return true;
	}
}

bool emit_ex_de_hl(void) {
	return emit_ex_de_x(RR_HL);
}

bool emit_ex_indsp_x(int x) {
	emit_idx_prefix(x);
	emit(0xe3);
	return true;
}

bool emit_ex_indsp_hl(void) {
	return emit_ex_indsp_x(RR_HL);
}

bool emit_exx(void) {
	emit(0xd9);
	return true;
}

bool emit_push_rr(int rr) {
	emit_idx_prefix(rr);
	emit(0xc5 + (rr << 4));
	return true;
}

bool emit_pop_rr(int rr) {
	emit_idx_prefix(rr);
	emit(0xc1 + (rr << 4));
	return true;
}

bool emit_alu_r(int op, int r) {
	emit_idx_prefix(r);
	emit(0x80 + (op << 3) + r);
	return true;
}

bool emit_alu_indx(int op, int x, int dis) {
	emit_pre_inc_dec_rr(x);
	emit_idx_prefix(x);
	emit(0x80 + (op << 3) + R_M);
	emit_idx_dis(x, dis);
	emit_pos_inc_dec_rr(x);
	return true;
}

bool emit_alu_n(int op, int n) {
	emit(0xc0 + (op << 3) + R_M);
	emit(n);
	return true;
}

bool emit_add_x_rr(int x, int rr) {
	if (!check_idx_rr(x, rr)) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit_idx_prefix(x);
		emit(0x09 + (rr << 4));
		return true;
	}
}

bool emit_adc_x_rr(int x, int rr) {
	if ((x & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit(0xed);
		emit(0x4a + (rr << 4));
		return true;
	}
}

bool emit_sbc_x_rr(int x, int rr) {
	if ((x & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit(0xed);
		emit(0x42 + (rr << 4));
		return true;
	}
}

bool emit_daa(void) {
	emit(0x27);
	return true;
}

bool emit_cpl(void) {
	emit(0x2f);
	return true;
}

bool emit_neg(void) {
	emit(0xed);
	emit(0x44);
	return true;
}

bool emit_scf(void) {
	emit(0x37);
	return true;
}

bool emit_ccf(void) {
	emit(0x3f);
	return true;
}

bool emit_rla(void) {
	emit(0x17);
	return true;
}

bool emit_rra(void) {
	emit(0x1f);
	return true;
}

bool emit_rlca(void) {
	emit(0x07);
	return true;
}

bool emit_rrca(void) {
	emit(0x0f);
	return true;
}

bool emit_rot_r(int op, int r) {
	if ((r & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit(0xcb);
		emit((op << 3) + r);
		return true;
	}
}

bool emit_rot_indx(int op, int x, int dis) {
	emit_pre_inc_dec_rr(x);
	emit_idx_prefix(x);
	emit(0xcb);
	emit_idx_dis(x, dis);
	emit((op << 3) + R_M);
	emit_pos_inc_dec_rr(x);
	return true;
}

bool emit_rot_indx_r(int op, int x, int dis, int r) {
	if ((r & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit_pre_inc_dec_rr(x);
		emit_idx_prefix(x);
		emit(0xcb);
		emit_idx_dis(x, dis);
		emit((op << 3) + r);
		emit_pos_inc_dec_rr(x);
		return true;
	}
}

bool emit_rrd(void) {
	emit(0xed);
	emit(0x67);
	return true;
}

bool emit_rld(void) {
	emit(0xed);
	emit(0x6f);
	return true;
}

bool emit_sra_rr(int rr) {
    if ((rr & IDX_MASK) != IDX_HL) {
        illegal_opcode_error();
        return false;
    }
    switch (rr & RR_MASK) {
    case RR_BC: return emit_rot_r(OP_SRA, R_B) && emit_rot_r(OP_RR, R_C);
    case RR_DE: return emit_rot_r(OP_SRA, R_D) && emit_rot_r(OP_RR, R_E);
    case RR_HL: return emit_rot_r(OP_SRA, R_H) && emit_rot_r(OP_RR, R_L);
    default: illegal_opcode_error(); return false;
    }
}

bool emit_sra_bc(void) { return emit_sra_rr(RR_BC); }
bool emit_sra_de(void) { return emit_sra_rr(RR_DE); }
bool emit_sra_hl(void) { return emit_sra_rr(RR_HL); }

bool emit_bit_r(int op, int bit, int r) {
	if (bit < 0 || bit > 7) {
		range_error(bit);
		return false;
	}
	else if ((r & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit(0xcb);
		emit(op * 0x40 + (bit << 3) + r);
		return true;
	}
}

bool emit_bit_indx(int op, int bit, int x, int dis) {
	if (bit < 0 || bit > 7) {
		range_error(bit);
		return false;
	}
	else {
		emit_pre_inc_dec_rr(x);
		emit_idx_prefix(x);
		emit(0xcb);
		emit_idx_dis(x, dis);
		emit((op << 6) + (bit << 3) + R_M);
		emit_pos_inc_dec_rr(x);
		return true;
	}
}

bool emit_bit_indx_r(int op, int bit, int x, int dis, int r) {
	if (bit < 0 || bit > 7) {
		range_error(bit);
		return false;
	}
	else if ((r & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit_pre_inc_dec_rr(x);
		emit_idx_prefix(x);
		emit(0xcb);
		emit_idx_dis(x, dis);
		emit((op << 6) + (bit << 3) + r);
		emit_pos_inc_dec_rr(x);
		return true;
	}
}

bool emit_ldi(void) {
	emit(0xed);
	emit(0xa0);
	return true;
}

bool emit_ldir(void) {
	emit(0xed);
	emit(0xb0);
	return true;
}

bool emit_ldd(void) {
	emit(0xed);
	emit(0xa8);
	return true;
}

bool emit_lddr(void) {
	emit(0xed);
	emit(0xb8);
	return true;
}

bool emit_cpi(void) {
	emit(0xed);
	emit(0xa1);
	return true;
}

bool emit_cpir(void) {
	emit(0xed);
	emit(0xb1);
	return true;
}

bool emit_cpd(void) {
	emit(0xed);
	emit(0xa9);
	return true;
}

bool emit_cpdr(void) {
	emit(0xed);
	emit(0xb9);
	return true;
}

bool emit_in_f_indc(void) {
	emit(0xed);
	emit(0x70);
	return true;
}

bool emit_in_r_indc(int r) {
	if ((r & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit(0xed);
		emit(0x40 + (r << 3));
		return true;
	}
}

bool emit_in_a_indn(int n) {
	emit(0xdb);
	emit(n);
	return true;
}

bool emit_ini(void) {
	emit(0xed);
	emit(0xa2);
	return true;
}

bool emit_inir(void) {
	emit(0xed);
	emit(0xb2);
	return true;
}

bool emit_ind(void) {
	emit(0xed);
	emit(0xaa);
	return true;
}

bool emit_indr(void) {
	emit(0xed);
	emit(0xba);
	return true;
}

bool emit_out_indc_n(int n) {
	if (n != 0) {
		range_error(n);
		return false;
	}
	else {
		emit(0xed);
		emit(0x71);
		return true;
	}
}

bool emit_out_indc_r(int r) {
	if ((r & IDX_MASK) != IDX_HL) {
		illegal_opcode_error();
		return false;
	}
	else {
		emit(0xed);
		emit(0x41 + (r << 3));
		return true;
	}
}

bool emit_out_indn_a(int n) {
	emit(0xd3);
	emit(n);
	return true;
}

bool emit_outi(void) {
	emit(0xed);
	emit(0xa3);
	return true;
}

bool emit_otir(void) {
	emit(0xed);
	emit(0xb3);
	return true;
}

bool emit_outd(void) {
	emit(0xed);
	emit(0xab);
	return true;
}

bool emit_otdr(void) {
	emit(0xed);
	emit(0xbb);
	return true;
}

bool emit_nop(void) {
	emit(0x00);
	return true;
}

bool emit_di(void) {
	emit(0xf3);
	return true;
}

bool emit_ei(void) {
	emit(0xfb);
	return true;
}

bool emit_halt(void) {
	emit(0x76);
	return true;
}

bool emit_im(int im) {
	switch (im) {
	case 0: emit(0xed); emit(0x46); return true;
	case 1: emit(0xed); emit(0x56); return true;
	case 2: emit(0xed); emit(0x5e); return true;
	default: range_error(im); return false;
	}
}

static bool emit_jr_1(int opc, int addr) {
	int pc = get_pc() + 2;				// after this intruction
	int dist = addr - pc;
	if (dist < -128 || dist > 127) {
		range_error(dist);
		return false;
	}
	else {
		emit(opc);
		emit(dist);
		return true;
	}
}

bool emit_jr_nn(int nn) {
	return emit_jr_1(0x18, nn);
}

bool emit_jr_f_nn(int f, int nn) {
	if (f > F_C) {
		illegal_opcode_error();
		return false;
	}
	else
		return emit_jr_1(0x20 + (f << 3), nn);
}

bool emit_djnz_nn(int nn) {
	return emit_jr_1(0x10, nn);
}

bool emit_jp_nn(int nn) {
	emit(0xc3);
	emitw(nn);
	return true;
}

bool emit_jp_f_nn(int f, int nn) {
	emit(0xc2 + (f << 3));
	emitw(nn);
	return true;
}

bool emit_jp_x(int x) {
	emit_idx_prefix(x);
	emit(0xe9);
	return true;
}

bool emit_jp_hl(void) {
	return emit_jp_x(RR_HL);
}

bool emit_call_nn(int nn) {
	emit(0xcd);
	emitw(nn);
	return true;
}

bool emit_call_f_nn(int f, int nn) {
	emit(0xc4 + (f << 3));
	emitw(nn);
	return true;
}

bool emit_rst(int rst) {
	if (rst >= 0 && rst < 8) {
		emit(0xc7 + (rst << 3));
		return true;
	}
	else {
		switch (rst) {
		case 0x00: case 0x08: case 0x10: case 0x18: case 0x20: case 0x28: case 0x30: case 0x38:
			emit(0xc7 + rst);
			return true;
		default:
			range_error(rst);
			return false;
		}
	}
}

bool emit_ret(void) {
	emit(0xc9);
	return true;
}

bool emit_reti(void) {
	emit(0xed);
	emit(0x4d);
	return true;
}

bool emit_retn(void) {
	emit(0xed);
	emit(0x45);
	return true;
}

bool emit_ret_f(int f) {
	emit(0xc0 + (f << 3));
	return true;
}
