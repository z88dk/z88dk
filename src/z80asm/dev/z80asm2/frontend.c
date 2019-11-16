//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#include "frontend.h"
#include "backend.h"
#include "utils.h"
#include "utstring.h"

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define ___ ' '
#define CHAR_HASH(c)			(((c)-___) & 0x3f)
#define WORD_HASH(a,b,c,d,e)	((CHAR_HASH(a)<<24) | \
								 (CHAR_HASH(b)<<18) | \
								 (CHAR_HASH(c)<<12) | \
								 (CHAR_HASH(d)<< 6) | \
								  CHAR_HASH(e))

static FILE* input_file = NULL;
static char* input_filename = NULL;
static int line_num = 0;
static int num_errors = 0;
static UT_string* input_line = NULL;
static const char* ptr = NULL;

//-----------------------------------------------------------------------------
// init
//-----------------------------------------------------------------------------
static void init(void) {
	if (input_file) fclose(input_file);
	input_file = NULL;
	free(input_filename);
	input_filename = NULL;
	line_num = num_errors = 0;
	utstring_new(input_line);
	ptr = utstring_body(input_line);
}

//-----------------------------------------------------------------------------
// errors
//-----------------------------------------------------------------------------
void error_syntax(void) {
	fprintf(stderr, "Error at %s line %d: Syntax error at: %s", input_filename, line_num, ptr);
	ptr += strlen(ptr);
	num_errors++;
}

void error_range(int n) {
	fprintf(stderr, "Error at %s line %d: Range error: %d\n", input_filename, line_num, n);
	ptr += strlen(ptr);
	num_errors++;
}

void error_illegal(void) {
	fprintf(stderr, "Error at %s line %d: Illegal instruction\n", input_filename, line_num);
	ptr += strlen(ptr);
	num_errors++;
}

//-----------------------------------------------------------------------------
// parser
//-----------------------------------------------------------------------------
static void save_ptr(const char** save) {
	*save = ptr;
}

static bool restore_ptr(const char** save) {
	ptr = *save;
	return true;
}

static bool isident_start(char c) {
	return c == '_' || isalpha(c);
}

static bool isident(char c) {
	return c == '_' || isalnum(c);
}

static void blanks(void) {
	while (isspace(*ptr)) ptr++;
}

static bool parse_separator(const char* separator) {
	blanks();
	for (int i = 0; separator[i]; i++)
		if (ptr[i] != separator[i])
			return false;
	ptr += strlen(separator);
	return true;
}

static bool parse_comma(void) {
	return parse_separator(",");
}

static bool parse_tick(void) {
	return parse_separator("'");
}

static bool parse_plus(void) {
	return parse_separator("+");
}

static bool parse_minus(void) {
	return parse_separator("-");
}

static bool parse_lparen(void) {
	return parse_separator("(");
}

static bool parse_rparen(void) {
	return parse_separator(")");
}

static bool parse_word(const char* word) {
	blanks();
	for (int i = 0; word[i]; i++)
		if (toupper(ptr[i]) != toupper(word[i]))
			return false;
	if (isident(ptr[strlen(word)])) return false;
	ptr += strlen(word);
	return true;
}

static bool parse_end(void) {
	blanks();
	switch (*ptr) {
	case '\0':	return true;
	case ':':	ptr++; return true;
	case '\\':	ptr++; return true;
	case ';':	ptr += strlen(ptr); return true;
	default:	return false;
	}
}

static bool check_end(void) {
	if (!parse_end()) {
		error_syntax();
		return false;
	}
	else
		return true;
}

static bool parse_ident(UT_string *ident) {
	blanks();
	if (!isident_start(*ptr)) return false;
	const char* start_ident = ptr++;
	while (isident(*ptr)) ptr++;

	utstring_clear(ident); utstring_bincpy(ident, start_ident, ptr - start_ident);
	return true;
}

static unsigned get_word_hash(void) {
	blanks();
	if (isident_start(*ptr)) {
		char a[5] = { ___,___,___,___,___ };
		for (int i = 0; i < sizeof(a) && isident(ptr[i]); i++) {
			a[i] = toupper(ptr[i]);
		}
		return WORD_HASH(a[0], a[1], a[2], a[3], a[4]);
	}
	else {
		return 0;
	}
}

static bool parse_const(int* out_value) {	// TODO: parse expressions
	blanks();
	if (isdigit(*ptr)) {
		*out_value = (int)strtol(ptr, (char**)& ptr, 0);
		return true;
	}
	else {
		*out_value = 0;
		return false;
	}
}

static bool parse_expr(int* out_value) {	// TODO: parse expressions
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_word("ASMPC") || parse_separator("$")) {
		*out_value = get_pc();
		return true;
	}
	else {
		restore_ptr(&ptr0);
		bool negative = parse_minus() ? true : false;
		blanks();
		if (isdigit(*ptr)) {
			*out_value = (int)strtol(ptr, (char**)& ptr, 0);
			if (negative)* out_value = -*out_value;
			return true;
		}
		else {
			restore_ptr(&ptr0);
			*out_value = 0;
			return false;
		}
	}
}

static bool parse_indexpr(int* out_value) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_lparen() && parse_expr(out_value) && parse_rparen())
		return true;
	else {
		restore_ptr(&ptr0);
		*out_value = 0;
		return false;
	}
}

static bool parse_plus_offset(int* out_dis) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_rparen()) {
		*out_dis = 0;
		return true;
	}
	else if (restore_ptr(&ptr0) &&
		parse_plus() && parse_expr(out_dis) && parse_rparen()) {
		return true;
	}
	else if (restore_ptr(&ptr0) &&
		parse_minus() && parse_expr(out_dis) && parse_rparen()) {
		*out_dis = -*out_dis;
		return true;
	}
	else {
		restore_ptr(&ptr0);
		*out_dis = 0;
		return false;
	}
}

static bool parse_dot_label(UT_string* label) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_separator(".") && parse_ident(label))
		return true;
	else {
		restore_ptr(&ptr0);
		return false;
	}
}

static bool parse_label_colon(UT_string* label) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_ident(label) && parse_separator(":"))
		return true;
	else {
		restore_ptr(&ptr0);
		return false;
	}
}

static bool parse_label(UT_string* label) {
	blanks();
	return parse_dot_label(label) || parse_label_colon(label);
}

static bool parse_reg8(int* out_r) {
	blanks();
	if (isident_start(ptr[0]) && !isident(ptr[1])) {
		switch (toupper(ptr[0])) {
		case 'B': ptr++; *out_r = R_B; return true;
		case 'C': ptr++; *out_r = R_C; return true;
		case 'D': ptr++; *out_r = R_D; return true;
		case 'E': ptr++; *out_r = R_E; return true;
		case 'H': ptr++; *out_r = R_H; return true;
		case 'L': ptr++; *out_r = R_L; return true;
		case 'A': ptr++; *out_r = R_A; return true;
		default: return false;
		}
	}
	else
		return false;
}

static bool parse_reg8x(int* out_r) {
	switch (get_word_hash()) {
	case WORD_HASH('B', ___, ___, ___, ___): ptr++;		*out_r = R_B; return true;
	case WORD_HASH('C', ___, ___, ___, ___): ptr++;		*out_r = R_C; return true;
	case WORD_HASH('D', ___, ___, ___, ___): ptr++;		*out_r = R_D; return true;
	case WORD_HASH('E', ___, ___, ___, ___): ptr++;		*out_r = R_E; return true;
	case WORD_HASH('H', ___, ___, ___, ___): ptr++;		*out_r = R_H; return true;
	case WORD_HASH('L', ___, ___, ___, ___): ptr++;		*out_r = R_L; return true;
	case WORD_HASH('A', ___, ___, ___, ___): ptr++;		*out_r = R_A; return true;
	case WORD_HASH('I', 'X', 'H', ___, ___): ptr += 3;	*out_r = R_H + IDX_IX; return true;
	case WORD_HASH('I', 'Y', 'H', ___, ___): ptr += 3;	*out_r = R_H + IDX_IY; return true;
	case WORD_HASH('I', 'X', 'L', ___, ___): ptr += 3;	*out_r = R_L + IDX_IX; return true;
	case WORD_HASH('I', 'Y', 'L', ___, ___): ptr += 3;	*out_r = R_L + IDX_IY; return true;
	default: return false;
	}
}

static bool parse_reg8intel(int* out_r) {
	blanks();
	if (isident_start(ptr[0]) && !isident(ptr[1])) {
		switch (toupper(ptr[0])) {
		case 'B': ptr++; *out_r = R_B; return true;
		case 'C': ptr++; *out_r = R_C; return true;
		case 'D': ptr++; *out_r = R_D; return true;
		case 'E': ptr++; *out_r = R_E; return true;
		case 'H': ptr++; *out_r = R_H; return true;
		case 'L': ptr++; *out_r = R_L; return true;
		case 'M': ptr++; *out_r = R_M; return true;
		case 'A': ptr++; *out_r = R_A; return true;
		default: return false;
		}
	}
	else
		return false;
}

static bool parse_reg16sp(int* out_ss) {
	switch (get_word_hash()) {
	case WORD_HASH('B', 'C', ___, ___, ___):	ptr += 2; *out_ss = RR_BC; return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	ptr += 2; *out_ss = RR_DE; return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	ptr += 2; *out_ss = RR_HL; return true;
	case WORD_HASH('I', 'X', ___, ___, ___):	ptr += 2; *out_ss = RR_HL + IDX_IX; return true;
	case WORD_HASH('I', 'Y', ___, ___, ___):	ptr += 2; *out_ss = RR_HL + IDX_IY; return true;
	case WORD_HASH('S', 'P', ___, ___, ___):	ptr += 2; *out_ss = RR_SP; return true;
	default: return false;
	}
}

static bool parse_reg16sp_intel(int* out_ss) {
	switch (get_word_hash()) {
	case WORD_HASH('B', ___, ___, ___, ___):	ptr += 1; *out_ss = RR_BC; return true;
	case WORD_HASH('B', 'C', ___, ___, ___):	ptr += 2; *out_ss = RR_BC; return true;
	case WORD_HASH('D', ___, ___, ___, ___):	ptr += 1; *out_ss = RR_DE; return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	ptr += 2; *out_ss = RR_DE; return true;
	case WORD_HASH('H', ___, ___, ___, ___):	ptr += 1; *out_ss = RR_HL; return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	ptr += 2; *out_ss = RR_HL; return true;
	case WORD_HASH('S', 'P', ___, ___, ___):	ptr += 2; *out_ss = RR_SP; return true;
	default: return false;
	}
}

static bool parse_reg16af(int* out_dd) {
	switch (get_word_hash()) {
	case WORD_HASH('B', 'C', ___, ___, ___):	ptr += 2; *out_dd = RR_BC; return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	ptr += 2; *out_dd = RR_DE; return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	ptr += 2; *out_dd = RR_HL; return true;
	case WORD_HASH('I', 'X', ___, ___, ___):	ptr += 2; *out_dd = RR_HL + IDX_IX; return true;
	case WORD_HASH('I', 'Y', ___, ___, ___):	ptr += 2; *out_dd = RR_HL + IDX_IY; return true;
	case WORD_HASH('A', 'F', ___, ___, ___):	ptr += 2; *out_dd = RR_AF; return true;
	default: return false;
	}
}

static bool parse_reg16af_intel(int* out_dd) {
	switch (get_word_hash()) {
	case WORD_HASH('B', ___, ___, ___, ___):	ptr += 1; *out_dd = RR_BC; return true;
	case WORD_HASH('B', 'C', ___, ___, ___):	ptr += 2; *out_dd = RR_BC; return true;
	case WORD_HASH('D', ___, ___, ___, ___):	ptr += 1; *out_dd = RR_DE; return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	ptr += 2; *out_dd = RR_DE; return true;
	case WORD_HASH('H', ___, ___, ___, ___):	ptr += 1; *out_dd = RR_HL; return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	ptr += 2; *out_dd = RR_HL; return true;
	case WORD_HASH('P', 'S', 'W', ___, ___):	ptr += 3; *out_dd = RR_AF; return true;
	default: return false;
	}
}

static bool parse_a(void) {
	return parse_word("A");
}

static bool parse_f(void) {
	return parse_word("F");
}

static bool parse_af(void) {
	return parse_word("AF");
}

static bool parse_i(void) {
	return parse_word("I");
}

static bool parse_r(void) {
	return parse_word("R");
}

static int parse_pos_inc_dec(int rr) {
	if      (parse_plus())		return rr + POS_INC;
	else if (parse_minus())		return rr + POS_DEC;
	else						return rr;
}

static void emit_pos_inc_dec(int rr) {
	if      ((rr & POS_MASK) == POS_INC)	emit(0x03 + (rr << 4));
	else if ((rr & POS_MASK) == POS_DEC)	emit(0x0b + (rr << 4)); 
}

static bool parse_ind_BCDE(int* out_dd) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_lparen()) {
		switch (get_word_hash()) {
		case WORD_HASH('B', 'C', ___, ___, ___):	ptr += 2; *out_dd = parse_pos_inc_dec(RR_BC); if (parse_rparen()) return true; else break;
		case WORD_HASH('D', 'E', ___, ___, ___):	ptr += 2; *out_dd = parse_pos_inc_dec(RR_DE); if (parse_rparen()) return true; else break;
		}
	}
	restore_ptr(&ptr0);
	return false;
}

static bool parse_B(void) {
	return parse_word("B");
}

static bool parse_indC(void) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_lparen() && parse_word("C") && parse_rparen()) {
		return true;
	}
	restore_ptr(&ptr0);
	return false;
}

static bool parse_BC(void) {
	return parse_word("BC");
}

static bool parse_D(void) {
	return parse_word("D");
}

static bool parse_DE(void) {
	return parse_word("DE");
}

static bool parse_H(void) {
	return parse_word("H");
}

static bool parse_HL(void) {
	return parse_word("HL");
}

static bool parse_indHL(void) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_lparen() && parse_HL() && parse_rparen())
		return true;
	restore_ptr(&ptr0);
	return false;
}

static bool parse_HLx(int* out_idx) {
	return parse_reg16sp(out_idx) && (*out_idx & RR_MASK) == RR_HL;
}

static bool parse_indHLx(int *x, int* out_dis) {
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_lparen()) {
		switch (get_word_hash()) {
		case WORD_HASH('H', 'L', ___, ___, ___): ptr += 2; *x = parse_pos_inc_dec(RR_HL); *out_dis = 0; if (parse_rparen()) return true; else break;
		case WORD_HASH('H', 'L', 'I', ___, ___): ptr += 3; *x = RR_HL + POS_INC; *out_dis = 0; if (parse_rparen()) return true; else break;
		case WORD_HASH('H', 'L', 'D', ___, ___): ptr += 3; *x = RR_HL + POS_DEC; *out_dis = 0; if (parse_rparen()) return true; else break;
		case WORD_HASH('I', 'X', ___, ___, ___): ptr += 2; *x = RR_HL + IDX_IX; if (parse_plus_offset(out_dis)) return true; else break;
		case WORD_HASH('I', 'Y', ___, ___, ___): ptr += 2; *x = RR_HL + IDX_IY; if (parse_plus_offset(out_dis)) return true; else break;
		}
	}
	restore_ptr(&ptr0);
	return false;
}

static bool parse_M(void) {
	return parse_word("M");
}

static bool parse_SP(void) {
	return parse_word("SP");
}

static bool parse_flags8(int* out_flags) {
	switch (get_word_hash()) {
	case WORD_HASH('N', 'Z', ___, ___, ___):	ptr += 2; *out_flags = F_NZ; return true;
	case WORD_HASH('Z', ___, ___, ___, ___):	ptr += 1; *out_flags = F_Z;  return true;
	case WORD_HASH('N', 'C', ___, ___, ___):	ptr += 2; *out_flags = F_NC; return true;
	case WORD_HASH('C', ___, ___, ___, ___):	ptr += 1; *out_flags = F_C;  return true;
	case WORD_HASH('P', 'O', ___, ___, ___):	ptr += 2; *out_flags = F_PO; return true;
	case WORD_HASH('P', 'E', ___, ___, ___):	ptr += 2; *out_flags = F_PE; return true;
	case WORD_HASH('P', ___, ___, ___, ___):	ptr += 1; *out_flags = F_P;  return true;
	case WORD_HASH('M', ___, ___, ___, ___):	ptr += 1; *out_flags = F_M;  return true;
	case WORD_HASH('N', 'V', ___, ___, ___):	ptr += 2; *out_flags = F_NV; return true;
	case WORD_HASH('V', ___, ___, ___, ___):	ptr += 1; *out_flags = F_V;  return true;
	default: return false;
	}
}

static bool parse_flags4(int* out_flags) {
	switch (get_word_hash()) {
	case WORD_HASH('N', 'Z', ___, ___, ___):	ptr += 2; *out_flags = F_NZ; return true;
	case WORD_HASH('Z', ___, ___, ___, ___):	ptr += 1; *out_flags = F_Z;  return true;
	case WORD_HASH('N', 'C', ___, ___, ___):	ptr += 2; *out_flags = F_NC; return true;
	case WORD_HASH('C', ___, ___, ___, ___):	ptr += 1; *out_flags = F_C;  return true;
	default: return false;
	}
}

static bool parse_alu8(int op) {
	int r, n, x, dis;
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (!(parse_a() && parse_comma())) 		// alu: a, is optional
		restore_ptr(&ptr0);

	const char* ptr1; blanks(); save_ptr(&ptr1);
	if (parse_reg8x(&r) && check_end()) {	// alu B/C/D/E/H/L/A/IXH/IYH/IXL/IYL
		if ((r & IDX_MASK) == IDX_IX) emit(0xdd); else if ((r & IDX_MASK) == IDX_IY) emit(0xfd);
		emit(0x80 + (op << 3) + r);
		return true;
	}
	else if (restore_ptr(&ptr1) &&
		parse_indHLx(&x, &dis) && check_end()) {	// alu (HL)/(IX+d)/(IY+d)
		if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
		emit(0x80 + (op << 3) + R_M);
		if ((x & IDX_MASK) != IDX_HL) emit(dis); else;
		emit_pos_inc_dec(x);
		return true;
	}
	else if (restore_ptr(&ptr1) &&
		parse_expr(&n) && check_end()) {	// alu n
		emit(0xc0 + (op << 3) + R_M);
		emit(n);
		return true;
	}
	else {
		restore_ptr(&ptr0);
		return false;
	}
}

static bool parse_rot8(int op) {
	int r, x, dis;
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_reg8(&r) && check_end()) {	// rot B/C/D/E/H/L/A
		emit(0xcb);
		emit((op << 3) + r);
		return true;
	}
	else if (restore_ptr(&ptr0) &&
		parse_indHLx(&x, &dis) && parse_comma() && parse_reg8(&r) && check_end()) {	// rot (HL)/(IX+d)/(IY+d), r
		if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
		emit(0xcb);
		if ((x & IDX_MASK) != IDX_HL) emit(dis); else;
		emit((op << 3) + r);
		return true;
	}
	else if (restore_ptr(&ptr0) &&
		parse_indHLx(&x, &dis) && check_end()) {	// rot (HL)/(IX+d)/(IY+d)
		if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
		emit(0xcb);
		if ((x & IDX_MASK) != IDX_HL) emit(dis); else;
		emit((op << 3) + R_M);
		return true;
	}
	else {
		restore_ptr(&ptr0);
		return false;
	}
}

static bool parse_alu8intel(int op) {
	int r;
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_reg8intel(&r) && check_end()) {	// alu B/C/D/E/H/L/M/A
		emit(0x80 + (op << 3) + r);
		return true;
	}
	restore_ptr(&ptr0);
	return false;
}

static bool parse_bit8(int op) {
	int r, x, bit, dis;
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_const(&bit) && parse_comma()) {
		if (bit < 0 || bit > 7) {
			error_range(bit);
			return false;
		}
		const char* ptr1; blanks(); save_ptr(&ptr1);
		if (parse_reg8(&r) && check_end()) {	// bit/res/set b, B/C/D/E/H/L/A
			emit(0xcb);
			emit(op * 0x40 + (bit << 3) + r);
			return true;
		}
		else if (restore_ptr(&ptr1) &&
			parse_indHLx(&x, &dis) && check_end()) {	// bit/res/set b, (HL)/(IX+d)/(IY+d)
			if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0xcb);
			if ((x & IDX_MASK) != IDX_HL) emit(dis); else;
			emit(op * 0x40 + (bit << 3) + R_M);
			emit_pos_inc_dec(x);
			return true;
		}
	}
	restore_ptr(&ptr0);
	return false;
}

static bool parse_jump_call(int uncond_opcode, int cond_opcode) {
	int nn, flags;
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_flags8(&flags) && parse_comma() && parse_expr(&nn) && check_end()) {	// call/jp flag, nn
		emit(cond_opcode + (flags << 3));
		emitw(nn);
		return true;
	}
	else if (restore_ptr(&ptr0) && parse_expr(&nn) && check_end()) {	// call/jp nn
		emit(uncond_opcode);
		emitw(nn);
		return true;
	}
	restore_ptr(&ptr0);
	return false;
}

static bool parse_jump_call_intel(int cond_opcode, int flags) {
	int nn;
	const char* ptr0; blanks(); save_ptr(&ptr0);
	if (parse_expr(&nn) && check_end()) {
		emit(cond_opcode + (flags << 3));
		emitw(nn);
		return true;
	}
	restore_ptr(&ptr0);
	return false;
}

static bool parse_statement(void) {
	int n, nn, dis, im, rst, addr, flags, r, r1, r2, x, rr;
	if (parse_end())
		return true;
	switch (get_word_hash()) {
	// load
	case WORD_HASH('L', 'D', ___, ___, ___): {
		ptr += 2;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_reg8x(&r1) && parse_comma() && parse_reg8x(&r2) && check_end())		// LD r, r
			return emit_ld_r_r(r1, r2);
		else if (restore_ptr(&ptr0) &&
			parse_reg8(&r) && parse_comma() && parse_indHLx(&x, &dis) && check_end())	// LD r, (HL)/(IX+d)/(IY+d)
			return emit_ld_r_indx(r, x, dis);
		else if (restore_ptr(&ptr0) &&
			parse_indHLx(&x, &dis) && parse_comma() && parse_reg8(&r) && check_end())	// LD (HL)/(IX+d)/(IY+d), r
			return emit_ld_indx_r(x, dis, r);
		if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_ind_BCDE(&rr) && check_end())			// LD A, (BC/DE)
			return emit_ld_a_indrr(rr);
		else if (restore_ptr(&ptr0) &&
			parse_ind_BCDE(&rr) && parse_comma() && parse_a() && check_end())			// LD (BC/DE), A
			return emit_ld_indrr_a(rr);
		else if (restore_ptr(&ptr0) &&
			parse_reg8x(&r) && parse_comma() && parse_expr(&n) && check_end())			// LD B/C/D/E/H/L/A, n
			return emit_ld_r_n(r, n);
		else if (restore_ptr(&ptr0) &&
			parse_indHLx(&x, &dis) && parse_comma() && parse_expr(&n) && check_end())	// LD (HL)/(IX+d)/(IY+d), n
			return emit_ld_indx_n(x, dis, n);
		else if (restore_ptr(&ptr0) &&
			parse_reg16sp(&rr) && parse_comma() && parse_expr(&nn) && check_end())		// LD BC/DE/HL/SP/IX/IY, nn
			return emit_ld_rr_nn(rr, nn);
		else if (restore_ptr(&ptr0) &&
			parse_reg16sp(&rr) && parse_comma() && parse_indexpr(&nn) && check_end())	// LD BC/DE/HL/SP/IX/IY, (nn)
			return emit_ld_rr_indnn(rr, nn);
		else if (restore_ptr(&ptr0) &&
			parse_indexpr(&nn) && parse_comma() && parse_reg16sp(&rr) && check_end())	// LD (nn), BC/DE/HL/SP/IX/IY
			return emit_ld_indnn_rr(nn, rr);
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_indexpr(&nn) && check_end())			// LD A, (nn)
			return emit_ld_a_indnn(nn);
		else if (restore_ptr(&ptr0) &&
			parse_indexpr(&nn) && parse_comma() && parse_a() && check_end())			// LD (nn), A
			return emit_ld_indnn_a(nn);
		else if (restore_ptr(&ptr0) &&
			parse_i() && parse_comma() && parse_a() && check_end())						// LD I, A
			return emit_ld_i_a();
		else if (restore_ptr(&ptr0) &&
			parse_r() && parse_comma() && parse_a() && check_end())						// LD R, A
			return emit_ld_r_a();
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_i() && check_end())						// LD A, I
			return emit_ld_a_i();
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_r() && check_end())						// LD A, R
			return emit_ld_a_r();
		else if (restore_ptr(&ptr0) &&
			parse_SP() && parse_comma() && parse_HLx(&x) && check_end())				// LD SP, HL/IX/IY
			return emit_ld_sp_x(x);
		else if (restore_ptr(&ptr0) &&
			parse_BC() && parse_comma() && parse_DE() && check_end()) 					// LD BC, DE
			return (
				emit_ld_r_r(R_B, R_D) &&
				emit_ld_r_r(R_C, R_E));
		else if (restore_ptr(&ptr0) &&
			parse_BC() && parse_comma() && parse_HLx(&x) && check_end())				// LD BC, HL/IX/IY
			return (
				emit_ld_r_r(R_B, R_H | (x & IDX_MASK)) &&
				emit_ld_r_r(R_C, R_L | (x & IDX_MASK)));
		else if (restore_ptr(&ptr0) &&
			parse_DE() && parse_comma() && parse_BC() && check_end())					// LD DE, BC
			return (
				emit_ld_r_r(R_D, R_B) &&
				emit_ld_r_r(R_E, R_C));
		else if (restore_ptr(&ptr0) &&
			parse_DE() && parse_comma() && parse_HLx(&x) && check_end())				// LD DE, HL/IX/IY
			return (
				emit_ld_r_r(R_D, R_H | (x & IDX_MASK)) &&
				emit_ld_r_r(R_E, R_L | (x & IDX_MASK)));
		else if (restore_ptr(&ptr0) &&
			parse_HLx(&x) && parse_comma() && parse_BC() && check_end())				// LD HL/IX/IY, BC
			return (
				emit_ld_r_r(R_H | (x & IDX_MASK), R_B) &&
				emit_ld_r_r(R_L | (x & IDX_MASK), R_C));
		else if (restore_ptr(&ptr0) &&
			parse_HLx(&x) && parse_comma() && parse_DE() && check_end())				// LD HL/IX/IY, DE
			return (
				emit_ld_r_r(R_H | (x & IDX_MASK), R_D) &&
				emit_ld_r_r(R_L | (x & IDX_MASK), R_E));
		else 
			restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('L', 'D', 'A', ___, ___): {
		ptr += 3;	
		if (parse_expr(&nn) && check_end()) 											// LDA
			return emit_ld_a_indnn(nn);
		break;
	}
	case WORD_HASH('S', 'T', 'A', ___, ___): {
		ptr += 3;
		if (parse_expr(&nn) && check_end()) 											// STA
			return emit_ld_indnn_a(nn);
		break;
	}
	case WORD_HASH('L', 'H', 'L', 'D', ___): {
		ptr += 4;
		if (parse_expr(&nn) && check_end()) 											// LHLD nn
			return emit_ld_rr_indnn(RR_HL, nn);
		break;
	}
	case WORD_HASH('S', 'H', 'L', 'D', ___): {
		ptr += 4;
		if (parse_expr(&nn) && check_end()) 											// SHLD nn
			return emit_ld_indnn_rr(nn, RR_HL);
		break;
	}
	case WORD_HASH('L', 'D', 'A', 'X', ___): {
		ptr += 4;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if ((parse_B() || parse_BC()) && check_end()) 									// LDAX B/BC
			return emit_ld_a_indrr(RR_BC);
		else if (restore_ptr(&ptr0) &&
			(parse_D() || parse_DE()) && check_end()) 									// LDAX D/DE
			return emit_ld_a_indrr(RR_DE);
		break;
	}
	case WORD_HASH('S', 'T', 'A', 'X', ___): {
		ptr += 4;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if ((parse_B() || parse_BC()) && check_end()) 									// STAX B/BC
			return emit_ld_indrr_a(RR_BC);
		else if (restore_ptr(&ptr0) &&
			(parse_D() || parse_DE()) && check_end()) 									// STAX D/DE
			return emit_ld_indrr_a(RR_DE);
		break;
	}
	case WORD_HASH('L', 'X', 'I', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if ((parse_B() || parse_BC()) && parse_comma() && parse_expr(&nn) && check_end())	// LXI B/BC, nn
			return emit_ld_rr_nn(RR_BC, nn);
		else if (restore_ptr(&ptr0) &&
			(parse_D() || parse_DE()) && parse_comma() && parse_expr(&nn) && check_end())	// LXI D/DE, nn
			return emit_ld_rr_nn(RR_DE, nn);
		else if (restore_ptr(&ptr0) &&
			(parse_H() || parse_HL()) && parse_comma() && parse_expr(&nn) && check_end())	// LXI H/HL, nn
			return emit_ld_rr_nn(RR_HL, nn);
		else if (restore_ptr(&ptr0) &&
			parse_SP() && parse_comma() && parse_expr(&nn) && check_end())					// LXI SP, nn
			return emit_ld_rr_nn(RR_SP, nn);
		break;
	}
	case WORD_HASH('M', 'O', 'V', ___, ___): {
		ptr += 3;
		if (parse_reg8intel(&r1) && parse_comma() && parse_reg8intel(&r2) && check_end())	// MOV r, r
			return emit_ld_r_r(r1, r2);
		break;
	}
	case WORD_HASH('M', 'V', 'I', ___, ___): {
		ptr += 3;
		if (parse_reg8intel(&r) && parse_comma() && parse_expr(&n) && check_end())			// MVI r, n
			return emit_ld_r_n(r, n);
		break;
	}
	case WORD_HASH('S', 'P', 'H', 'L', ___): {
		ptr += 4;
		if (check_end())																	// SPHL
			return emit_ld_sp_x(RR_HL);
		break;
	}

	// exchange
	case WORD_HASH('E', 'X', ___, ___, ___): {
		ptr += 2;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_af() && parse_comma() && parse_af() && (parse_tick() || true) && check_end()) {	// EX AF, AF[']
			emit(0x08);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_DE() && parse_comma() && parse_HLx(&x) && (x & IDX_MASK) == IDX_HL && check_end()) {	// EX DE, HL
			emit(0xeb);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_lparen() && parse_SP() && parse_rparen() && parse_comma() &&
			parse_HLx(&x) && check_end()) {	// EX (SP),HL/IX/IY
			if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0xe3);
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('E', 'X', 'X', ___, ___): {
		ptr += 3;
		if (check_end()) {	// EXX
			emit(0xd9);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'C', 'H', 'G', ___): {
		ptr += 4;
		if (check_end()) {	// XCHG
			emit(0xeb);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'T', 'H', 'L', ___): {
		ptr += 4;
		if (check_end()) {	// XTHL
			emit(0xe3);
			return true;
		}
		break;
	}

	// block transfer
	case WORD_HASH('L', 'D', 'I', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_ind_BCDE(&rr) && parse_comma() && parse_a() && check_end()) {	// LDI (BC/DE), A
			emit(0x02 + (rr << 4));
			emit(0x03 + (rr << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_ind_BCDE(&rr) && check_end()) {	// LDI A, (BC/DE)
			emit(0x0a + (rr << 4));
			emit(0x03 + (rr << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_indHL() && parse_comma() && parse_a() && check_end()) {	// LDI (HL), A
			emit(0x40 + (R_M << 3) + R_A);
			emit(0x03 + (RR_HL << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_indHL() && check_end()) {	// LDI A, (HL)
			emit(0x40 + (R_A << 3) + R_M);
			emit(0x03 + (RR_HL << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			check_end()) {	// LDI
			emit(0xed);
			emit(0xa0);
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('L', 'D', 'I', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// LDIR
			emit(0xed);
			emit(0xb0);
			return true;
		}
		break;
	}
	case WORD_HASH('L', 'D', 'D', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_ind_BCDE(&rr) && parse_comma() && parse_a() && check_end()) {	// LDD (BC/DE), A
			emit(0x02 + (rr << 4));
			emit(0x0b + (rr << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_ind_BCDE(&rr) && check_end()) {	// LDD A, (BC/DE)
			emit(0x0a + (rr << 4));
			emit(0x0b + (rr << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_indHL() && parse_comma() && parse_a() && check_end()) {	// LDD (HL), A
			emit(0x40 + (R_M << 3) + R_A);
			emit(0x0b + (RR_HL << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_indHL() && check_end()) {	// LDD A, (HL)
			emit(0x40 + (R_A << 3) + R_M);
			emit(0x0b + (RR_HL << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			check_end()) {	// LDD
			emit(0xed);
			emit(0xa8);
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('L', 'D', 'D', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// LDDR
			emit(0xed);
			emit(0xb8);
			return true;
		}
		break;
	}

	// search
	case WORD_HASH('C', 'P', 'I', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_expr(&n) && check_end()) {	// CPI n
			emit(0xfe);
			emit(n);
			return true;
		}
		else if (restore_ptr(&ptr0) && check_end()) {	// CPI
			emit(0xed);
			emit(0xa1);
			return true;
		}
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('C', 'P', 'I', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// CPIR
			emit(0xed);
			emit(0xb1);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', 'D', ___, ___): {
		ptr += 3;
		if (check_end()) {	// CPD
			emit(0xed);
			emit(0xa9);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', 'D', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// CPIR
			emit(0xed);
			emit(0xb9);
			return true;
		}
		break;
	}

	// arithmetic
	case WORD_HASH('A', 'D', 'D', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_alu8(0))
			return true;
		else if (restore_ptr(&ptr0) &&
			parse_M() && check_end()) {	// ADD m
			emit(0x86);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_HLx(&x) && parse_comma() && parse_reg16sp(&rr) && check_end()) {	// ADD HL/IX/IY, BC/DE/HL/SP/IX/IY
			// TODO: disallow add hl, ix
			if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0x09 + (rr << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_BC() && parse_comma() && parse_expr(&nn) && check_end()) {	// ADD BC, nn
			emit(0xe5);		// push hl
			emit(0x21);		// ld hl, nn
			emitw(nn);
			emit(0x09);		// add hl, bc
			emit(0x44);		// ld b, h
			emit(0x4d);		// ld c, l
			emit(0xe1);		// pop hl
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_DE() && parse_comma() && parse_expr(&nn) && check_end()) {	// ADD DE, nn
			emit(0xe5);		// push hl
			emit(0x21);		// ld hl, nn
			emitw(nn);
			emit(0x19);		// add hl, de
			emit(0x54);		// ld d, h
			emit(0x5d);		// ld e, l
			emit(0xe1);		// pop hl
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_HLx(&x) && parse_comma() && parse_expr(&nn) && check_end()) {	// ADD HL/IX/IY, nn
			emit(0xd5);		// push de
			emit(0x11);		// ld de, nn
			emitw(nn);
			if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0x19);		// add hl, de
			emit(0xd1);		// pop de
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('D', 'A', 'D', ___, ___): {
		ptr += 3;
		if (parse_reg16sp_intel(&rr) && check_end()) {	// DAD m
			emit(0x09 + (rr << 4));
			return true;
		}
		break;
	}
	case WORD_HASH('A', 'D', 'I', ___, ___): {
		ptr += 3;
		if (parse_expr(&n) && check_end()) {	// ADI n
			emit(0xc6);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('A', 'D', 'C', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_alu8(1))
			return true;
		else if (restore_ptr(&ptr0) &&
			parse_M() && check_end()) {	// ADC m
			emit(0x8e);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_HLx(&x) && (x & IDX_MASK) == IDX_HL && parse_comma() && parse_reg16sp(&rr) && check_end()) {	// ADC HL, BC/DE/HL/SP
			emit(0xed);
			emit(0x4a + (rr << 4));
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('A', 'C', 'I', ___, ___): {
		ptr += 3;
		if (parse_expr(&n) && check_end()) {	// ACI n
			emit(0xce);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'U', 'B', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_alu8(2))
			return true;
		else if (restore_ptr(&ptr0) && parse_reg8intel(&r) && check_end()) {	// SUB r
			emit(0x90 + r);
			return true;
		}
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('S', 'U', 'I', ___, ___): {
		ptr += 3;
		if (parse_expr(&n) && check_end()) {	// SUI n
			emit(0xd6);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'B', 'C', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_alu8(3))
			return true;
		else if (restore_ptr(&ptr0) &&
			parse_HLx(&x) && (x & IDX_MASK) == IDX_HL && parse_comma() && parse_reg16sp(&rr) && check_end()) {	// SBC HL, BC/DE/HL/SP
			emit(0xed);
			emit(0x42 + (rr << 4));
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('S', 'B', 'B', ___, ___): {
		ptr += 3;
		if (parse_alu8intel(3))
			return true;
		break;
	}
	case WORD_HASH('S', 'B', 'I', ___, ___): {
		ptr += 3;
		if (parse_expr(&n) && check_end()) {	// SBI n
			emit(0xde);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', ___, ___, ___): {
		ptr += 2;
		if (parse_alu8(7))
			return true;
		break;
	}
	case WORD_HASH('C', 'M', 'P', ___, ___): {
		ptr += 3;
		if (parse_alu8(7) || parse_alu8intel(7))
			return true;
		break;
	}
	case WORD_HASH('D', 'A', 'A', ___, ___): {
		ptr += 3;
		if (check_end()) {	// DAA
			emit(0x27);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', 'L', ___, ___): {
		ptr += 3;
		if ((parse_a() || true) && check_end()) {	// CPL [A]
			emit(0x2f);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'M', 'A', ___, ___): {
		ptr += 3;
		if (check_end()) {	// CMA
			emit(0x2f);
			return true;
		}
		break;
	}
	case WORD_HASH('N', 'E', 'G', ___, ___): {
		ptr += 3;
		if ((parse_a() || true) && check_end()) {	// NEG [A]
			emit(0xed);
			emit(0x44);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'C', 'F', ___, ___): {
		ptr += 3;
		if (check_end()) {	// SCF
			emit(0x37);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'T', 'C', ___, ___): {
		ptr += 3;
		if (check_end()) {	// STC
			emit(0x37);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'C', 'F', ___, ___): {
		ptr += 3;
		if (check_end()) {	// CCF
			emit(0x3f);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'M', 'C', ___, ___): {
		ptr += 3;
		if (check_end()) {	// CMC
			emit(0x3f);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'C', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_reg16sp(&rr) && check_end()) 	// INC/DEC BC/DE/HL/SP/IX/IY
			return emit_inc_rr(rr);
		else if (restore_ptr(&ptr0) &&
			parse_reg8x(&r) && check_end())		// INC/DEC B/C/D/E/H/L/A/IXH/IYH/IXL/IYL
			return emit_inc_r(r);
		else if (restore_ptr(&ptr0) &&
			parse_indHLx(&x, &dis) && check_end()) 	// INC/DEC (HL)/(IX+d)/(IY+d)
			return emit_inc_indx(x, dis);
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('I', 'N', 'R', ___, ___): {
		ptr += 3;
		if (parse_reg8intel(&r) && check_end()) {
			emit(0x04 + (r << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'X', ___, ___): {
		ptr += 3;
		if (parse_reg16sp_intel(&rr) && check_end()) {
			emit(0x03 + (rr << 4));
			return true;
		}
		break;
	}
	case WORD_HASH('D', 'E', 'C', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_reg16sp(&rr) && check_end()) 	// INC/DEC BC/DE/HL/SP/IX/IY
			return emit_dec_rr(rr);
		else if (restore_ptr(&ptr0) &&
			parse_reg8x(&r) && check_end())		// INC/DEC B/C/D/E/H/L/A/IXH/IYH/IXL/IYL
			return emit_dec_r(r);
		else if (restore_ptr(&ptr0) &&
			parse_indHLx(&x, &dis) && check_end()) 	// INC/DEC (HL)/(IX+d)/(IY+d)
			return emit_dec_indx(x, dis);
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('D', 'C', 'R', ___, ___): {
		ptr += 3;
		if (parse_reg8intel(&r) && check_end()) {
			emit(0x05 + (r << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('D', 'C', 'X', ___, ___): {
		ptr += 3;
		if (parse_reg16sp_intel(&rr) && check_end()) {
			emit(0x0b + (rr << 4));
			return true;
		}
		break;
	}

	// logical
	case WORD_HASH('A', 'N', 'D', ___, ___): {
		ptr += 3;
		if (parse_alu8(4))
			return true;
		break;
	}
	case WORD_HASH('A', 'N', 'A', ___, ___): {
		ptr += 3;
		if (parse_reg8intel(&r) && check_end()) {	// ANA r
			emit(0xa0 + r);
			return true;
		}
		break;
	}
	case WORD_HASH('A', 'N', 'I', ___, ___): {
		ptr += 3;
		if (parse_expr(&n) && check_end()) {	// ANI n
			emit(0xe6);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'R', ___, ___, ___): {
		ptr += 2;
		if (parse_alu8(6))
			return true;
		break;
	}
	case WORD_HASH('O', 'R', 'A', ___, ___): {
		ptr += 3;
		if (parse_reg8intel(&r) && check_end()) {	// ORA r
			emit(0xb0 + r);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'R', 'I', ___, ___): {
		ptr += 3;
		if (parse_expr(&n) && check_end()) {	// ORI n
			emit(0xf6);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'O', 'R', ___, ___): {
		ptr += 3;
		if (parse_alu8(5))
			return true;
		break;
	}
	case WORD_HASH('X', 'R', 'A', ___, ___): {
		ptr += 3;
		if (parse_reg8intel(&r) && check_end()) {	// XRA r
			emit(0xa8 + r);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'R', 'I', ___, ___): {
		ptr += 3;
		if (parse_expr(&n) && check_end()) {	// XRI n
			emit(0xee);
			emit(n);
			return true;
		}
		break;
	}

	// rotate
	case WORD_HASH('R', 'L', 'A', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RLA
			emit(0x17);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'A', 'L', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RAL
			emit(0x17);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'L', 'C', 'A', ___): {
		ptr += 4;
		if (check_end()) {	// RLCA
			emit(0x07);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'R', 'A', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RRA
			emit(0x1f);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'A', 'R', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RAR
			emit(0x1f);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'R', 'C', 'A', ___): {
		ptr += 4;
		if (check_end()) {	// RRCA
			emit(0x0f);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'L', 'C', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_rot8(0))	// RLC r
			return true;
		else if (restore_ptr(&ptr0) && check_end()) {	// RLC
			emit(0x07);
			return true;
		}
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('R', 'R', 'C', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_rot8(1))	// RRC r
			return true;
		else if (restore_ptr(&ptr0) && check_end()) {	// RRC
			emit(0x0f);
			return true;
		}
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('R', 'L', ___, ___, ___): {
		ptr += 2;
		if (parse_rot8(2))	// RL r
			return true;
		break;
	}
	case WORD_HASH('R', 'R', ___, ___, ___): {
		ptr += 2;
		if (parse_rot8(3))	// RR r
			return true;
		break;
	}
	case WORD_HASH('S', 'L', 'A', ___, ___): {
		ptr += 3;
		if (parse_rot8(4))	// SLA r
			return true;
		break;
	}
	case WORD_HASH('S', 'R', 'A', ___, ___): {
		ptr += 3;
		if (parse_rot8(5))	// SRA r
			return true;
		break;
	}
	case WORD_HASH('S', 'L', 'L', ___, ___): {
		ptr += 3;
		if (parse_rot8(6))	// SLL r
			return true;
		break;
	}
	case WORD_HASH('S', 'L', 'I', ___, ___): {
		ptr += 3;
		if (parse_rot8(6))	// SLI r
			return true;
		break;
	}
	case WORD_HASH('S', 'R', 'L', ___, ___): {
		ptr += 3;
		if (parse_rot8(7))	// SRL r
			return true;
		break;
	}
	case WORD_HASH('R', 'R', 'D', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RRD
			emit(0xed);
			emit(0x67);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'L', 'D', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RLD
			emit(0xed);
			emit(0x6f);
			return true;
		}
		break;
	}

	// bits
	case WORD_HASH('B', 'I', 'T', ___, ___): {
		ptr += 3;
		if (parse_bit8(1))
			return true;
		break;
	}
	case WORD_HASH('R', 'E', 'S', ___, ___): {
		ptr += 3;
		if (parse_bit8(2))
			return true;
		break;
	}
	case WORD_HASH('S', 'E', 'T', ___, ___): {
		ptr += 3;
		if (parse_bit8(3))
			return true;
		break;
	}

	// input/output
	case WORD_HASH('I', 'N', ___, ___, ___): {
		ptr += 2;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_f() && parse_comma() && parse_indC() && check_end()) {	// IN F, (C)
			emit(0xed);
			emit(0x70);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_indC() && check_end()) {	// IN (C)
			emit(0xed);
			emit(0x70);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_reg8(&r) && parse_comma() && parse_indC() && check_end()) {	// IN r, (C)
			emit(0xed);
			emit(0x40 + (r << 3));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_a() && parse_comma() && parse_indexpr(&n) && check_end()) {	// IN A, (n)
			emit(0xdb);
			emit(n);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_expr(&n) && check_end()) {	// IN n
			emit(0xdb);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'I', ___, ___): {
		ptr += 3;
		if (check_end()) {	// INI
			emit(0xed);
			emit(0xa2);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'I', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// INIR
			emit(0xed);
			emit(0xb2);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'D', ___, ___): {
		ptr += 3;
		if (check_end()) {	// IND
			emit(0xed);
			emit(0xaa);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'D', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// INDR
			emit(0xed);
			emit(0xba);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'U', 'T', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_indC() && parse_comma() && parse_const(&n) && check_end()) {	// OUT (C), 0
			if (n != 0)
				error_range(n);
			else {
				emit(0xed);
				emit(0x71);
				return true;
			}
		}
		else if (restore_ptr(&ptr0) &&
			parse_indC() && parse_comma() && parse_reg8(&r) && check_end()) {	// OUT (C), r
			emit(0xed);
			emit(0x41 + (r << 3));
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_indexpr(&n) && parse_comma() && parse_a() && check_end()) {	// IN (n), A
			emit(0xd3);
			emit(n);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_expr(&n) && check_end()) {	// OUT n
			emit(0xd3);
			emit(n);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'U', 'T', 'I', ___): {
		ptr += 4;
		if (check_end()) {	// OUTI
			emit(0xed);
			emit(0xa3);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'T', 'I', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// OTIR
			emit(0xed);
			emit(0xb3);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'U', 'T', 'D', ___): {
		ptr += 4;
		if (check_end()) {	// OUTD
			emit(0xed);
			emit(0xab);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'T', 'D', 'R', ___): {
		ptr += 4;
		if (check_end()) {	// OTDR
			emit(0xed);
			emit(0xbb);
			return true;
		}
		break;
	}

	// cpu control
	case WORD_HASH('N', 'O', 'P', ___, ___): {
		ptr += 3;
		if (check_end()) {	// NOP
			emit(0x00);
			return true;
		}
		break;
	}
	case WORD_HASH('D', 'I', ___, ___, ___): {
		ptr += 2;
		if (check_end()) {	// DI
			emit(0xf3);
			return true;
		}
		break;
	}
	case WORD_HASH('E', 'I', ___, ___, ___): {
		ptr += 2;
		if (check_end()) {	// EI
			emit(0xfb);
			return true;
		}
		break;
	}
	case WORD_HASH('H', 'A', 'L', 'T', ___): {
		ptr += 4;
		if (check_end()) {	// HALT
			emit(0x76);
			return true;
		}
		break;
	}
	case WORD_HASH('H', 'L', 'T', ___, ___): {
		ptr += 3;
		if (check_end()) {	// HALT
			emit(0x76);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'M', ___, ___, ___): {
		ptr += 2;
		if (parse_const(&im) && check_end()) {	// IM n
			switch (im) {
			case 0: emit(0xed); emit(0x46); return true;
			case 1: emit(0xed); emit(0x56); return true;
			case 2: emit(0xed); emit(0x5e); return true;
			default: error_range(im);
			}
		}
		break;
	}

	// stack
	case WORD_HASH('P', 'U', 'S', 'H', ___): {
		ptr += 4;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_reg16af(&rr) && check_end()) {	// PUSH BC/DE/HL/AF
			if ((rr & IDX_MASK) == IDX_IX) emit(0xdd); else if ((rr & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0xc5 + (rr << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) && parse_reg16af_intel(&rr) && check_end()) {	// PUSH B/BC/D/DE/H/HL/PSW
			emit(0xc5 + (rr << 4));
			return true;
		}
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('P', 'O', 'P', ___, ___): {
		ptr += 4;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_reg16af(&rr) && check_end()) {	// POP BC/DE/HL/AF
			if ((rr & IDX_MASK) == IDX_IX) emit(0xdd); else if ((rr & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0xc1 + (rr << 4));
			return true;
		}
		else if (restore_ptr(&ptr0) && parse_reg16af_intel(&rr) && check_end()) {	// POP B/BC/D/DE/H/HL/PSW
			emit(0xc1 + (rr << 4));
			return true;
		}
		restore_ptr(&ptr0);
		break;
	}

	// jump
	case WORD_HASH('J', 'P', ___, ___, ___): {
		ptr += 2;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_jump_call(0xc3, 0xc2))	// JP flags, nn/CALL nn
			return true;
		else if (restore_ptr(&ptr0) &&
			parse_lparen() && parse_HLx(&x) && parse_rparen() && check_end()) {	// JP (HL)/(IX)/(IY)
			if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0xe9);
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('J', 'M', 'P', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_jump_call(0xc3, 0xc2))	// JP flags, nn/CALL nn
			return true;
		else if (restore_ptr(&ptr0) &&
			parse_lparen() && parse_HLx(&x) && parse_rparen() && check_end()) {	// JP (HL)/(IX)/(IY)
			if ((x & IDX_MASK) == IDX_IX) emit(0xdd); else if ((x & IDX_MASK) == IDX_IY) emit(0xfd);
			emit(0xe9);
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}
	case WORD_HASH('P', 'C', 'H', 'L', ___): {
		ptr += 4;
		if (check_end()) {	// PCHL
			emit(0xe9);
			return true;
		}
		break;
	}
	case WORD_HASH('J', 'N', 'Z', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc2, F_NZ))	// JNZ nn
			return true;
		break;
	}
	case WORD_HASH('J', 'Z', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc2, F_Z))	// JZ nn
			return true;
		break;
	}
	case WORD_HASH('J', 'N', 'C', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc2, F_NC))	// JNC nn
			return true;
		break;
	}
	case WORD_HASH('J', 'C', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc2, F_C))	// JC nn
			return true;
		break;
	}
	case WORD_HASH('J', 'P', 'O', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc2, F_PO))	// JPO nn
			return true;
		break;
	}
	case WORD_HASH('J', 'P', 'E', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc2, F_PE))	// JPE nn
			return true;
		break;
	}
	case WORD_HASH('J', 'N', 'V', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc2, F_NV))	// JNV nn
			return true;
		break;
	}
	case WORD_HASH('J', 'V', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc2, F_V))	// JV nn
			return true;
		break;
	}
	case WORD_HASH('J', 'M', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc2, F_M))	// JM nn
			return true;
		break;
	}
	case WORD_HASH('D', 'J', 'N', 'Z', ___): {
		ptr += 4;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (!(parse_B() && parse_comma()))	// b, optional
			restore_ptr(&ptr0);
		if (parse_expr(&addr) && check_end()) {	// DJNZ nn
			int pc = get_pc() + 2;	// after this intruction
			int dist = addr - pc;
			if (dist < -128 || dist>127) {
				error_range(dist);
				return false;
			}
			emit(0x10);
			emit(dist);
			return true;
		}
		break;
	}
	case WORD_HASH('J', 'R', ___, ___, ___): {
		ptr += 2;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_flags4(&flags) && parse_comma() && parse_expr(&addr) && check_end()) {	// JR flag, nn
			int pc = get_pc() + 2;	// after this intruction
			int dist = addr - pc;
			if (dist < -128 || dist>127) {
				error_range(dist);
				return false;
			}
			emit(0x20 + (flags << 3));
			emit(dist);
			return true;
		}
		else if (restore_ptr(&ptr0) &&
			parse_expr(&addr) && check_end()) {	// JR nn
			int pc = get_pc() + 2;	// after this intruction
			int dist = addr - pc;
			if (dist < -128 || dist>127) {
				error_range(dist);
				return false;
			}
			emit(0x18);
			emit(dist);
			return true;
		}
		else {
			restore_ptr(&ptr0);
		}
		break;
	}

	// call
	case WORD_HASH('C', 'A', 'L', 'L', ___): {
		ptr += 4;
		if (parse_jump_call(0xcd, 0xc4))	// CALL flags, nn/CALL nn
			return true;
		break;
	}
	case WORD_HASH('R', 'S', 'T', ___, ___): {
		ptr += 3;
		if (parse_const(&rst) && check_end()) {	// RST n
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
					error_range(rst);
					return false;
				}
			}
		}
		break;
	}
	case WORD_HASH('C', 'N', 'Z', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc4, F_NZ))	// CNZ nn
			return true;
		break;
	}
	case WORD_HASH('C', 'Z', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc4, F_Z))	// CZ nn
			return true;
		break;
	}
	case WORD_HASH('C', 'N', 'C', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc4, F_NC))	// CNC nn
			return true;
		break;
	}
	case WORD_HASH('C', 'C', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc4, F_C))	// CC nn
			return true;
		break;
	}
	case WORD_HASH('C', 'P', 'O', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc4, F_PO))	// CPO nn
			return true;
		break;
	}
	case WORD_HASH('C', 'P', 'E', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc4, F_PE))	// CPE nn
			return true;
		break;
	}
	case WORD_HASH('C', 'N', 'V', ___, ___): {
		ptr += 3;
		if (parse_jump_call_intel(0xc4, F_NV))	// CNV nn
			return true;
		break;
	}
	case WORD_HASH('C', 'V', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc4, F_V))	// CV nn
			return true;
		break;
	}
	case WORD_HASH('C', 'M', ___, ___, ___): {
		ptr += 2;
		if (parse_jump_call_intel(0xc4, F_M))	// CM nn
			return true;
		break;
	}

	// return
	case WORD_HASH('R', 'E', 'T', ___, ___): {
		ptr += 3;
		const char* ptr0; blanks(); save_ptr(&ptr0);
		if (parse_flags8(&flags) && check_end()) {	// RET flag
			emit(0xc0 + (flags << 3));
			return true;
		}
		else if (restore_ptr(&ptr0) && check_end()) {	// RET
			emit(0xc9);
			return true;
		}
		restore_ptr(&ptr0);
		break;
	}
	case WORD_HASH('R', 'N', 'Z', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RNZ
			emit(0xc0 + (F_NZ << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'Z', ___, ___, ___): {
		ptr += 2;
		if (check_end()) {	// RZ
			emit(0xc0 + (F_Z << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'N', 'C', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RNC
			emit(0xc0 + (F_NC << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'C', ___, ___, ___): {
		ptr += 2;
		if (check_end()) {	// RC
			emit(0xc0 + (F_C << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'P', 'O', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RPO
			emit(0xc0 + (F_PO << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'P', 'E', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RPE
			emit(0xc0 + (F_PE << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'N', 'V', ___, ___): {
		ptr += 3;
		if (check_end()) {	// RNV
			emit(0xc0 + (F_NV << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'V', ___, ___, ___): {
		ptr += 2;
		if (check_end()) {	// RV
			emit(0xc0 + (F_V << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'P', ___, ___, ___): {
		ptr += 2;
		if (check_end()) {	// RP
			emit(0xc0 + (F_P << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'M', ___, ___, ___): {
		ptr += 2;
		if (check_end()) {	// RM
			emit(0xc0 + (F_M << 3));
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'E', 'T', 'I', ___): {
		ptr += 4;
		if (check_end()) {	// RETI
			emit(0xed);
			emit(0x4d);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'E', 'T', 'N', ___): {
		ptr += 4;
		if (check_end()) {	// RETN
			emit(0xed);
			emit(0x45);
			return true;
		}
		break;
	}

	default: break;
	}
	error_syntax();
	return false;
}

static bool parse_line(void) {
	UT_string* label; utstring_new(label);

	bool ok = true;
	blanks();
	if (parse_label(label)) {}
	blanks();
	while (*ptr != '\0') {
		if (!parse_statement()) ok = false;
	}
	
	utstring_free(label);
	return ok;
}

static bool parse_file_1(void) {
	bool ok = true;
	while (utstring_fgets(input_line, input_file)) {
		ptr = utstring_body(input_line);
		line_num++;
		if (!parse_line()) ok = false;
	}
	return ok;
}

static bool parse_file(const char* filename) {
	FILE* fp = safe_fopen(filename, "rb");
	FILE* save_input_file = input_file; 
	input_file = fp;

	char* save_filename = input_filename; 
	input_filename = safe_strdup(filename);

	int save_line_num = line_num; 
	line_num = 0;
	
	char* save_line = safe_strdup(utstring_body(input_line)); 
	utstring_clear(input_line);
	
	size_t save_cursor = ptr - utstring_body(input_line); 
	ptr = utstring_body(input_line);

	bool ok = parse_file_1();

	fclose(input_file); 
	input_file = save_input_file;
	
	free(input_filename); 
	input_filename = save_filename;
	
	line_num = save_line_num;
	
	utstring_clear(input_line); 
	utstring_printf(input_line, "%s", save_line); 
	free(save_line);

	ptr = utstring_body(input_line) + save_cursor;

	return ok;
}

bool assemble_file(const char* input_filename) {
	init();

	UT_string* output_filename; 
	utstring_new(output_filename);
	
	remove_ext(output_filename, input_filename); 
	utstring_printf(output_filename, ".bin");
	
	init_backend(utstring_body(output_filename));
	utstring_free(output_filename);

	bool ok = parse_file(input_filename);

	return ok;
}
