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
#define CHAR_HASH(c)			(((c)-___) & 0x3F)
#define WORD_HASH(a,b,c,d,e)	(CHAR_HASH(a)<<24 | CHAR_HASH(b)<<18 | CHAR_HASH(c)<<12 | CHAR_HASH(d)<<6 | CHAR_HASH(e))

#define SAVE_CURSOR(n)			const char* old_cursor##n; blanks(); save_cursor(&old_cursor##n)
#define RESTORE_CURSOR(n)		restore_cursor(&old_cursor##n)
#define IX_PREFIX(n)			if (indexreg[n]) emit(indexreg[n] == IndexIX ? 0xDD : 0xFD); else
#define EMIT_IX_DIS(n, dis)		if (indexreg[n]) emit(dis); else

enum { IndexHL, IndexIX, IndexIY };
enum { R_BC, R_DE, R_HL, R_SP = 3, R_AF = 3 };
enum { R_B, R_C, R_D, R_E, R_H, R_L, R_M, R_A };
enum { F_NZ, F_Z, F_NC, F_C, F_PO, F_NV = F_PO, F_PE, F_V = F_PE, F_P, F_M };

static FILE* input_file = NULL;
static char* input_filename = NULL;
static int line_num = 0;
static int num_errors = 0;
static UT_string* input_line = NULL;
static const char* cursor = NULL;
static char* ident = NULL;			// last retrieved identifier
static int indexreg[2], reg8[2], reg16[2], flags;
static int post_inc, post_dec;
static int expr[2];	// expr[0] is last, expr[1] is last before

static void push_indexreg(int value) {
	indexreg[1] = indexreg[0];
	indexreg[0] = value;
}

static void push_reg8(int value) {
	reg8[1] = reg8[0];
	reg8[0] = value;
}

static void push_reg16(int value) {
	reg16[1] = reg16[0];
	reg16[0] = value;
}

static void init_frontend(void) {
	if (input_file) fclose(input_file); 
	input_file = NULL;
	free(input_filename); 
	input_filename = NULL;
	line_num = num_errors = 0;
	utstring_new(input_line);
	cursor = utstring_body(input_line);
}

static void syntax_error(void) {
	fprintf(stderr, "Syntax error at %s line %d: %s", input_filename, line_num, cursor);
	cursor += strlen(cursor);
	num_errors++;
}

static void range_error(void) {
	fprintf(stderr, "Range error at %s line %d\n", input_filename, line_num);
	cursor += strlen(cursor);
	num_errors++;
}

static void save_cursor(const char** save) {
	*save = cursor;
}

static bool restore_cursor(const char** save) {
	cursor = *save;
	return true;
}

static bool isident_start(char c) {
	return c == '_' || isalpha(c);
}

static bool isident(char c) {
	return c == '_' || isalnum(c);
}

static void blanks(void) {
	while (isspace(*cursor)) cursor++;
}

static bool p_separator(const char* separator) {
	blanks();
	for (int i = 0; separator[i]; i++)
		if (cursor[i] != separator[i])
			return false;
	cursor += strlen(separator);
	return true;
}

static bool p_comma(void) {
	return p_separator(",");
}

static bool p_tick(void) {
	return p_separator("'");
}

static bool p_plus(void) {
	return p_separator("+");
}

static bool p_minus(void) {
	return p_separator("-");
}

static bool p_lparen(void) {
	return p_separator("(");
}

static bool p_rparen(void) {
	return p_separator(")");
}

static bool p_word(const char* word) {
	blanks();
	for (int i = 0; word[i]; i++)
		if (toupper(cursor[i]) != toupper(word[i]))
			return false;
	if (isident(cursor[strlen(word)])) return false;
	cursor += strlen(word);
	return true;
}

static bool p_end(void) {
	blanks();
	switch (*cursor) {
	case '\0':	return true;
	case ':':	cursor++; return true;
	case '\\':	cursor++; return true;
	case ';':	cursor += strlen(cursor); return true;
	default:	return false;
	}
}

static bool ck_end(void) {
	if (!p_end()) {
		syntax_error();
		return false;
	}
	else
		return true;
}

static bool p_ident(void) {
	blanks();
	if (!isident_start(*cursor)) return false;
	const char* start_ident = cursor++;
	while (isident(*cursor)) cursor++;
	free(ident); ident = safe_strdup_n(start_ident, cursor - start_ident);
	return true;
}

static unsigned get_word_hash(void) {
	blanks();
	if (isident_start(*cursor)) {
		char a[5] = { ___,___,___,___,___ };
		for (int i = 0; i < sizeof(a) && isident(cursor[i]); i++) {
			a[i] = toupper(cursor[i]);
		}
		return WORD_HASH(a[0], a[1], a[2], a[3], a[4]);
	}
	else {
		return 0;
	}
}

static void push_expr(int value) {
	expr[1] = expr[0];
	expr[0] = value;
}

static bool p_const(void) {	// TODO: parse expressions
	blanks();
	if (isdigit(*cursor)) {
		int value = (int)strtol(cursor, (char**)& cursor, 0);
		push_expr(value);
		return true;
	}
	else 
		return false;
}

static bool p_expr(void) {	// TODO: parse expressions
	SAVE_CURSOR(0);
	if (p_word("ASMPC") || p_separator("$")) {
		push_expr(get_pc());
		return true;
	}
	else {
		RESTORE_CURSOR(0);
		bool negative = p_minus() ? true : false;
		blanks();
		if (isdigit(*cursor)) {
			int value = (int)strtol(cursor, (char**)& cursor, 0);
			if (negative) value = -value;
			push_expr(value);
			return true;
		}
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_ind_expr(void) {
	SAVE_CURSOR(0);
	if (p_lparen() && p_expr() && p_rparen())
		return true;

	RESTORE_CURSOR(0);
	return false;
}

static bool p_DIS(void) {
	SAVE_CURSOR(0);
	if (p_rparen()) {
		push_expr(0);
		return true;
	}
	else if (RESTORE_CURSOR(0) &&
		p_plus() && p_expr() && p_rparen()) {
		return true;
	}
	else if (RESTORE_CURSOR(0) &&
		p_minus() && p_expr() && p_rparen()) {
		expr[0] = -expr[0];
		return true;
	}
	else {
		RESTORE_CURSOR(0);
		return false;
	}
}

static bool p_dot_label(void) {
	SAVE_CURSOR(0);
	if (p_separator(".") && p_ident())
		return true;
	else {
		RESTORE_CURSOR(0);
		return false;
	}
}

static bool p_label_colon(void) {
	SAVE_CURSOR(0);
	if (p_ident() && p_separator(":"))
		return true;
	else {
		RESTORE_CURSOR(0);
		return false;
	}
}

static bool p_label(void) {
	blanks();
	return p_dot_label() || p_label_colon();
}

static bool p_reg8(void) {
	blanks();
	if (isident_start(cursor[0]) && !isident(cursor[1])) {
		switch (toupper(cursor[0])) {
		case 'B': cursor++; push_indexreg(IndexHL); push_reg8(R_B); return true;
		case 'C': cursor++; push_indexreg(IndexHL); push_reg8(R_C); return true;
		case 'D': cursor++; push_indexreg(IndexHL); push_reg8(R_D); return true;
		case 'E': cursor++; push_indexreg(IndexHL); push_reg8(R_E); return true;
		case 'H': cursor++; push_indexreg(IndexHL); push_reg8(R_H); return true;
		case 'L': cursor++; push_indexreg(IndexHL); push_reg8(R_L); return true;
		case 'A': cursor++; push_indexreg(IndexHL); push_reg8(R_A); return true;
		default: return false;
		}
	}
	else
		return false;
}

static bool p_reg8x(void) {
	switch (get_word_hash()) {
	case WORD_HASH('B', ___, ___, ___, ___): cursor++;		push_indexreg(IndexHL); push_reg8(R_B); return true;
	case WORD_HASH('C', ___, ___, ___, ___): cursor++;		push_indexreg(IndexHL); push_reg8(R_C); return true;
	case WORD_HASH('D', ___, ___, ___, ___): cursor++;		push_indexreg(IndexHL); push_reg8(R_D); return true;
	case WORD_HASH('E', ___, ___, ___, ___): cursor++;		push_indexreg(IndexHL); push_reg8(R_E); return true;
	case WORD_HASH('H', ___, ___, ___, ___): cursor++;		push_indexreg(IndexHL); push_reg8(R_H); return true;
	case WORD_HASH('L', ___, ___, ___, ___): cursor++;		push_indexreg(IndexHL); push_reg8(R_L); return true;
	case WORD_HASH('A', ___, ___, ___, ___): cursor++;		push_indexreg(IndexHL); push_reg8(R_A); return true;
	case WORD_HASH('I', 'X', 'H', ___, ___): cursor += 3;	push_indexreg(IndexIX); push_reg8(R_H); return true;
	case WORD_HASH('I', 'Y', 'H', ___, ___): cursor += 3;	push_indexreg(IndexIY); push_reg8(R_H); return true;
	case WORD_HASH('I', 'X', 'L', ___, ___): cursor += 3;	push_indexreg(IndexIX); push_reg8(R_L); return true;
	case WORD_HASH('I', 'Y', 'L', ___, ___): cursor += 3;	push_indexreg(IndexIY); push_reg8(R_L); return true;
	default: return false;
	}
}

static bool p_reg8intel(void) {
	blanks();
	if (isident_start(cursor[0]) && !isident(cursor[1])) {
		switch (toupper(cursor[0])) {
		case 'B': cursor++; push_indexreg(IndexHL); push_reg8(R_B); return true;
		case 'C': cursor++; push_indexreg(IndexHL); push_reg8(R_C); return true;
		case 'D': cursor++; push_indexreg(IndexHL); push_reg8(R_D); return true;
		case 'E': cursor++; push_indexreg(IndexHL); push_reg8(R_E); return true;
		case 'H': cursor++; push_indexreg(IndexHL); push_reg8(R_H); return true;
		case 'L': cursor++; push_indexreg(IndexHL); push_reg8(R_L); return true;
		case 'M': cursor++; push_indexreg(IndexHL); push_reg8(R_M); return true;
		case 'A': cursor++; push_indexreg(IndexHL); push_reg8(R_A); return true;
		default: return false;
		}
	}
	else
		return false;
}

static bool p_reg16sp(void) {
	switch (get_word_hash()) {
	case WORD_HASH('B', 'C', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_BC); return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_DE); return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_HL); return true;
	case WORD_HASH('I', 'X', ___, ___, ___):	cursor += 2; push_indexreg(IndexIX); push_reg16(R_HL); return true;
	case WORD_HASH('I', 'Y', ___, ___, ___):	cursor += 2; push_indexreg(IndexIY); push_reg16(R_HL); return true;
	case WORD_HASH('S', 'P', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_SP); return true;
	default: return false;
	}
}

static bool p_reg16sp_intel(void) {
	switch (get_word_hash()) {
	case WORD_HASH('B', ___, ___, ___, ___):	cursor += 1; push_indexreg(IndexHL); push_reg16(R_BC); return true;
	case WORD_HASH('B', 'C', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_BC); return true;
	case WORD_HASH('D', ___, ___, ___, ___):	cursor += 1; push_indexreg(IndexHL); push_reg16(R_DE); return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_DE); return true;
	case WORD_HASH('H', ___, ___, ___, ___):	cursor += 1; push_indexreg(IndexHL); push_reg16(R_HL); return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_HL); return true;
	case WORD_HASH('S', 'P', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_SP); return true;
	default: return false;
	}
}

static bool p_reg16af(void) {
	switch (get_word_hash()) {
	case WORD_HASH('B', 'C', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_BC); return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_DE); return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_HL); return true;
	case WORD_HASH('I', 'X', ___, ___, ___):	cursor += 2; push_indexreg(IndexIX); push_reg16(R_HL); return true;
	case WORD_HASH('I', 'Y', ___, ___, ___):	cursor += 2; push_indexreg(IndexIY); push_reg16(R_HL); return true;
	case WORD_HASH('A', 'F', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_AF); return true;
	default: return false;
	}
}

static bool p_reg16af_intel(void) {
	switch (get_word_hash()) {
	case WORD_HASH('B', ___, ___, ___, ___):	cursor += 1; push_indexreg(IndexHL); push_reg16(R_BC); return true;
	case WORD_HASH('B', 'C', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_BC); return true;
	case WORD_HASH('D', ___, ___, ___, ___):	cursor += 1; push_indexreg(IndexHL); push_reg16(R_DE); return true;
	case WORD_HASH('D', 'E', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_DE); return true;
	case WORD_HASH('H', ___, ___, ___, ___):	cursor += 1; push_indexreg(IndexHL); push_reg16(R_HL); return true;
	case WORD_HASH('H', 'L', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); push_reg16(R_HL); return true;
	case WORD_HASH('P', 'S', 'W', ___, ___):	cursor += 3; push_indexreg(IndexHL); push_reg16(R_AF); return true;
	default: return false;
	}
}

static bool p_a(void) {
	return p_word("A");
}

static bool p_f(void) {
	return p_word("F");
}

static bool p_af(void) {
	return p_word("AF");
}

static bool p_i(void) {
	return p_word("I");
}

static bool p_r(void) {
	return p_word("R");
}

static void p_post_incdec(int reg) {
	post_inc = post_dec = -1;
	if (p_plus()) 
		post_inc = reg;
	else if (p_minus()) 
		post_dec = reg;
}

static void emit_post_inc_dec() {
	if (post_inc >= 0) { 
		emit(0x03 + post_inc * 16); 
		post_inc = -1; 
	} 
	
	if (post_dec >= 0) { 
		emit(0x0B + post_dec * 16); 
		post_dec = -1; 
	}
}

static bool p_ind_bcde(void) {
	SAVE_CURSOR(0);
	if (p_lparen()) {
		switch (get_word_hash()) {
		case WORD_HASH('B', 'C', ___, ___, ___):	cursor += 2; push_reg16(R_BC); p_post_incdec(R_BC); if (p_rparen()) return true; else break;
		case WORD_HASH('D', 'E', ___, ___, ___):	cursor += 2; push_reg16(R_DE); p_post_incdec(R_DE); if (p_rparen()) return true; else break;
		}
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_b(void) {
	return p_word("B");
}

static bool p_ind_c(void) {
	SAVE_CURSOR(0);
	if (p_lparen() && p_word("C") && p_rparen()) {
		return true;
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_bc(void) {
	return p_word("BC");
}

static bool p_d(void) {
	return p_word("D");
}

static bool p_de(void) {
	return p_word("DE");
}

static bool p_h(void) {
	return p_word("H");
}

static bool p_hl(void) {
	return p_word("HL");
}

static bool p_ind_hl(void) {
	SAVE_CURSOR(0);
	if (p_lparen() && p_hl() && p_rparen())
		return true;
	RESTORE_CURSOR(0);
	return false;
}

static bool p_hlx(void) {
	return p_reg16sp() && reg16[0] == R_HL;
}

static bool p_ind_hlx(void) {
	SAVE_CURSOR(0);
	if (p_lparen()) {
		switch (get_word_hash()) {
		case WORD_HASH('H', 'L', ___, ___, ___):	cursor += 2; push_indexreg(IndexHL); p_post_incdec(R_HL); if (p_rparen()) return true; else break;
		case WORD_HASH('H', 'L', 'I', ___, ___):	cursor += 3; push_indexreg(IndexHL); post_inc = R_HL; if (p_rparen()) return true; else break;
		case WORD_HASH('H', 'L', 'D', ___, ___):	cursor += 3; push_indexreg(IndexHL); post_dec = R_HL; if (p_rparen()) return true; else break;
		case WORD_HASH('I', 'X', ___, ___, ___):	cursor += 2; push_indexreg(IndexIX); if (p_DIS()) return true; else break;
		case WORD_HASH('I', 'Y', ___, ___, ___):	cursor += 2; push_indexreg(IndexIY); if (p_DIS()) return true; else break;
		}
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_m(void) {
	return p_word("M");
}

static bool p_sp(void) {
	return p_word("SP");
}

static bool p_flags8(void) {
	switch (get_word_hash()) {
	case WORD_HASH('N', 'Z', ___, ___, ___):	cursor += 2; flags = F_NZ; return true;
	case WORD_HASH('Z', ___, ___, ___, ___):	cursor += 1; flags = F_Z;  return true;
	case WORD_HASH('N', 'C', ___, ___, ___):	cursor += 2; flags = F_NC; return true;
	case WORD_HASH('C', ___, ___, ___, ___):	cursor += 1; flags = F_C;  return true;
	case WORD_HASH('P', 'O', ___, ___, ___):	cursor += 2; flags = F_PO; return true;
	case WORD_HASH('P', 'E', ___, ___, ___):	cursor += 2; flags = F_PE; return true;
	case WORD_HASH('P', ___, ___, ___, ___):	cursor += 1; flags = F_P;  return true;
	case WORD_HASH('M', ___, ___, ___, ___):	cursor += 1; flags = F_M;  return true;
	case WORD_HASH('N', 'V', ___, ___, ___):	cursor += 2; flags = F_NV; return true;
	case WORD_HASH('V', ___, ___, ___, ___):	cursor += 1; flags = F_V;  return true;
	default: return false;
	}
}

static bool p_flags4(void) {
	switch (get_word_hash()) {
	case WORD_HASH('N', 'Z', ___, ___, ___):	cursor += 2; flags = F_NZ; return true;
	case WORD_HASH('Z', ___, ___, ___, ___):	cursor += 1; flags = F_Z;  return true;
	case WORD_HASH('N', 'C', ___, ___, ___):	cursor += 2; flags = F_NC; return true;
	case WORD_HASH('C', ___, ___, ___, ___):	cursor += 1; flags = F_C;  return true;
	default: return false;
	}
}

static bool p_alu8(int n) {
	SAVE_CURSOR(0);
	if (!(p_a() && p_comma())) 		// alu: a, is optional
		RESTORE_CURSOR(0);

	SAVE_CURSOR(1);
	if (p_reg8x() && ck_end()) {	// alu B/C/D/E/H/L/A/IXH/IYH/IXL/IYL
		IX_PREFIX(0);
		emit(0x80 + n * 8 + reg8[0]);
		return true;
	}
	else if (RESTORE_CURSOR(1) &&
		p_ind_hlx() && ck_end()) {	// alu (HL)/(IX+d)/(IY+d)
		IX_PREFIX(0);
		emit(0x80 + n * 8 + 6);
		EMIT_IX_DIS(0, expr[0]);
		emit_post_inc_dec();
		return true;
	}
	else if (RESTORE_CURSOR(1) &&
		p_expr() && ck_end()) {	// alu n
		emit(0xC0 + n * 8 + 6);
		emit(expr[0]);
		return true;
	}
	else {
		RESTORE_CURSOR(0);
		return false;
	}
}

static bool p_rot8(int n) {
	SAVE_CURSOR(0);
	if (p_reg8() && ck_end()) {	// rot B/C/D/E/H/L/A
		emit(0xCB);
		emit(n * 8 + reg8[0]);
		return true;
	}
	else if (RESTORE_CURSOR(0) &&
		p_ind_hlx() && p_comma() && p_reg8() && ck_end()) {	// rot (HL)/(IX+d)/(IY+d), r
		IX_PREFIX(1);
		emit(0xCB);
		EMIT_IX_DIS(1, expr[0]);
		emit(n * 8 + reg8[0]);
		return true;
	}
	else if (RESTORE_CURSOR(0) &&
		p_ind_hlx() && ck_end()) {	// rot (HL)/(IX+d)/(IY+d)
		IX_PREFIX(0);
		emit(0xCB);
		EMIT_IX_DIS(0, expr[0]);
		emit(n * 8 + 6);
		return true;
	}
	else {
		RESTORE_CURSOR(0);
		return false;
	}
}

static bool p_alu8intel(int n) {
	SAVE_CURSOR(0);
	if (p_reg8intel() && ck_end()) {	// alu B/C/D/E/H/L/M/A
		emit(0x80 + n * 8 + reg8[0]);
		return true;
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_bit8(int n) {
	SAVE_CURSOR(0);
	if (p_const() && p_comma()) {
		int bit = expr[0];
		if (bit < 0 || bit > 7) {
			range_error();
			return false;
		}
		SAVE_CURSOR(1);
		if (p_reg8() && ck_end()) {	// bit/res/set n, B/C/D/E/H/L/A
			emit(0xCB);
			emit(n * 0x40 + bit * 8 + reg8[0]);
			return true;
		}
		else if (RESTORE_CURSOR(1) &&
			p_ind_hlx() && ck_end()) {	// bit/res/set n, (HL)/(IX+d)/(IY+d)
			IX_PREFIX(0);
			emit(0xCB);
			EMIT_IX_DIS(0, expr[0]);
			emit(n * 0x40 + bit * 8 + 6);
			emit_post_inc_dec();
			return true;
		}
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_jump_call(int uncond_opcode, int cond_opcode) {
	SAVE_CURSOR(0);
	if (p_flags8() && p_comma() && p_expr() && ck_end()) {	// call/jp flag, nn
		emit(cond_opcode + flags * 8);
		emitw(expr[0]);
		return true;
	}
	else if (RESTORE_CURSOR(0) && p_expr() && ck_end()) {	// call/jp nn
		emit(uncond_opcode);
		emitw(expr[0]);
		return true;
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_inc_dec(int r8_opcode, int r16_opcode) {
	SAVE_CURSOR(0);
	if (p_reg16sp() && ck_end()) {	// INC/DEC BC/DE/HL/SP/IX/IY
		IX_PREFIX(0);
		emit(r16_opcode + reg16[0] * 16);
		return true;
	}
	else if (RESTORE_CURSOR(0) &&
		p_reg8x() && ck_end()) {	// INC/DEC B/C/D/E/H/L/A/IXH/IYH/IXL/IYL
		IX_PREFIX(0);
		emit(r8_opcode + reg8[0] * 8);
		return true;
	}
	else if (RESTORE_CURSOR(0) &&
		p_ind_hlx() && ck_end()) {	// INC/DEC (HL)/(IX+d)/(IY+d)
		IX_PREFIX(0);
		emit(r8_opcode + 6 * 8);
		EMIT_IX_DIS(0, expr[0]);
		emit_post_inc_dec();
		return true;
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_jump_call_intel(int cond_opcode, int flags) {
	SAVE_CURSOR(0);
	if (p_expr() && ck_end()) {
		emit(cond_opcode + flags * 8);
		emitw(expr[0]);
		return true;
	}
	RESTORE_CURSOR(0);
	return false;
}

static bool p_statement(void) {
	post_inc = post_dec = -1;
	if (p_end())
		return true;
	switch (get_word_hash()) {
	// load
	case WORD_HASH('L', 'D', ___, ___, ___): {
		cursor += 2;
		SAVE_CURSOR(0);
		if (p_reg8x() && p_comma() && p_reg8x() && ck_end()) {	// LD r, r
			if (indexreg[0] != 0 && indexreg[1] != 0 && indexreg[0] != indexreg[1]) break;	// ix-iy mismatch
			if (indexreg[0] != 0) { 
				IX_PREFIX(0); 
			}
			else if (indexreg[1] != 0) { 
				IX_PREFIX(1); 
			}
			emit(0x40 + reg8[1] * 8 + reg8[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_reg8() && p_comma() && p_ind_hlx() && ck_end()) {	// LD r, (HL)/(IX+d)/(IY+d)
			if (indexreg[0] != 0 && indexreg[1] != 0 && indexreg[0] != indexreg[1]) break;	// ix-iy mismatch
			IX_PREFIX(0);
			emit(0x40 + reg8[1] * 8 + 6);
			EMIT_IX_DIS(0, expr[0]);
			emit_post_inc_dec();
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_bcde() && p_comma() && p_a() && ck_end()) {	// LD (BC/DE), A
			emit(0x02 + reg16[0] * 16);
			emit_post_inc_dec();
			return true;
		}
		if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_ind_bcde() && ck_end()) {	// LD A, (BC/DE)
			emit(0x0A + reg16[0] * 16);
			emit_post_inc_dec();
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_reg8x() && p_comma() && p_expr() && ck_end()) {	// LD B/C/D/E/H/L/A, n
			IX_PREFIX(0);
			emit(0x06 + reg8[0] * 8);
			emit(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_hlx() && p_comma() && p_reg8() && ck_end()) {	// LD (HL)/(IX+d)/(IY+d), r
			if (indexreg[0] != 0 && indexreg[1] != 0 && indexreg[0] != indexreg[1]) break;	// ix-iy mismatch
			IX_PREFIX(1);
			emit(0x40 + 6 * 8 + reg8[0]);
			EMIT_IX_DIS(1, expr[0]);
			emit_post_inc_dec();
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_hlx() && p_comma() && p_expr() && ck_end()) {	// LD (HL)/(IX+d)/(IY+d), n
			IX_PREFIX(0);
			emit(0x06 + 6 * 8);
			EMIT_IX_DIS(0, expr[1]);
			emit(expr[0]);
			emit_post_inc_dec();
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_reg16sp() && p_comma() && p_expr() && ck_end()) {	// LD BC/DE/HL/SP/IX/IY, nn
			IX_PREFIX(0);
			emit(0x01 + reg16[0] * 16);
			emitw(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_reg16sp() && p_comma() && p_ind_expr() && ck_end()) {	// LD BC/DE/HL/SP/IX/IY, (nn)
			if (reg16[0] == R_HL) {
				IX_PREFIX(0);
				emit(0x2A);
				emitw(expr[0]);
			}
			else {
				emit(0xED);
				emit(0x4B + reg16[0] * 16);
				emitw(expr[0]);
			}
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_expr() && p_comma() && p_reg16sp() && ck_end()) {	// LD (nn), BC/DE/HL/SP/IX/IY
			if (reg16[0] == R_HL) {
				IX_PREFIX(0);
				emit(0x22);
				emitw(expr[0]);
			}
			else {
				emit(0xED);
				emit(0x43 + reg16[0] * 16);
				emitw(expr[0]);
			}
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_expr() && p_comma() && p_a() && ck_end()) {	// LD (nn), A
			emit(0x32);
			emitw(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_ind_expr() && ck_end()) {	// LD A, (nn)
			emit(0x3A);
			emitw(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_i() && p_comma() && p_a() && ck_end()) {	// LD I, A
			emit(0xED);
			emit(0x47);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_r() && p_comma() && p_a() && ck_end()) {	// LD R, A
			emit(0xED);
			emit(0x4F);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_i() && ck_end()) {	// LD A, I
			emit(0xED);
			emit(0x57);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_r() && ck_end()) {	// LD A, R
			emit(0xED);
			emit(0x5F);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_sp() && p_comma() && p_hlx() && ck_end()) {	// LD SP, HL/IX/IY
			IX_PREFIX(0);
			emit(0xF9);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_bc() && p_comma() && p_de() && ck_end()) {	// LD BC, DE
			emit(0x42);
			emit(0x4B);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_bc() && p_comma() && p_hlx() && indexreg[0] == IndexHL && ck_end()) {	// LD BC, HL
			emit(0x44);
			emit(0x4D);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_de() && p_comma() && p_bc() && ck_end()) {	// LD DE, BC
			emit(0x50);
			emit(0x59);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_de() && p_comma() && p_hlx() && indexreg[0] == IndexHL && ck_end()) {	// LD DE, HL
			emit(0x54);
			emit(0x5D);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_hlx() && indexreg[0] == IndexHL && p_comma() && p_bc() && ck_end()) {	// LD HL, BC
			emit(0x60);
			emit(0x69);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_hlx() && indexreg[0] == IndexHL && p_comma() && p_de() && ck_end()) {	// LD HL, DE
			emit(0x62);
			emit(0x6B);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('L', 'D', 'A', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// LDA
			emit(0x3A);
			emitw(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'T', 'A', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// STA
			emit(0x32);
			emitw(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('L', 'H', 'L', 'D', ___): {
		cursor += 4;
		if (p_expr() && ck_end()) {	// LHLD nn
			emit(0x2A);
			emitw(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'H', 'L', 'D', ___): {
		cursor += 4;
		if (p_expr() && ck_end()) {	// SHLD nn
			emit(0x22);
			emitw(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('L', 'D', 'A', 'X', ___): {
		cursor += 4;
		SAVE_CURSOR(0);
		if ((p_b() || p_bc()) && ck_end()) {	// LDAX B/BC
			emit(0x0A);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			(p_d() || p_de()) && ck_end()) {	// LDAX D/DE
			emit(0x1A);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'T', 'A', 'X', ___): {
		cursor += 4;
		SAVE_CURSOR(0);
		if ((p_b() || p_bc()) && ck_end()) {	// STAX B/BC
			emit(0x02);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			(p_d() || p_de()) && ck_end()) {	// STAX D/DE
			emit(0x12);
			return true;
		}
		break;
	}
	case WORD_HASH('L', 'X', 'I', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if ((p_b() || p_bc()) && p_comma() && p_expr() && ck_end()) {	// LXI B/BC, nn
			emit(0x01);
			emitw(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			(p_d() || p_de()) && p_comma() && p_expr() && ck_end()) {	// LXI D/DE, nn
			emit(0x11);
			emitw(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			(p_h() || p_hl()) && p_comma() && p_expr() && ck_end()) {	// LXI H/HL, nn
			emit(0x21);
			emitw(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_sp() && p_comma() && p_expr() && ck_end()) {	// LXI SP, nn
			emit(0x31);
			emitw(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('M', 'O', 'V', ___, ___): {
		cursor += 3;
		if (p_reg8intel() && p_comma() && p_reg8intel() &&
			0x40 + reg8[1] * 8 + reg8[0] != 0x76 && ck_end()) {	// MOV r, r
			emit(0x40 + reg8[1] * 8 + reg8[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('M', 'V', 'I', ___, ___): {
		cursor += 3;
		if (p_reg8intel() && p_comma() && p_expr() && ck_end()) {	// MVI r, n
			emit(0x06 + reg8[0] * 8);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'P', 'H', 'L', ___): {
		cursor += 4;
		if (ck_end()) {	// SPHL
			emit(0xF9);
			return true;
		}
		break;
	}

	// exchange
	case WORD_HASH('E', 'X', ___, ___, ___): {
		cursor += 2;
		SAVE_CURSOR(0);
		if (p_af() && p_comma() && p_af() && (p_tick() || true) && ck_end()) {	// EX AF, AF[']
			emit(0x08);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_de() && p_comma() && p_hlx() && ck_end()) {	// EX DE, HL
			emit(0xEB);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_lparen() && p_sp() && p_rparen() && p_comma() &&
			p_hlx() && ck_end()) {	// EX (SP),HL/IX/IY
			IX_PREFIX(0);
			emit(0xE3);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('E', 'X', 'X', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// EXX
			emit(0xD9);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'C', 'H', 'G', ___): {
		cursor += 4;
		if (ck_end()) {	// XCHG
			emit(0xEB);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'T', 'H', 'L', ___): {
		cursor += 4;
		if (ck_end()) {	// XTHL
			emit(0xE3);
			return true;
		}
		break;
	}

	// block transfer
	case WORD_HASH('L', 'D', 'I', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_ind_bcde() && p_comma() && p_a() && ck_end()) {	// LDI (BC/DE), A
			emit(0x02 + reg16[0] * 16);
			emit(0x03 + reg16[0] * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_ind_bcde() && ck_end()) {	// LDI A, (BC/DE)
			emit(0x0A + reg16[0] * 16);
			emit(0x03 + reg16[0] * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_hl() && p_comma() && p_a() && ck_end()) {	// LDI (HL), A
			emit(0x40 + 6 * 8 + 7);
			emit(0x03 + 2 * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_ind_hl() && ck_end()) {	// LDI A, (HL)
			emit(0x40 + 7 * 8 + 6);
			emit(0x03 + 2 * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			ck_end()) {	// LDI
			emit(0xED);
			emit(0xA0);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('L', 'D', 'I', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// LDIR
			emit(0xED);
			emit(0xB0);
			return true;
		}
		break;
	}
	case WORD_HASH('L', 'D', 'D', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_ind_bcde() && p_comma() && p_a() && ck_end()) {	// LDD (BC/DE), A
			emit(0x02 + reg16[0] * 16);
			emit(0x0B + reg16[0] * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_ind_bcde() && ck_end()) {	// LDD A, (BC/DE)
			emit(0x0A + reg16[0] * 16);
			emit(0x0B + reg16[0] * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_hl() && p_comma() && p_a() && ck_end()) {	// LDD (HL), A
			emit(0x40 + 6 * 8 + 7);
			emit(0x0B + 2 * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_ind_hl() && ck_end()) {	// LDD A, (HL)
			emit(0x40 + 7 * 8 + 6);
			emit(0x0B + 2 * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			ck_end()) {	// LDD
			emit(0xED);
			emit(0xA8);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('L', 'D', 'D', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// LDDR
			emit(0xED);
			emit(0xB8);
			return true;
		}
		break;
	}

	// search
	case WORD_HASH('C', 'P', 'I', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_expr() && ck_end()) {	// CPI n
			emit(0xFE);
			emit(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) && ck_end()) {	// CPI
			emit(0xED);
			emit(0xA1);
			return true;
		}
		RESTORE_CURSOR(0);
		break;
	}
	case WORD_HASH('C', 'P', 'I', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// CPIR
			emit(0xED);
			emit(0xB1);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', 'D', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// CPD
			emit(0xED);
			emit(0xA9);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', 'D', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// CPIR
			emit(0xED);
			emit(0xB9);
			return true;
		}
		break;
	}

	// arithmetic
	case WORD_HASH('A', 'D', 'D', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_alu8(0))
			return true;
		else if (RESTORE_CURSOR(0) &&
			p_m() && ck_end()) {	// ADD m
			emit(0x86);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_hlx() && p_comma() && p_reg16sp() && ck_end()) {	// ADD HL/IX/IY, BC/DE/HL/SP/IX/IY
			IX_PREFIX(1);
			emit(0x09 + reg16[0] * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_bc() && p_comma() && p_expr() && ck_end()) {	// ADD BC, nn
			emit(0xE5);		// push hl
			emit(0x21);		// ld hl, nn
			emitw(expr[0]);
			emit(0x09);		// add hl, bc
			emit(0x44);		// ld b, h
			emit(0x4D);		// ld c, l
			emit(0xE1);		// pop hl
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_de() && p_comma() && p_expr() && ck_end()) {	// ADD DE, nn
			emit(0xE5);		// push hl
			emit(0x21);		// ld hl, nn
			emitw(expr[0]);
			emit(0x19);		// add hl, de
			emit(0x54);		// ld d, h
			emit(0x5D);		// ld e, l
			emit(0xE1);		// pop hl
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_hlx() && p_comma() && p_expr() && ck_end()) {	// ADD HL, nn
			emit(0xD5);		// push de
			emit(0x11);		// ld de, nn
			emitw(expr[0]);
			emit(0x19);		// add hl, de
			emit(0xD1);		// pop de
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('D', 'A', 'D', ___, ___): {
		cursor += 3;
		if (p_reg16sp_intel() && ck_end()) {	// DAD m
			emit(0x09 + reg16[0] * 16);
			return true;
		}
		break;
	}
	case WORD_HASH('A', 'D', 'I', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// ADI n
			emit(0xC6);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('A', 'D', 'C', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_alu8(1))
			return true;
		else if (RESTORE_CURSOR(0) &&
			p_m() && ck_end()) {	// ADC m
			emit(0x8E);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_hlx() && p_comma() && p_reg16sp() && ck_end()) {	// ADC HL, BC/DE/HL/SP
			emit(0xED);
			emit(0x4A + reg16[0] * 16);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('A', 'C', 'I', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// ACI n
			emit(0xCE);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'U', 'B', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_alu8(2))
			return true;
		else if (RESTORE_CURSOR(0) && p_reg8intel() && ck_end()) {	// SUB r
			emit(0x90 + reg8[0]);
			return true;
		}
		RESTORE_CURSOR(0);
		break;
	}
	case WORD_HASH('S', 'U', 'I', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// SUI n
			emit(0xD6);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'B', 'C', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_alu8(3))
			return true;
		else if (RESTORE_CURSOR(0) &&
			p_hlx() && p_comma() && p_reg16sp() && ck_end()) {	// SBC HL, BC/DE/HL/SP
			emit(0xED);
			emit(0x42 + reg16[0] * 16);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('S', 'B', 'B', ___, ___): {
		cursor += 3;
		if (p_alu8intel(3))
			return true;
		break;
	}
	case WORD_HASH('S', 'B', 'I', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// SBI n
			emit(0xDE);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', ___, ___, ___): {
		cursor += 2;
		if (p_alu8(7))
			return true;
		break;
	}
	case WORD_HASH('C', 'M', 'P', ___, ___): {
		cursor += 3;
		if (p_alu8(7) || p_alu8intel(7))
			return true;
		break;
	}
	case WORD_HASH('D', 'A', 'A', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// DAA
			emit(0x27);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'P', 'L', ___, ___): {
		cursor += 3;
		if ((p_a() || true) && ck_end()) {	// CPL [A]
			emit(0x2F);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'M', 'A', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// CMA
			emit(0x2F);
			return true;
		}
		break;
	}
	case WORD_HASH('N', 'E', 'G', ___, ___): {
		cursor += 3;
		if ((p_a() || true) && ck_end()) {	// NEG [A]
			emit(0xED);
			emit(0x44);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'C', 'F', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// SCF
			emit(0x37);
			return true;
		}
		break;
	}
	case WORD_HASH('S', 'T', 'C', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// STC
			emit(0x37);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'C', 'F', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// CCF
			emit(0x3F);
			return true;
		}
		break;
	}
	case WORD_HASH('C', 'M', 'C', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// CMC
			emit(0x3F);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'C', ___, ___): {
		cursor += 3;
		if (p_inc_dec(0x04, 0x03))
			return true;
		break;
	}
	case WORD_HASH('I', 'N', 'R', ___, ___): {
		cursor += 3;
		if (p_reg8intel() && ck_end()) {
			emit(0x04 + reg8[0] * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'X', ___, ___): {
		cursor += 3;
		if (p_reg16sp_intel() && ck_end()) {
			emit(0x03 + reg16[0] * 16);
			return true;
		}
		break;
	}
	case WORD_HASH('D', 'E', 'C', ___, ___): {
		cursor += 3;
		if (p_inc_dec(0x05, 0x0B))
			return true;
		break;
	}
	case WORD_HASH('D', 'C', 'R', ___, ___): {
		cursor += 3;
		if (p_reg8intel() && ck_end()) {
			emit(0x05 + reg8[0] * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('D', 'C', 'X', ___, ___): {
		cursor += 3;
		if (p_reg16sp_intel() && ck_end()) {
			emit(0x0B + reg16[0] * 16);
			return true;
		}
		break;
	}

	// logical
	case WORD_HASH('A', 'N', 'D', ___, ___): {
		cursor += 3;
		if (p_alu8(4))
			return true;
		break;
	}
	case WORD_HASH('A', 'N', 'A', ___, ___): {
		cursor += 3;
		if (p_reg8intel() && ck_end()) {	// ANA r
			emit(0xA0 + reg8[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('A', 'N', 'I', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// ANI n
			emit(0xE6);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'R', ___, ___, ___): {
		cursor += 2;
		if (p_alu8(6))
			return true;
		break;
	}
	case WORD_HASH('O', 'R', 'A', ___, ___): {
		cursor += 3;
		if (p_reg8intel() && ck_end()) {	// ORA r
			emit(0xB0 + reg8[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'R', 'I', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// ORI n
			emit(0xF6);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'O', 'R', ___, ___): {
		cursor += 3;
		if (p_alu8(5))
			return true;
		break;
	}
	case WORD_HASH('X', 'R', 'A', ___, ___): {
		cursor += 3;
		if (p_reg8intel() && ck_end()) {	// XRA r
			emit(0xA8 + reg8[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('X', 'R', 'I', ___, ___): {
		cursor += 3;
		if (p_expr() && ck_end()) {	// XRI n
			emit(0xEE);
			emit(expr[0]);
			return true;
		}
		break;
	}

	// rotate
	case WORD_HASH('R', 'L', 'A', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RLA
			emit(0x17);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'A', 'L', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RAL
			emit(0x17);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'L', 'C', 'A', ___): {
		cursor += 4;
		if (ck_end()) {	// RLCA
			emit(0x07);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'R', 'A', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RRA
			emit(0x1F);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'A', 'R', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RAR
			emit(0x1F);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'R', 'C', 'A', ___): {
		cursor += 4;
		if (ck_end()) {	// RRCA
			emit(0x0F);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'L', 'C', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_rot8(0))	// RLC r
			return true;
		else if (RESTORE_CURSOR(0) && ck_end()) {	// RLC
			emit(0x07);
			return true;
		}
		RESTORE_CURSOR(0);
		break;
	}
	case WORD_HASH('R', 'R', 'C', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_rot8(1))	// RRC r
			return true;
		else if (RESTORE_CURSOR(0) && ck_end()) {	// RRC
			emit(0x0F);
			return true;
		}
		RESTORE_CURSOR(0);
		break;
	}
	case WORD_HASH('R', 'L', ___, ___, ___): {
		cursor += 2;
		if (p_rot8(2))	// RL r
			return true;
		break;
	}
	case WORD_HASH('R', 'R', ___, ___, ___): {
		cursor += 2;
		if (p_rot8(3))	// RR r
			return true;
		break;
	}
	case WORD_HASH('S', 'L', 'A', ___, ___): {
		cursor += 3;
		if (p_rot8(4))	// SLA r
			return true;
		break;
	}
	case WORD_HASH('S', 'R', 'A', ___, ___): {
		cursor += 3;
		if (p_rot8(5))	// SRA r
			return true;
		break;
	}
	case WORD_HASH('S', 'L', 'L', ___, ___): {
		cursor += 3;
		if (p_rot8(6))	// SLL r
			return true;
		break;
	}
	case WORD_HASH('S', 'L', 'I', ___, ___): {
		cursor += 3;
		if (p_rot8(6))	// SLI r
			return true;
		break;
	}
	case WORD_HASH('S', 'R', 'L', ___, ___): {
		cursor += 3;
		if (p_rot8(7))	// SRL r
			return true;
		break;
	}
	case WORD_HASH('R', 'R', 'D', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RRD
			emit(0xED);
			emit(0x67);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'L', 'D', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RLD
			emit(0xED);
			emit(0x6F);
			return true;
		}
		break;
	}

	// bits
	case WORD_HASH('B', 'I', 'T', ___, ___): {
		cursor += 3;
		if (p_bit8(1))
			return true;
		break;
	}
	case WORD_HASH('R', 'E', 'S', ___, ___): {
		cursor += 3;
		if (p_bit8(2))
			return true;
		break;
	}
	case WORD_HASH('S', 'E', 'T', ___, ___): {
		cursor += 3;
		if (p_bit8(3))
			return true;
		break;
	}

	// input/output
	case WORD_HASH('I', 'N', ___, ___, ___): {
		cursor += 2;
		SAVE_CURSOR(0);
		if (p_f() && p_comma() && p_ind_c() && ck_end()) {	// IN F, (C)
			emit(0xED);
			emit(0x70);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_c() && ck_end()) {	// IN (C)
			emit(0xED);
			emit(0x70);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_reg8() && p_comma() && p_ind_c() && ck_end()) {	// IN r, (C)
			emit(0xED);
			emit(0x40 + reg8[0] * 8);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_a() && p_comma() && p_ind_expr() && ck_end()) {	// IN A, (n)
			emit(0xDB);
			emit(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_expr() && ck_end()) {	// IN n
			emit(0xDB);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'I', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// INI
			emit(0xED);
			emit(0xA2);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'I', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// INIR
			emit(0xED);
			emit(0xB2);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'D', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// IND
			emit(0xED);
			emit(0xAA);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'N', 'D', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// INDR
			emit(0xED);
			emit(0xBA);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'U', 'T', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_ind_c() && p_comma() && p_const() && ck_end()) {	// OUT (C), 0
			if (expr[0] != 0)
				range_error();
			else {
				emit(0xED);
				emit(0x71);
				return true;
			}
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_c() && p_comma() && p_reg8() && ck_end()) {	// OUT (C), r
			emit(0xED);
			emit(0x41 + reg8[0] * 8);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_ind_expr() && p_comma() && p_a() && ck_end()) {	// IN (n), A
			emit(0xD3);
			emit(expr[0]);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_expr() && ck_end()) {	// OUT n
			emit(0xD3);
			emit(expr[0]);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'U', 'T', 'I', ___): {
		cursor += 4;
		if (ck_end()) {	// OUTI
			emit(0xED);
			emit(0xA3);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'T', 'I', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// OTIR
			emit(0xED);
			emit(0xB3);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'U', 'T', 'D', ___): {
		cursor += 4;
		if (ck_end()) {	// OUTD
			emit(0xED);
			emit(0xAB);
			return true;
		}
		break;
	}
	case WORD_HASH('O', 'T', 'D', 'R', ___): {
		cursor += 4;
		if (ck_end()) {	// OTDR
			emit(0xED);
			emit(0xBB);
			return true;
		}
		break;
	}

	// cpu control
	case WORD_HASH('N', 'O', 'P', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// NOP
			emit(0x00);
			return true;
		}
		break;
	}
	case WORD_HASH('D', 'I', ___, ___, ___): {
		cursor += 2;
		if (ck_end()) {	// DI
			emit(0xF3);
			return true;
		}
		break;
	}
	case WORD_HASH('E', 'I', ___, ___, ___): {
		cursor += 2;
		if (ck_end()) {	// EI
			emit(0xFB);
			return true;
		}
		break;
	}
	case WORD_HASH('H', 'A', 'L', 'T', ___): {
		cursor += 4;
		if (ck_end()) {	// HALT
			emit(0x76);
			return true;
		}
		break;
	}
	case WORD_HASH('H', 'L', 'T', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// HALT
			emit(0x76);
			return true;
		}
		break;
	}
	case WORD_HASH('I', 'M', ___, ___, ___): {
		cursor += 2;
		if (p_const() && ck_end()) {	// IM n
			switch (expr[0]) {
			case 0: emit(0xED); emit(0x46); return true;
			case 1: emit(0xED); emit(0x56); return true;
			case 2: emit(0xED); emit(0x5E); return true;
			default: range_error();
			}
		}
		break;
	}

	// stack
	case WORD_HASH('P', 'U', 'S', 'H', ___): {
		cursor += 4;
		SAVE_CURSOR(0);
		if (p_reg16af() && ck_end()) {	// PUSH BC/DE/HL/AF
			IX_PREFIX(0);
			emit(0xC5 + reg16[0] * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) && p_reg16af_intel() && ck_end()) {	// PUSH B/BC/D/DE/H/HL/PSW
			emit(0xC5 + reg16[0] * 16);
			return true;
		}
		RESTORE_CURSOR(0);
		break;
	}
	case WORD_HASH('P', 'O', 'P', ___, ___): {
		cursor += 4;
		SAVE_CURSOR(0);
		if (p_reg16af() && ck_end()) {	// POP BC/DE/HL/AF
			IX_PREFIX(0);
			emit(0xC1 + reg16[0] * 16);
			return true;
		}
		else if (RESTORE_CURSOR(0) && p_reg16af_intel() && ck_end()) {	// POP B/BC/D/DE/H/HL/PSW
			emit(0xC1 + reg16[0] * 16);
			return true;
		}
		RESTORE_CURSOR(0);
		break;
	}

	// jump
	case WORD_HASH('J', 'P', ___, ___, ___): {
		cursor += 2;
		SAVE_CURSOR(0);
		if (p_jump_call(0xC3, 0xC2))	// JP flags, nn/CALL nn
			return true;
		else if (RESTORE_CURSOR(0) &&
			p_lparen() && p_hlx() && p_rparen() && ck_end()) {	// JP (HL)/(IX)/(IY)
			IX_PREFIX(0);
			emit(0xE9);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('J', 'M', 'P', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_jump_call(0xC3, 0xC2))	// JP flags, nn/CALL nn
			return true;
		else if (RESTORE_CURSOR(0) &&
			p_lparen() && p_hlx() && p_rparen() && ck_end()) {	// JP (HL)/(IX)/(IY)
			IX_PREFIX(0);
			emit(0xE9);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}
	case WORD_HASH('P', 'C', 'H', 'L', ___): {
		cursor += 4;
		if (ck_end()) {	// PCHL
			emit(0xE9);
			return true;
		}
		break;
	}
	case WORD_HASH('J', 'N', 'Z', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC2, F_NZ))	// JNZ nn
			return true;
		break;
	}
	case WORD_HASH('J', 'Z', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC2, F_Z))	// JZ nn
			return true;
		break;
	}
	case WORD_HASH('J', 'N', 'C', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC2, F_NC))	// JNC nn
			return true;
		break;
	}
	case WORD_HASH('J', 'C', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC2, F_C))	// JC nn
			return true;
		break;
	}
	case WORD_HASH('J', 'P', 'O', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC2, F_PO))	// JPO nn
			return true;
		break;
	}
	case WORD_HASH('J', 'P', 'E', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC2, F_PE))	// JPE nn
			return true;
		break;
	}
	case WORD_HASH('J', 'N', 'V', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC2, F_NV))	// JNV nn
			return true;
		break;
	}
	case WORD_HASH('J', 'V', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC2, F_V))	// JV nn
			return true;
		break;
	}
	case WORD_HASH('J', 'M', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC2, F_M))	// JM nn
			return true;
		break;
	}
	case WORD_HASH('D', 'J', 'N', 'Z', ___): {
		cursor += 4;
		SAVE_CURSOR(0);
		if (!(p_b() && p_comma()))	// b, optional
			RESTORE_CURSOR(0);
		if (p_expr() && ck_end()) {	// DJNZ nn
			int pc = get_pc() + 2;	// after this intruction
			int dist = expr[0] - pc;
			if (dist < -128 || dist>127) {
				range_error();
				return false;
			}
			emit(0x10);
			emit(dist);
			return true;
		}
		break;
	}
	case WORD_HASH('J', 'R', ___, ___, ___): {
		cursor += 2;
		SAVE_CURSOR(0);
		if (p_flags4() && p_comma() && p_expr() && ck_end()) {	// JR flag, nn
			int pc = get_pc() + 2;	// after this intruction
			int dist = expr[0] - pc;
			if (dist < -128 || dist>127) {
				range_error();
				return false;
			}
			emit(0x20 + flags * 8);
			emit(dist);
			return true;
		}
		else if (RESTORE_CURSOR(0) &&
			p_expr() && ck_end()) {	// JR nn
			int pc = get_pc() + 2;	// after this intruction
			int dist = expr[0] - pc;
			if (dist < -128 || dist>127) {
				range_error();
				return false;
			}
			emit(0x18);
			emit(dist);
			return true;
		}
		else {
			RESTORE_CURSOR(0);
		}
		break;
	}

	// call
	case WORD_HASH('C', 'A', 'L', 'L', ___): {
		cursor += 4;
		if (p_jump_call(0xCD, 0xC4))	// CALL flags, nn/CALL nn
			return true;
		break;
	}
	case WORD_HASH('R', 'S', 'T', ___, ___): {
		cursor += 3;
		if (p_const() && ck_end()) {	// RST n
			if (expr[0] >= 0 && expr[0] < 8) {
				emit(0xC7 + expr[0] * 8);
				return true;
			}
			else {
				switch (expr[0]) {
				case 0x00: case 0x08: case 0x10: case 0x18: case 0x20: case 0x28: case 0x30: case 0x38:
					emit(0xC7 + expr[0]);
					return true;
				default:
					range_error();
					return false;
				}
			}
		}
		break;
	}
	case WORD_HASH('C', 'N', 'Z', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC4, F_NZ))	// CNZ nn
			return true;
		break;
	}
	case WORD_HASH('C', 'Z', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC4, F_Z))	// CZ nn
			return true;
		break;
	}
	case WORD_HASH('C', 'N', 'C', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC4, F_NC))	// CNC nn
			return true;
		break;
	}
	case WORD_HASH('C', 'C', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC4, F_C))	// CC nn
			return true;
		break;
	}
	case WORD_HASH('C', 'P', 'O', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC4, F_PO))	// CPO nn
			return true;
		break;
	}
	case WORD_HASH('C', 'P', 'E', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC4, F_PE))	// CPE nn
			return true;
		break;
	}
	case WORD_HASH('C', 'N', 'V', ___, ___): {
		cursor += 3;
		if (p_jump_call_intel(0xC4, F_NV))	// CNV nn
			return true;
		break;
	}
	case WORD_HASH('C', 'V', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC4, F_V))	// CV nn
			return true;
		break;
	}
	case WORD_HASH('C', 'M', ___, ___, ___): {
		cursor += 2;
		if (p_jump_call_intel(0xC4, F_M))	// CM nn
			return true;
		break;
	}

	// return
	case WORD_HASH('R', 'E', 'T', ___, ___): {
		cursor += 3;
		SAVE_CURSOR(0);
		if (p_flags8() && ck_end()) {	// RET flag
			emit(0xC0 + flags * 8);
			return true;
		}
		else if (RESTORE_CURSOR(0) && ck_end()) {	// RET
			emit(0xC9);
			return true;
		}
		RESTORE_CURSOR(0);
		break;
	}
	case WORD_HASH('R', 'N', 'Z', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RNZ
			emit(0xC0 + F_NZ * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'Z', ___, ___, ___): {
		cursor += 2;
		if (ck_end()) {	// RZ
			emit(0xC0 + F_Z * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'N', 'C', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RNC
			emit(0xC0 + F_NC * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'C', ___, ___, ___): {
		cursor += 2;
		if (ck_end()) {	// RC
			emit(0xC0 + F_C * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'P', 'O', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RPO
			emit(0xC0 + F_PO * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'P', 'E', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RPE
			emit(0xC0 + F_PE * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'N', 'V', ___, ___): {
		cursor += 3;
		if (ck_end()) {	// RNV
			emit(0xC0 + F_NV * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'V', ___, ___, ___): {
		cursor += 2;
		if (ck_end()) {	// RV
			emit(0xC0 + F_V * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'P', ___, ___, ___): {
		cursor += 2;
		if (ck_end()) {	// RP
			emit(0xC0 + F_P * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'M', ___, ___, ___): {
		cursor += 2;
		if (ck_end()) {	// RM
			emit(0xC0 + F_M * 8);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'E', 'T', 'I', ___): {
		cursor += 4;
		if (ck_end()) {	// RETI
			emit(0xED);
			emit(0x4D);
			return true;
		}
		break;
	}
	case WORD_HASH('R', 'E', 'T', 'N', ___): {
		cursor += 4;
		if (ck_end()) {	// RETN
			emit(0xED);
			emit(0x45);
			return true;
		}
		break;
	}

	default: break;
	}
	syntax_error();
	return false;
}

static bool p_line(void) {
	bool ok = true;
	blanks();
	if (p_label()) {}
	blanks();
	while (*cursor != '\0') {
		if (!p_statement()) ok = false;
	}
	return ok;
}

static bool p_file_1(void) {
	bool ok = true;
	while (utstring_fgets(input_line, input_file)) {
		cursor = utstring_body(input_line);
		line_num++;
		if (!p_line()) ok = false;
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
	
	size_t save_cursor = cursor - utstring_body(input_line); 
	cursor = utstring_body(input_line);

	bool ok = p_file_1();

	fclose(input_file); 
	input_file = save_input_file;
	
	free(input_filename); 
	input_filename = save_filename;
	
	line_num = save_line_num;
	
	utstring_clear(input_line); 
	utstring_printf(input_line, "%s", save_line); 
	free(save_line);

	cursor = utstring_body(input_line) + save_cursor;

	return ok;
}

bool assemble_file(const char* input_filename) {
	init_frontend();

	UT_string* output_filename; 
	utstring_new(output_filename);
	
	remove_ext(output_filename, input_filename); 
	utstring_printf(output_filename, ".bin");
	
	init_backend(utstring_body(output_filename));
	utstring_free(output_filename);

	bool ok = parse_file(input_filename);

	return ok;
}
