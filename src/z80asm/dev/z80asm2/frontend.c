//-----------------------------------------------------------------------------
// z80asm restart
// Copyright (C) Paulo Custodio, 2011-2019
// License: http://www.perlfoundation.org/artistic_license_2_0
// Repository: https://github.com/z88dk/z88dk
//-----------------------------------------------------------------------------
#include "frontend.h"
#include "backend.h"
#include "utils.h"
#include "utarray.h"
#include "uthash.h"
#include "utlist.h"
#include "utstring.h"

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

// forward declarations
static void copy_token(void* dst, const void* src);
static void dtor_token(void* elt);

// tokens from scanner, in same space as characters
enum {
	T_END = 0, T_IDENT = 0x100, T_NUM, T_STR,
	T_F, T_I, T_R,
	T_ASMPC,
};

// bit-flags for keyword_t.flags
enum {
	IS_REG8 = 0x0001, IS_REG8_INTEL = 0x0002, IS_REG8_IDX = 0x0004,
	IS_REG16_AF = 0x0008, IS_REG16_SP = 0x0010, IS_REG16_INTEL = 0x0020, IS_REG16_IDX = 0x0040,
	IS_REG16_BCDE = 0x0080,
	IS_FLAG_CZ = 0x0100, IS_FLAG_PM = 0x0200,
	IS_OPCODE = 0x0400,
};

// keyword lookup tables
typedef struct {
	const char* word;
	int id;
	int flags, reg8_value, reg16_value, flag_value;
	bool (*parse)(int opcode_value);
	int opcode_value;
	UT_hash_handle hh;
} keyword_t;

// scanned token
typedef struct token_t {
	int id;					// token id
	const keyword_t* keyword;	// points to keyword if T_IDENT and found in keyword table
	char* str;					// copy of T_IDENT or T_STR token
	int num;					// value of T_NUM token
} token_t;

UT_icd token_icd = { sizeof(token_t), NULL, copy_token, dtor_token };

// scanner state
typedef struct scan_t {
	UT_array* tokens;			// scanned tokens

	struct scan_t* next;		// LL-list of scan states
} scan_t;

// forward declarations
static void init_keywords(void);
static const keyword_t* lookup_keyword(const char* word);

// globals
static FILE* input_file;
static char* input_filename;
static int line_num;
static int num_errors;

static scan_t* scanner;				// current scanner
static token_t* yy;					// points to tokens to be analyzed

//-----------------------------------------------------------------------------
// init
//-----------------------------------------------------------------------------
static void init(void) {
	static bool inited = false;
	if (!inited) {
		if (input_file) fclose(input_file);
		input_file = NULL;
		free(input_filename);
		input_filename = NULL;
		line_num = num_errors = 0;

		init_keywords();

		inited = true;
	}
}

//-----------------------------------------------------------------------------
// scanner
//-----------------------------------------------------------------------------
static void copy_token(void* dst_, const void* src_) {
	token_t* dst = dst_;
	const token_t* src = src_;

	dst->id = src->id;
	dst->keyword = src->keyword;
	dst->str = src->str ? safe_strdup(src->str) : NULL;
	dst->num = src->num;
}

static void dtor_token(void* elt_) {
	token_t* elt = elt_;
	free(elt->str);
}

// start a new scan state
static void new_scan(void) {
	scan_t* newyy = safe_calloc(1, sizeof(scan_t));
	LL_PREPEND(scanner, newyy);
	utarray_new(scanner->tokens, &token_icd);
}

static void delete_scan(void) {
	scan_t* old = scanner;
	utarray_free(old->tokens);
	LL_DELETE(scanner, old);
	free(old);
}

static token_t* scan_text(const char* input) {
	UT_string* str; utstring_new(str);
	utarray_clear(scanner->tokens);

	// scan all input tokens
	token_t empty = { T_END };
	const char* p = input;
	while (true) {
		utarray_push_back(scanner->tokens, &empty);		// add token with id=T_END
		token_t* tok = (token_t*)utarray_back(scanner->tokens);	// point to last token

		while (isspace(*p)) p++;						// skip spaces
		if (*p == '\0' || *p == ';') break;				// end of line of start of comment

		const char* ts = p;
		if (*p == '_' || isalpha(*p)) {					// T_IDENT
			while (*p == '_' || isalnum(*p)) p++;
			utstring_set_n(str, ts, p - ts);			// identifier

			tok->id = T_IDENT;
			tok->str = safe_strdup(utstring_body(str));	// make a copy

			utstring_toupper(str);						// convert to upper case to lookup keyword
			tok->keyword = lookup_keyword(utstring_body(str));
		}
		else if (isdigit(*p)) {							// T_NUM
			tok->id = T_NUM;
			tok->num = (int)strtol(p, (char**)& p, 0);
		}
		else {											// any other
			tok->id = *p++;
		}
	}
	utstring_free(str);

	return (token_t*)utarray_front(scanner->tokens);
}

//-----------------------------------------------------------------------------
// errors
//-----------------------------------------------------------------------------
void syntax_error(void) {
	fprintf(stderr, "Error at %s line %d: Syntax error\n", input_filename, line_num);
	num_errors++;
	yy = (token_t*)utarray_back(scanner->tokens);		// skip rest of line
}

void range_error(int n) {
	fprintf(stderr, "Error at %s line %d: Range error: %d\n", input_filename, line_num, n);
	num_errors++;
	yy = (token_t*)utarray_back(scanner->tokens);		// skip rest of line
}

void illegal_opcode_error(void) {
	fprintf(stderr, "Error at %s line %d: Illegal instruction\n", input_filename, line_num);
	num_errors++;
	yy = (token_t*)utarray_back(scanner->tokens);		// skip rest of line
}

void reserved_warning(const char* word) {
	fprintf(stderr, "Warning at %s line %d: Keyword used as symbol: %s\n", input_filename, line_num, word);
}

//-----------------------------------------------------------------------------
// parser
//-----------------------------------------------------------------------------
static const keyword_t* parse_keyword(int mask) {
	if (yy[0].id == T_IDENT && yy[0].keyword && (yy[0].keyword->flags & mask) != 0) {
		yy++;
		return yy[-1].keyword;
	}
	else
		return NULL;
}

static bool parse_reg8(int flags, int* out) {
	const keyword_t* kw = parse_keyword(flags);
	if (kw) {
		*out = kw->reg8_value;
		return true;
	}
	else 
		return false;
}

static bool parse_reg16(int flags, int* out) {
	const keyword_t* kw = parse_keyword(flags);
	if (kw) {
		*out = kw->reg16_value;
		return true;
	}
	else 
		return false;
}

static bool parse_flags(int flags, int* out) {
	const keyword_t* kw = parse_keyword(flags);
	if (kw) {
		*out = kw->flag_value;
		return true;
	}
	else
		return false;
}

static bool FLAGS4(int* out) {
	return parse_flags(IS_FLAG_CZ, out);
}

static bool FLAGS8(int* out) {
	return parse_flags(IS_FLAG_CZ | IS_FLAG_PM, out);
}

static bool EOS(void) {
	switch (yy[0].id) {
	case '\0':	return true;
	case ':':	yy++; return true;
	case '\\':	yy++; return true;
	default:	return false;
	}
}

static bool KW(int id) {
	if (yy[0].id == T_IDENT && yy[0].keyword && yy[0].keyword->id == id) {
		yy++;
		return true;
	}
	else
		return false;
}

static bool TK(int id) {
	if (yy[0].id == id) {
		yy++;
		return true;
	}
	else
		return false;
}

static bool LABEL(UT_string* label) {
	int ident;
	if (yy[0].id == '.' && yy[1].id == T_IDENT)
		ident = 1;
	else if (yy[0].id == T_IDENT && yy[1].id == ':')
		ident = 0;
	else
		return false;

	utstring_set(label, yy[ident].str);		// get label
	if (yy[ident].keyword)
		reserved_warning(yy[ident].str);
	yy += 2;
	return true;
}

static bool SIGN(int* out) {
	switch (yy[0].id) {
	case '-':	*out = -1; yy++; return true;
	case '+':	*out = 1; yy++; return true;
	default:	*out = 1; return false;
	}
}

static bool EXPR(int* out) {	// TODO: parse expressions
	int sign = 1;
	SIGN(&sign);
	switch (yy[0].id) {
	case '$':
		*out = sign * get_pc();
		yy++;
		return true;

	case T_IDENT:
		if (yy[0].keyword && yy[0].keyword->id == T_ASMPC) {
			*out = sign * get_pc();
			yy++;
			return true;
		}
		else
			return false;

	case T_NUM:
		*out = sign * yy[0].num;
		yy++;
		return true;

	default:
		return false;
	}
}

static bool CONST(int* out) {	// TODO: parse expressions
	if (yy[0].id == T_NUM) {
		*out = yy[0].num;
		yy++;
		return true;
	}
	return false;
}

static bool IND_EXPR(int* out) {
	token_t* yy0 = yy;
	if (TK('(') && EXPR(out) && TK(')'))
		return true;
	yy = yy0;
	return false;
}

static bool REG8(int* out) {
	return parse_reg8(IS_REG8, out);
}

static bool REG8_X(int* out) {
	return parse_reg8(IS_REG8 | IS_REG8_IDX, out);
}

static bool REG8_INTEL(int* out) {
	return parse_reg8(IS_REG8 | IS_REG8_INTEL, out);
}

static bool A() {
	int r;
	if (REG8(&r) && r == R_A)
		return true;
	return false;
}

static bool B() {
	int r;
	if (REG8(&r) && r == R_B)
		return true;
	return false;
}

static bool C() {
	int r;
	if (REG8(&r) && r == R_C)
		return true;
	return false;
}

static bool IND_C(void) {
	token_t* yy0 = yy;
	if (TK('(') && C() && TK(')'))
		return true;
	yy = yy0;
	return false;
}

static void OPT_A_COMMA() {
	token_t* yy0 = yy;
	if (A() && TK(','))
		return;
	else
		yy = yy0;
}

static bool REG16_BCDE(int* out) {
	return parse_reg16(IS_REG16_BCDE, out);
}

static bool REG16_SPX(int* out) {
	return parse_reg16(IS_REG16_SP | IS_REG16_IDX, out);
}

static bool REG16_AFX(int* out) {
	return parse_reg16(IS_REG16_AF | IS_REG16_IDX, out);
}

static bool REG16_AF_INTEL(int* out) {
	return parse_reg16(IS_REG16_AF | IS_REG16_INTEL, out);
}

static bool REG16_SP_INTEL(int* out) {
	return parse_reg16(IS_REG16_SP | IS_REG16_INTEL, out);
}

static bool BC() {
	int rr;
	if (REG16_SPX(&rr) && rr == RR_BC)
		return true;
	return false;
}

static bool DE() {
	int rr;
	if (REG16_SPX(&rr) && rr == RR_DE)
		return true;
	return false;
}

static bool HL() {
	int rr;
	if (REG16_SPX(&rr) && rr == RR_HL)
		return true;
	return false;
}

static bool SP() {
	int rr;
	if (REG16_SPX(&rr) && rr == RR_SP)
		return true;
	return false;
}

static bool AF() {
	int rr;
	if (REG16_AFX(&rr) && rr == RR_AF)
		return true;
	return false;
}

static bool IND_BCDE(int* out) {			// (BC)/(DE)
	token_t* yy0 = yy;
	int inc_dec = 0, sign;

	if (!TK('(')) goto fail;

	if (SIGN(&sign)) {						// pre-increment/pre-decrement
		if (sign == 1)	inc_dec |= PRE_INC;
		else			inc_dec |= PRE_DEC;
	}

	if (!REG16_BCDE(out)) goto fail;		// only BC or DE

	if (SIGN(&sign)) {						// pos-increment/pos-decrement
		if (sign == 1)	inc_dec |= POS_INC;
		else			inc_dec |= POS_DEC;
	}

	if (TK(')')) goto ok;

fail:
	yy = yy0;
	return false;

ok:
	*out |= inc_dec;
	return true;
}

static bool IND_HL(void) {
	token_t* yy0 = yy;
	if (TK('(') && HL() && TK(')'))
		return true;
	yy = yy0;
	return false;
}

static bool X(int* out) {
	return parse_reg16(IS_REG16_IDX, out);
}

static bool PLUS_DIS_RPAREN(int* out) {
	int sign = 1;
	int dis = 0;

	if (TK(')')) {
		*out = 0;
		return true;
	}

	token_t* yy0 = yy;
	if (SIGN(&sign) && EXPR(&dis) && TK(')')) {
		*out = sign * dis;
		return true;
	}
	yy = yy0;
	*out = 0;
	return false;
}

static bool IND_X(int* x, int* dis) {
	token_t* yy0 = yy;
	int inc_dec = 0, sign;
	*dis = 0;

	if (!TK('(')) goto fail;

	if (SIGN(&sign)) {					// pre-increment/pre-decrement
		if (sign == 1)	inc_dec |= PRE_INC;
		else			inc_dec |= PRE_DEC;
	}

	if (!X(x)) goto fail;

	if ((*x & IDX_MASK) == IDX_HL) {	// HL
		if ((*x & POS_MASK) == 0) {		// not HLD nor HLI
			if (SIGN(&sign)) {			// pos-increment/pos-decrement
				if (sign == 1)	inc_dec |= POS_INC;
				else			inc_dec |= POS_DEC;
			}
			if (TK(')')) goto ok;
		}
		else {							// HLD or HLI
			if (TK(')')) goto ok;
		}
	}
	else {								// IX/IY
		if (inc_dec != 0) goto fail;	// cannot pre-increment/decrement IX/IY
		if (PLUS_DIS_RPAREN(dis)) goto ok;
	}

fail:
	yy = yy0;
	return false;

ok:
	*x |= inc_dec;
	return true;
}

static bool check_alu8(int op) {
	int r, n, x, dis;
	OPT_A_COMMA();							// alu: "a," is optional
	token_t* yy0 = yy;
	if (REG8_X(&r) && EOS())				// alu B/C/D/E/H/L/A/IXH/IYH/IXL/IYL
		return emit_alu_r(op, r);
	yy = yy0;
	if (IND_X(&x, &dis) && EOS()) 			// alu (HL)/(IX+d)/(IY+d)
		return emit_alu_indx(op, x, dis);
	yy = yy0;
	if (EXPR(&n) && EOS())					// alu n
		return emit_alu_n(op, n);
	yy = yy0;
	return false;
}

static bool parse_alu8(int op) {
	if (check_alu8(op))
		return true;
	syntax_error();
	return false;
}

static bool check_rot8(int op) {
	int r, x, dis;
	token_t* yy0 = yy;
	if (REG8(&r) && EOS())									// rot B/C/D/E/H/L/A
		return emit_rot_r(op, r);
	yy = yy0;
	if (IND_X(&x, &dis) && TK(',') && REG8(&r) && EOS())	// rot (HL)/(IX+d)/(IY+d), r
		return emit_rot_indx_r(op, x, dis, r);
	yy = yy0;
	if (IND_X(&x, &dis) && EOS())							// rot (HL)/(IX+d)/(IY+d)
		return emit_rot_indx(op, x, dis);
	yy = yy0;
	return false;
}

static bool parse_rot8(int op) {
	if (check_rot8(op))
		return true;
	syntax_error();
	return false;
}

static bool parse_bit8(int op) {
	int r, x, bit, dis;
	if (CONST(&bit) && TK(',')) {
		token_t* yy0 = yy;
		if (REG8(&r) && EOS())									// bit/res/set b, B/C/D/E/H/L/A
			return emit_bit_r(op, bit, r);
		yy = yy0;
		if (IND_X(&x, &dis) && TK(',') && REG8(&r) && EOS())	// bit/res/set b, (HL)/(IX+d)/(IY+d), r
			return emit_bit_indx_r(op, bit, x, dis, r);
		yy = yy0;
		if (IND_X(&x, &dis) && EOS())							// bit/res/set b, (HL)/(IX+d)/(IY+d)
			return emit_bit_indx(op, bit, x, dis);
	}
	syntax_error();
	return false;
}

static bool parse_ld(int dummy) {
	int r, r1, r2, rr, x, n, nn, dis;
	token_t* yy0 = yy;
	if (REG8_X(&r1) && TK(',') && REG8_X(&r2) && EOS())			// LD r, r
		return emit_ld_r_r(r1, r2);
	yy = yy0;
	if (REG8(&r) && TK(',') && IND_X(&x, &dis) && EOS())		// LD r, (HL)/(IX+d)/(IY+d)
		return emit_ld_r_indx(r, x, dis);
	yy = yy0;
	if (IND_X(&x, &dis) && TK(',') && REG8(&r) && EOS())		// LD (HL)/(IX+d)/(IY+d), r
		return emit_ld_indx_r(x, dis, r);
	yy = yy0;
	if (A() && TK(',') && IND_BCDE(&rr) && EOS())				// LD A, (BC/DE)
		return emit_ld_a_indrr(rr);
	yy = yy0;
	if (IND_BCDE(&rr) && TK(',') && A() && EOS())				// LD (BC/DE), A
		return emit_ld_indrr_a(rr);
	yy = yy0;
	if (REG8_X(&r) && TK(',') && EXPR(&n) && EOS())				// LD B/C/D/E/H/L/A/IXH/IXL/IYH/IYL, n
		return emit_ld_r_n(r, n);
	yy = yy0;
	if (IND_X(&x, &dis) && TK(',') && EXPR(&n) && EOS())		// LD (HL)/(IX+d)/(IY+d), n
		return emit_ld_indx_n(x, dis, n);
	yy = yy0;
	if (REG16_SPX(&rr) && TK(',') && EXPR(&nn) && EOS())		// LD BC/DE/HL/SP/IX/IY, nn
		return emit_ld_rr_nn(rr, nn);
	yy = yy0;
	if (REG16_SPX(&rr) && TK(',') && IND_EXPR(&nn) && EOS())	// LD BC/DE/HL/SP/IX/IY, (nn)
		return emit_ld_rr_indnn(rr, nn);
	yy = yy0;
	if (IND_EXPR(&nn) && TK(',') && REG16_SPX(&rr) && EOS())	// LD (nn), BC/DE/HL/SP/IX/IY
		return emit_ld_indnn_rr(nn, rr);
	yy = yy0;
	if (A() && TK(',') && IND_EXPR(&nn) && EOS())				// LD A, (nn)
		return emit_ld_a_indnn(nn);
	yy = yy0;
	if (IND_EXPR(&nn) && TK(',') && A() && EOS())				// LD (nn), A
		return emit_ld_indnn_a(nn);
	yy = yy0;
	if (KW(T_I) && TK(',') && A() && EOS())						// LD I, A
		return emit_ld_i_a();
	yy = yy0;
	if (KW(T_R) && TK(',') && A() && EOS())						// LD R, A
		return emit_ld_r_a();
	yy = yy0;
	if (A() && TK(',') && KW(T_I) && EOS())						// LD A, I
		return emit_ld_a_i();
	yy = yy0;
	if (A() && TK(',') && KW(T_R) && EOS())						// LD A, R
		return emit_ld_a_r();
	yy = yy0;
	if (SP() && TK(',') && X(&x) && EOS())						// LD SP, HL/IX/IY
		return emit_ld_sp_x(x);
	yy = yy0;
	if (BC() && TK(',') && DE() && EOS()) 						// LD BC, DE
		return (
			emit_ld_r_r(R_B, R_D) &&
			emit_ld_r_r(R_C, R_E));
	yy = yy0;
	if (BC() && TK(',') && X(&x) && EOS())						// LD BC, HL/IX/IY
		return (
			emit_ld_r_r(R_B, R_H | (x & IDX_MASK)) &&
			emit_ld_r_r(R_C, R_L | (x & IDX_MASK)));
	yy = yy0;
	if (DE() && TK(',') && BC() && EOS())						// LD DE, BC
		return (
			emit_ld_r_r(R_D, R_B) &&
			emit_ld_r_r(R_E, R_C));
	yy = yy0;
	if (DE() && TK(',') && X(&x) && EOS())						// LD DE, HL/IX/IY
		return (
			emit_ld_r_r(R_D, R_H | (x & IDX_MASK)) &&
			emit_ld_r_r(R_E, R_L | (x & IDX_MASK)));
	yy = yy0;
	if (X(&x) && TK(',') && BC() && EOS())						// LD HL/IX/IY, BC
		return (
			emit_ld_r_r(R_H | (x & IDX_MASK), R_B) &&
			emit_ld_r_r(R_L | (x & IDX_MASK), R_C));
	yy = yy0;
	if (X(&x) && TK(',') && DE() && EOS())						// LD HL/IX/IY, DE
		return (
			emit_ld_r_r(R_H | (x & IDX_MASK), R_D) &&
			emit_ld_r_r(R_L | (x & IDX_MASK), R_E));
	syntax_error();
	return false;
}

static bool parse_lda_sta(int is_lda) {
	int nn;
	if (EXPR(&nn) && EOS())
		return is_lda ? emit_ld_a_indnn(nn) : emit_ld_indnn_a(nn);
	syntax_error();
	return false;
}

static bool parse_lhld_shld(int is_lhld) {
	int nn;
	if (EXPR(&nn) && EOS())
		return is_lhld ? emit_ld_rr_indnn(RR_HL, nn) : emit_ld_indnn_rr(nn, RR_HL);
	syntax_error();
	return false;
}

static bool parse_ldax_stax(int is_ldax) {
	int rr;
	if (REG16_SP_INTEL(&rr) && EOS())
		return is_ldax ? emit_ld_a_indrr(rr) : emit_ld_indrr_a(rr);
	syntax_error();
	return false;
}

static bool parse_lxi(int dummy) {
	int rr, nn;
	if (REG16_SP_INTEL(&rr) && TK(',') && EXPR(&nn) && EOS()) 
		return emit_ld_rr_nn(rr, nn);
	syntax_error();
	return false;
}

static bool parse_mov(int dummy) {
	int r1, r2;
	if (REG8_INTEL(&r1) && TK(',') && REG8_INTEL(&r2) && EOS()) 
		return emit_ld_r_r(r1, r2);
	syntax_error();
	return false;
}

static bool parse_mvi(int dummy) {
	int r, n;
	if (REG8_INTEL(&r) && TK(',') && EXPR(&n) && EOS()) 
		return emit_ld_r_n(r, n);
	syntax_error(); 
	return false; 
}

static bool parse_sphl(int dummy) {
	if (EOS()) return 
		emit_ld_sp_x(RR_HL);
	syntax_error(); 
	return false; 
}

static bool parse_inc_dec(int is_inc) {
	int r, rr, x, dis;
	token_t* yy0 = yy;
	if (REG16_SPX(&rr) && EOS()) 				// INC/DEC BC/DE/HL/SP/IX/IY
		return is_inc ? emit_inc_rr(rr) : emit_dec_rr(rr);
	yy = yy0;
	if (REG8_X(&r) && EOS())					// INC/DEC B/C/D/E/H/L/A/IXH/IYH/IXL/IYL
		return is_inc ? emit_inc_r(r) : emit_dec_r(r);
	yy = yy0;
	if (IND_X(&x, &dis) && EOS()) 				// INC/DEC (HL)/(IX+d)/(IY+d)
		return is_inc ? emit_inc_indx(x, dis) : emit_dec_indx(x, dis);
	syntax_error();
	return false;
}

static bool parse_inr_dcr(int is_inc) {
	int r;
	if (REG8_INTEL(&r) && EOS())
		return is_inc ? emit_inc_r(r) : emit_dec_r(r);
	syntax_error();
	return false;
}

static bool parse_inx_dcx(int is_inc) {
	int rr;
	if (REG16_SP_INTEL(&rr) && EOS())
		return is_inc ? emit_inc_rr(rr) : emit_dec_rr(rr);
	syntax_error();
	return false;
}

static bool parse_ex(int dummy) {
	int x;
	token_t* yy0 = yy;
	if (AF() && TK(',') && AF() && (TK('\'') || true) && EOS())			// EX AF, AF[']
		return emit_ex_af_af1();
	yy = yy0;
	if (DE() && TK(',') && X(&x) && EOS())								// EX DE, HL
		return emit_ex_de_hl(x);
	yy = yy0;
	if (TK('(') && SP() && TK(')') && TK(',') && X(&x) && EOS())		// EX (SP),HL/IX/IY
		return emit_ex_indsp_hl(x);
	syntax_error();
	return false;
}

static bool parse_exx(int dummy) {
	if (EOS())
		return emit_exx();
	syntax_error();
	return false;
}

static bool parse_xchg(int dummy) {
	if (EOS())
		return emit_ex_de_hl(RR_HL);
	syntax_error();
	return false;
}

static bool parse_xthl(int dummy) {
	if (EOS())
		return emit_ex_indsp_hl(RR_HL);
	syntax_error();
	return false;
}

static bool parse_push_pop(int is_push) {
	int rr;
	token_t* yy0 = yy;
	if (REG16_AFX(&rr) && EOS())		// PUSH/POP BC/DE/HL/AF/IX/IY
		return is_push ? emit_push_rr(rr) : emit_pop_rr(rr);
	yy = yy0;
	if (REG16_AF_INTEL(&rr) && EOS()) 	// PUSH/POP B/BC/D/DE/H/HL/PSW
		return is_push ? emit_push_rr(rr) : emit_pop_rr(rr);
	syntax_error();
	return false;
}

static bool parse_add(int dummy) {
	int r, rr, x, nn;
	token_t* yy0 = yy;
	if (check_alu8(OP_ADD))								// Zilog ALU
		return true;
	yy = yy0;
	if (REG8_INTEL(&r) && r == R_M && EOS())			// ADD m
		return emit_alu_indx(OP_ADD, RR_HL, 0);
	yy = yy0;
	if (X(&x) && TK(',') && REG16_SPX(&rr) && EOS())	// ADD HL/IX/IY, BC/DE/HL/SP/IX/IY
		return emit_add_x_rr(x, rr);
	yy = yy0;
	if (BC() && TK(',') && EXPR(&nn) && EOS())			// ADD BC, nn
		return (
			emit_push_rr(RR_HL) &&
			emit_ld_rr_nn(RR_HL, nn) &&
			emit_add_x_rr(RR_HL, RR_BC) &&
			emit_ld_r_r(R_B, R_H) &&
			emit_ld_r_r(R_C, R_L) &&
			emit_pop_rr(RR_HL));
	yy = yy0;
	if (DE() && TK(',') && EXPR(&nn) && EOS())			// ADD DE, nn
		return (
			emit_push_rr(RR_HL) &&
			emit_ld_rr_nn(RR_HL, nn) &&
			emit_add_x_rr(RR_HL, RR_DE) &&
			emit_ld_r_r(R_D, R_H) &&
			emit_ld_r_r(R_E, R_L) &&
			emit_pop_rr(RR_HL));
	yy = yy0;
	if (X(&x) && TK(',') && EXPR(&nn) && EOS())			// ADD HL/IX/IY, nn
		return (
			emit_push_rr(RR_DE) &&
			emit_ld_rr_nn(RR_DE, nn) &&
			emit_add_x_rr(x, RR_DE) &&
			emit_pop_rr(RR_DE));
	syntax_error();
	return false;
}

static bool parse_adc(int dummy) {
	int r, rr, x;
	token_t* yy0 = yy;
	if (check_alu8(OP_ADC))								// Zilog ALU
		return true;
	yy = yy0;
	if (REG8_INTEL(&r) && r == R_M && EOS())			// ADC m
		return emit_alu_indx(OP_ADC, RR_HL, 0);
	yy = yy0;
	if (X(&x) && TK(',') && REG16_SPX(&rr) && EOS()) 	// ADC HL, BC/DE/HL/SP
		return emit_adc_x_rr(x, rr);
	syntax_error();
	return false;
}

static bool parse_dad(int dummy) {
	int rr;
	if (REG16_SP_INTEL(&rr) && EOS())					// DAD m
		return emit_add_x_rr(RR_HL, rr);
	syntax_error();
	return false;
}

static bool parse_sub(int dummy) {
	int r;
	token_t* yy0 = yy;
	if (check_alu8(OP_SUB))								// Zilog ALU
		return true;
	yy = yy0;
	if (REG8_INTEL(&r) && EOS())						// SUB r
		return emit_alu_r(OP_SUB, r);
	syntax_error();
	return false;
}

static bool parse_sbc(int dummy) {
	int rr, x;
	token_t* yy0 = yy;
	if (check_alu8(OP_SBC))							// Zilog ALU
		return true;
	yy = yy0;
	if (X(&x) && TK(',') && REG16_SPX(&rr) && EOS())// SBC HL, BC/DE/HL/SP
		return emit_sbc_x_rr(x, rr);
	syntax_error();
	return false;
}

static bool parse_daa(int dummy) {
	if (EOS())
		return emit_daa(); 							// DAA
	syntax_error();
	return false;
}

static bool parse_neg(int dummy) {
	if ((A() || true) && EOS()) 					// NEG [A]
		return emit_neg();
	syntax_error();
	return false;
}

static bool parse_cpl(int dummy) {
	if ((A() || true) && EOS())						// CPL [A]
		return emit_cpl();
	syntax_error();
	return false;
}

static bool parse_cma(int dummy) {
	if (EOS())
		return emit_cpl(); 							// CMA
	syntax_error();
	return false;
}

static bool parse_scf(int dummy) {
	if (EOS()) 										// SCF
		return emit_scf();
	syntax_error();
	return false;
}

static bool parse_ccf(int dummy) {
	if (EOS())										// CCF
		return emit_ccf();
	syntax_error();
	return false;
}

static bool parse_intel_alu_r(int op) {
	int r;
	if (REG8_INTEL(&r) && EOS())
		return emit_alu_r(op, r);
	syntax_error();
	return false;
}

static bool parse_intel_alu_n(int op) {
	int n;
	if (EXPR(&n) && EOS())
		return emit_alu_n(op, n);
	syntax_error();
	return false;
}

static bool parse_cmp(int dummy) {
	if (check_alu8(OP_CP) || parse_intel_alu_r(OP_CP))
		return true;
	syntax_error();
	return false;
}

static bool parse_rla_rra(int is_left) {
	if (EOS()) 										// RLA/RRA
		return is_left ? emit_rla() : emit_rra();
	syntax_error();
	return false;
}

static bool parse_rlca_rrca(int is_left) {
	if (EOS()) 										// RLCA/RRCA
		return is_left ? emit_rlca() : emit_rrca();
	syntax_error();
	return false;
}

static bool parse_rlc_rrc(int is_left) {
	token_t* yy0 = yy;
	if (check_rot8(is_left ? OP_RLC : OP_RRC))		// Zilog RLC/RRC r
		return true;
	yy = yy0;
	if (EOS())										// Intel RLC/RRC
		return is_left ? emit_rlca() : emit_rrca();
	syntax_error();
	return false;
}

static bool parse_rld_rrd(int is_left) {
	if (EOS())										// RLD/RRD
		return is_left ? emit_rld() : emit_rrd();
	syntax_error();
	return false;
}

static bool parse_ldi_ldd(int is_inc) {
	int rr;
	token_t* yy0 = yy;
	if (IND_BCDE(&rr) && TK(',') && A() && EOS()) 		// LDI/LDD (BC/DE), A
		return (
			emit_ld_indrr_a(rr) &&
			(is_inc ? emit_inc_rr(rr) : emit_dec_rr(rr)));
	yy = yy0;
	if (A() && TK(',') && IND_BCDE(&rr) && EOS()) 		// LDI/LDD A, (BC/DE)
		return (
			emit_ld_a_indrr(rr) &&
			(is_inc ? emit_inc_rr(rr) : emit_dec_rr(rr)));
	yy = yy0;
	if (IND_HL() && TK(',') && A() && EOS())			// LDI/LDD (HL), A
		return (
			emit_ld_indx_r(RR_HL, 0, R_A) &&
			(is_inc ? emit_inc_rr(RR_HL) : emit_dec_rr(RR_HL)));
	yy = yy0;
	if (A() && TK(',') && IND_HL() && EOS())			// LDI/LDD A, (HL)
		return (
			emit_ld_r_indx(R_A, RR_HL, 0) &&
			(is_inc ? emit_inc_rr(RR_HL) : emit_dec_rr(RR_HL)));
	yy = yy0;
	if (EOS())												// LDI/LDD
		return is_inc ? emit_ldi() : emit_ldd();
	syntax_error();
	return false;
}

static bool parse_ldir_lddr(int is_inc) {
	if (EOS())												// LDIR/LDDR
		return is_inc ? emit_ldir() : emit_lddr();
	syntax_error();
	return false;
}

static bool parse_cpi(int dummy) {
	int n;
	token_t* yy0 = yy;
	if (EXPR(&n) && EOS())									// CPI n
		return emit_alu_n(OP_CP, n);
	yy = yy0;
	if (EOS())												// CPI
		return emit_cpi();
	syntax_error();
	return false;
}

static bool parse_cpd(int dummy) {
	if (EOS())												// CPD
		return emit_cpd();
	syntax_error();
	return false;
}

static bool parse_cpir_cpdr(int is_inc) {
	if (EOS())												// CPIR/CPDR
		return is_inc ? emit_cpir() : emit_cpdr();
	syntax_error();
	return false;
}

static bool parse_in(int dummy) {
	int r, n;
	token_t* yy0 = yy;
	if (KW(T_F) && TK(',') && IND_C() && EOS()) 			// IN F, (C)
		return emit_in_f_indc();
	yy = yy0;
	if (IND_C() && EOS())									// IN (C)
		return emit_in_f_indc();
	yy = yy0;
	if (REG8(&r) && TK(',') && IND_C() && EOS())			// IN r, (C)
		return emit_in_r_indc(r);
	yy = yy0;
	if (A() && TK(',') && IND_EXPR(&n) && EOS())		// IN A, (n)
		return emit_in_a_indn(n);
	yy = yy0;
	if (EXPR(&n) && EOS())									// IN n
		return emit_in_a_indn(n);	
	syntax_error();
	return false;
}

static bool parse_ini_ind(int is_inc) {
	if (EOS())												// INI/IND
		return is_inc ? emit_ini() : emit_ind();
	syntax_error();
	return false;
}

static bool parse_inir_indr(int is_inc) {
	if (EOS())												// INIR/INDR
		return is_inc ? emit_inir() : emit_indr();
	syntax_error();
	return false;
}

static bool parse_out(int dummy) {
	int r, n;
	token_t* yy0 = yy;
	if (IND_C() && TK(',') && CONST(&n) && EOS())			// OUT (C), 0
		return emit_out_indc_n(n);
	yy = yy0;
	if (IND_C() && TK(',') && REG8(&r) && EOS()) 			// OUT (C), r
		return emit_out_indc_r(r);
	yy = yy0;
	if (IND_EXPR(&n) && TK(',') && A() && EOS()) 			// OUT (n), A
		return emit_out_indn_a(n);
	if (EXPR(&n) && EOS())									// OUT n
		return emit_out_indn_a(n);
	syntax_error();
	return false;
}

static bool parse_outi_outd(int is_inc) {
	if (EOS())												// OUTI/OUTD
		return is_inc ? emit_outi() : emit_outd();
	syntax_error();
	return false;
}

static bool parse_otir_otdr(int is_inc) {
	if (EOS())												// OTIR/OTDR
		return is_inc ? emit_otir() : emit_otdr();
	syntax_error();
	return false;
}

static bool parse_nop(int dummy) {
	if (EOS())												// NOP
		return emit_nop();
	syntax_error();
	return false;
}

static bool parse_di(int dummy) {
	if (EOS())												// DI
		return emit_di();
	syntax_error();
	return false;
}

static bool parse_ei(int dummy) {
	if (EOS())												// EI
		return emit_ei();
	syntax_error();
	return false;
}

static bool parse_halt(int dummy) {
	if (EOS())												// HALT
		return emit_halt();
	syntax_error();
	return false;
}

static bool parse_im(int dummy) {
	int n;
	if (CONST(&n) && EOS())									// IM n
		return emit_im(n);
	syntax_error();
	return false;
}

static bool parse_jp(int dummy) {
	int f, nn, x;
	token_t* yy0 = yy;
	if (FLAGS8(&f) && TK(',') && EXPR(&nn) && EOS())		// JP f, nn
		return emit_jp_f_nn(f, nn);
	yy = yy0;
	if (EXPR(&nn) && EOS()) 								// JP nn
		return emit_jp_nn(nn);
	if (TK('(') && X(&x) && TK(')') && EOS())				// JP (HL)/(IX)/(IY)
		return emit_jp_x(x);
	syntax_error();
	return false;
}

static bool parse_jp_intel(int f) {
	int nn;
	if (EXPR(&nn) && EOS())
		return emit_jp_f_nn(f, nn);
	syntax_error();
	return false;
}

static bool parse_pchl(int dummy) {
	if (EOS())												// JP (HL)
		return emit_jp_x(RR_HL);
	syntax_error();
	return false;
}

static bool parse_djnz(int dummy) {
	int nn;
	token_t* yy0 = yy;
	if (!(B() && TK(',')))									// [b,] optional
		yy = yy0;
	if (EXPR(&nn) && EOS())									// DJNZ nn
		return emit_djnz_nn(nn);
	syntax_error();
	return false;
}

static bool parse_jr(int dummy) {
	int f, nn;
	token_t* yy0 = yy;
	if (FLAGS4(&f) && TK(',') && EXPR(&nn) && EOS())		// JR f, nn
		return emit_jr_f_nn(f, nn);
	yy = yy0;
	if (EXPR(&nn) && EOS())									// JR nn
		return emit_jr_nn(nn);
	syntax_error();
	return false;
}

static bool parse_call(int dummy) {
	int f, nn;
	token_t* yy0 = yy;
	if (FLAGS8(&f) && TK(',') && EXPR(&nn) && EOS())		// CALL f, nn
		return emit_call_f_nn(f, nn);
	yy = yy0;
	if (EXPR(&nn) && EOS()) 								// CALL nn
		return emit_call_nn(nn);
	syntax_error();
	return false;
}

static bool parse_call_intel(int f) {
	int nn;
	if (EXPR(&nn) && EOS())
		return emit_call_f_nn(f, nn);
	syntax_error();
	return false;
}

static bool parse_rst(int dummy) {
	int nn;
	if (CONST(&nn) && EOS()) 								// RST n
		return emit_rst(nn);
	syntax_error();
	return false;
}

static bool parse_ret(int dummy) {
	int f;
	token_t* yy0 = yy;
	if (FLAGS8(&f) && EOS()) 								// RET f
		return emit_ret_f(f);
	yy = yy0;
	if (EOS())												// RET
		return emit_ret();
	syntax_error();
	return false;
}

static bool parse_ret_intel(int f) {
	if (EOS())						
		return emit_ret_f(f);
	syntax_error();
	return false;
}

static bool parse_reti(int dummy) {
	if (EOS())												// RETI
		return emit_reti();
	syntax_error();
	return false;
}

static bool parse_retn(int dummy) {
	if (EOS())												// RETN
		return emit_retn();
	syntax_error();
	return false;
}

static bool parse_statement(void) {
	if (EOS())
		return true;
	const keyword_t* kw = parse_keyword(IS_OPCODE);
	if (kw && kw->parse)
		return kw->parse(kw->opcode_value);
	else {
		syntax_error();
		return false;
	}
}

static bool parse_line(void) {
	UT_string* label; utstring_new(label);

	bool ok = true;
	if (LABEL(label)) {
		printf("Define label: %s\n", utstring_body(label));
	}
	while (yy->id != T_END) {
		if (!parse_statement()) ok = false;
	}
	
	utstring_free(label);
	return ok;
}

static bool parse_file_1(void) {
	UT_string* line; utstring_new(line);

	bool ok = true;
	while (utstring_fgets(line, input_file)) {
		line_num++;
		yy = scan_text(utstring_body(line));
		if (!parse_line()) ok = false;
	}

	utstring_free(line);
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

	new_scan();

	bool ok = parse_file_1();

	delete_scan();

	fclose(input_file); 
	input_file = save_input_file;
	
	free(input_filename); 
	input_filename = save_filename;
	
	line_num = save_line_num;
	
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

//-----------------------------------------------------------------------------
// keywords
//-----------------------------------------------------------------------------
static keyword_t keywords_table[] = {
//	word,		id,	flags,			reg8_value,	reg16_value,flag_value,	parse(),		opcode_value

	// 8-bit registers
	{"B",		0,	IS_REG8|
					IS_REG8_INTEL|
					IS_REG16_INTEL,	R_B,		RR_BC,		0,			NULL,			0			},
	{"C",		0,	IS_REG8|
					IS_REG8_INTEL|
					IS_FLAG_CZ,		R_C,		0,			F_C,		NULL,			0			},
	{"D",		0,	IS_REG8|
					IS_REG8_INTEL|
					IS_REG16_INTEL,	R_D,		RR_DE,		0,			NULL,			0			},
	{"E",		0,	IS_REG8|
					IS_REG8_INTEL,	R_E,		0,			0,			NULL,			0			},
	{"H",		0,	IS_REG8|
					IS_REG8_INTEL|
					IS_REG16_INTEL,	R_H,		RR_HL,		0,			NULL,			0			},
	{"L",		0,	IS_REG8|
					IS_REG8_INTEL,	R_L,		0,			0,			NULL,			0			},
	{"M",		0,	IS_REG8_INTEL|
					IS_FLAG_PM,		R_M,		0,			F_M,		NULL,			0			},
	{"A",		0,	IS_REG8|
					IS_REG8_INTEL,	R_A,		0,			0,			NULL,			0			},
	{"IXH",		0,	IS_REG8_IDX,	R_H|IDX_IX,	0,			0,			NULL,			0			},
	{"IXL",		0,	IS_REG8_IDX,	R_L|IDX_IX,	0,			0,			NULL,			0			},
	{"IYH",		0,	IS_REG8_IDX,	R_H|IDX_IY,	0,			0,			NULL,			0			},
	{"IYL",		0,	IS_REG8_IDX,	R_L|IDX_IY,	0,			0,			NULL,			0			},
	
	{"I",		T_I,0,				0,			0,			0,			NULL,			0			},
	{"R",		T_R,0,				0,			0,			0,			NULL,			0			},
	{"F",		T_F,0,				0,			0,			0,			NULL,			0			},

	// 16-bit registers
	{"BC",		0,	IS_REG16_AF|
					IS_REG16_SP|
					IS_REG16_INTEL|
					IS_REG16_BCDE,	0, 			RR_BC,		0,			NULL,			0			},
	{"DE",		0,	IS_REG16_AF|
					IS_REG16_SP|
					IS_REG16_INTEL|
					IS_REG16_BCDE,	0, 			RR_DE,		0,			NULL,			0			},
	{"HL",		0,	IS_REG16_AF|
					IS_REG16_SP|
					IS_REG16_INTEL|
					IS_REG16_IDX,	0, 			RR_HL,		0,			NULL,			0			},
	{"SP",		0,	IS_REG16_SP|
					IS_REG16_INTEL,	0,			RR_SP,		0,			NULL,			0			},
	{"AF",		0,	IS_REG16_AF,	0,			RR_AF,		0,			NULL,			0			},
	{"PSW",		0,	IS_REG16_AF|
					IS_REG16_INTEL,	0,			RR_AF, 		0,			NULL,			0			},
	{"IX",		0,	IS_REG16_IDX,	0,			RR_HL|IDX_IX,
															0,			NULL,			0			},
	{"IY",		0,	IS_REG16_IDX,	0,			RR_HL|IDX_IY,
															0,			NULL,			0			},

	{"HLD",		0,	IS_REG16_IDX,	0,			RR_HL|POS_DEC,
															0,			NULL,			0			},
	{"HLI",		0,	IS_REG16_IDX,	0,			RR_HL|POS_INC,
															0,			NULL,			0			},

	// flags
	{"NZ",		0,	IS_FLAG_CZ,		0,			0,			F_NZ,		NULL,			0			},
	{"Z",		0,	IS_FLAG_CZ,		0,			0,			F_Z,		NULL,			0			},
	{"NC",		0,	IS_FLAG_CZ,		0,			0,			F_NC,		NULL,			0			},
	{"PO",		0,	IS_FLAG_PM,		0,			0,			F_PO,		NULL,			0			},
	{"PE",		0,	IS_FLAG_PM,		0,			0,			F_PE,		NULL,			0			},
	{"NV",		0,	IS_FLAG_PM,		0,			0,			F_NV,		NULL,			0			},
	{"V",		0,	IS_FLAG_PM,		0,			0,			F_V,		NULL,			0			},
	{"P",		0,	IS_FLAG_PM,		0,			0,			F_P,		NULL,			0			},

	// operands
	{"ASMPC",	T_ASMPC, 0,			0,			0,			0,			NULL,			0			},
	
	// load
	{"LD",		0,	IS_OPCODE,		0,			0,			0,			parse_ld,		0			},
	{"LDA",		0,	IS_OPCODE,		0,			0,			0,			parse_lda_sta,	1			},
	{"STA",		0,	IS_OPCODE,		0,			0,			0,			parse_lda_sta,	0			},
	{"LHLD",	0,	IS_OPCODE,		0,			0,			0,			parse_lhld_shld,1			},
	{"SHLD",	0,	IS_OPCODE,		0,			0,			0,			parse_lhld_shld,0			},
	{"LDAX",	0,	IS_OPCODE,		0,			0,			0,			parse_ldax_stax,1			},
	{"STAX",	0,	IS_OPCODE,		0,			0,			0,			parse_ldax_stax,0			},
	{"LXI",		0,	IS_OPCODE,		0,			0,			0,			parse_lxi,		0			},
	{"MOV",		0,	IS_OPCODE,		0,			0,			0,			parse_mov,		0			},
	{"MVI",		0,	IS_OPCODE,		0,			0,			0,			parse_mvi,		0			},
	{"SPHL",	0,	IS_OPCODE,		0,			0,			0,			parse_sphl,		0			},
	
	// increment and decrement
	{"INC",		0,	IS_OPCODE,		0,			0,			0,			parse_inc_dec,	1			},
	{"DEC",		0,	IS_OPCODE,		0,			0,			0,			parse_inc_dec,	0			},
	{"INR",		0,	IS_OPCODE,		0,			0,			0,			parse_inr_dcr,	1			},
	{"DCR",		0,	IS_OPCODE,		0,			0,			0,			parse_inr_dcr,	0			},
	{"INX",		0,	IS_OPCODE,		0,			0,			0,			parse_inx_dcx,	1			},
	{"DCX",		0,	IS_OPCODE,		0,			0,			0,			parse_inx_dcx,	0			},

	// exchange
	{"EX",		0,	IS_OPCODE,		0,			0,			0,			parse_ex,		0			},
	{"EXX",		0,	IS_OPCODE,		0,			0,			0,			parse_exx,		0			},
	{"XCHG",	0,	IS_OPCODE,		0,			0,			0,			parse_xchg,		0			},
	{"XTHL",	0,	IS_OPCODE,		0,			0,			0,			parse_xthl,		0			},

	// stack
	{"PUSH",	0,	IS_OPCODE,		0,			0,			0,			parse_push_pop,	1			},
	{"POP",		0,	IS_OPCODE,		0,			0,			0,			parse_push_pop,	0			},

	// arithmetic and logical
	{"ADD",		0,	IS_OPCODE,		0,			0,			0,			parse_add,		0			},
	{"ADC",		0,	IS_OPCODE,		0,			0,			0,			parse_adc,		0			},
	{"DAD",		0,	IS_OPCODE,		0,			0,			0,			parse_dad,		0			},
	{"SUB",		0,	IS_OPCODE,		0,			0,			0,			parse_sub,		0			},
	{"SBC",		0,	IS_OPCODE,		0,			0,			0,			parse_sbc,		0			},
	{"CP",		0,	IS_OPCODE,		0,			0,			0,			parse_alu8,		OP_CP		},
	{"CMP",		0,	IS_OPCODE,		0,			0,			0,			parse_cmp,		OP_CP		},
	{"AND",		0,	IS_OPCODE,		0,			0,			0,			parse_alu8,		OP_AND		},
	{"OR",		0,	IS_OPCODE,		0,			0,			0,			parse_alu8,		OP_OR		},
	{"XOR",		0,	IS_OPCODE,		0,			0,			0,			parse_alu8,		OP_XOR		},
	{"DAA",		0,	IS_OPCODE,		0,			0,			0,			parse_daa,		0			},
	{"CPL",		0,	IS_OPCODE,		0,			0,			0,			parse_cpl,		0			},
	{"CMA",		0,	IS_OPCODE,		0,			0,			0,			parse_cma,		0			},
	{"SCF",		0,	IS_OPCODE,		0,			0,			0,			parse_scf,		0			},
	{"STC",		0,	IS_OPCODE,		0,			0,			0,			parse_scf,		0			},
	{"CCF",		0,	IS_OPCODE,		0,			0,			0,			parse_ccf,		0			},
	{"CMC",		0,	IS_OPCODE,		0,			0,			0,			parse_ccf,		0			},
	{"NEG",		0,	IS_OPCODE,		0,			0,			0,			parse_neg,		0			},
	{"ADI",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_n, OP_ADD	},
	{"ACI",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_n, OP_ADC	},
	{"SUI",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_n, OP_SUB	},
	{"SBI",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_n, OP_SBC	},
	{"ANI",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_n, OP_AND	},
	{"ORI",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_n, OP_OR	},
	{"XRI",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_n, OP_XOR	},
	{"SBB",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_r, OP_SBC	},
	{"ANA",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_r, OP_AND	},
	{"ORA",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_r, OP_OR	},
	{"XRA",		0,	IS_OPCODE,		0,			0,			0,			parse_intel_alu_r, OP_XOR	},
		
	// rotate and shift
	{"RLA",		0,	IS_OPCODE,		0,			0,			0,			parse_rla_rra,	1			},
	{"RAL",		0,	IS_OPCODE,		0,			0,			0,			parse_rla_rra,	1			},
	{"RLCA",	0,	IS_OPCODE,		0,			0,			0,			parse_rlca_rrca,1			},
	{"RLC",		0,	IS_OPCODE,		0,			0,			0,			parse_rlc_rrc,	1			},
	{"RL",		0,	IS_OPCODE,		0,			0,			0,			parse_rot8,		OP_RL		},
	{"SLA",		0,	IS_OPCODE,		0,			0,			0,			parse_rot8,		OP_SLA		},
	{"SLL",		0,	IS_OPCODE,		0,			0,			0,			parse_rot8,		OP_SLL		},
	{"SLI",		0,	IS_OPCODE,		0,			0,			0,			parse_rot8,		OP_SLI		},
	{"RLD",		0,	IS_OPCODE,		0,			0,			0,			parse_rld_rrd,	1			},
	{"RRA",		0,	IS_OPCODE,		0,			0,			0,			parse_rla_rra,	0			},
	{"RAR",		0,	IS_OPCODE,		0,			0,			0,			parse_rla_rra,	0			},
	{"RRCA",	0,	IS_OPCODE,		0,			0,			0,			parse_rlca_rrca,0			},
	{"RRC",		0,	IS_OPCODE,		0,			0,			0,			parse_rlc_rrc,	0			},
	{"RR",		0,	IS_OPCODE,		0,			0,			0,			parse_rot8,		OP_RR		},
	{"SRA",		0,	IS_OPCODE,		0,			0,			0,			parse_rot8,		OP_SRA		},
	{"SRL",		0,	IS_OPCODE,		0,			0,			0,			parse_rot8,		OP_SRL		},
	{"RRD",		0,	IS_OPCODE,		0,			0,			0,			parse_rld_rrd,	0			},

	// bit manipulation
	{"BIT",		0,	IS_OPCODE,		0,			0,			0,			parse_bit8,		OP_BIT		},
	{"RES",		0,	IS_OPCODE,		0,			0,			0,			parse_bit8,		OP_RES		},
	{"SET",		0,	IS_OPCODE,		0,			0,			0,			parse_bit8,		OP_SET		},

	// block transfer
	{"LDI",		0,	IS_OPCODE,		0,			0,			0,			parse_ldi_ldd,	1			},
	{"LDIR",	0,	IS_OPCODE,		0,			0,			0,			parse_ldir_lddr,1			},
	{"LDD",		0,	IS_OPCODE,		0,			0,			0,			parse_ldi_ldd,	0			},
	{"LDDR",	0,	IS_OPCODE,		0,			0,			0,			parse_ldir_lddr,0			},

	// search
	{"CPI",		0,	IS_OPCODE,		0,			0,			0,			parse_cpi,		0			},
	{"CPIR",	0,	IS_OPCODE,		0,			0,			0,			parse_cpir_cpdr,1			},
	{"CPD",		0,	IS_OPCODE,		0,			0,			0,			parse_cpd,		0			},
	{"CPDR",	0,	IS_OPCODE,		0,			0,			0,			parse_cpir_cpdr,0			},

	// input/output
	{"IN",		0,	IS_OPCODE,		0,			0,			0,			parse_in,		0			},
	{"INI",		0,	IS_OPCODE,		0,			0,			0,			parse_ini_ind,	1			},
	{"INIR",	0,	IS_OPCODE,		0,			0,			0,			parse_inir_indr,1			},
	{"IND",		0,	IS_OPCODE,		0,			0,			0,			parse_ini_ind,	0			},
	{"INDR",	0,	IS_OPCODE,		0,			0,			0,			parse_inir_indr,0			},
	{"OUT",		0,	IS_OPCODE,		0,			0,			0,			parse_out,		0			},
	{"OUTI",	0,	IS_OPCODE,		0,			0,			0,			parse_outi_outd,1			},
	{"OTIR",	0,	IS_OPCODE,		0,			0,			0,			parse_otir_otdr,1			},
	{"OUTD",	0,	IS_OPCODE,		0,			0,			0,			parse_outi_outd,0			},
	{"OTDR",	0,	IS_OPCODE,		0,			0,			0,			parse_otir_otdr,0			},
		
	// cpu control
	{"NOP",		0,	IS_OPCODE,		0,			0,			0,			parse_nop,		0			},
	{"DI",		0,	IS_OPCODE,		0,			0,			0,			parse_di,		0			},
	{"EI",		0,	IS_OPCODE,		0,			0,			0,			parse_ei,		0			},
	{"HALT",	0,	IS_OPCODE,		0,			0,			0,			parse_halt,		0			},
	{"HLT",		0,	IS_OPCODE,		0,			0,			0,			parse_halt,		0			},
	{"IM",		0,	IS_OPCODE,		0,			0,			0,			parse_im,		0			},

	// jump
	{"JP",		0,	IS_OPCODE,		0,			0,			0,			parse_jp,		0			},
	{"JR",		0,	IS_OPCODE,		0,			0,			0,			parse_jr,		0			},
	{"DJNZ",	0,	IS_OPCODE,		0,			0,			0,			parse_djnz,		0			},
	{"JMP",		0,	IS_OPCODE,		0,			0,			0,			parse_jp,		0			},
	{"PCHL",	0,	IS_OPCODE,		0,			0,			0,			parse_pchl,		0			},
	{"JNZ",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_NZ		},
	{"JZ",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_Z			},
	{"JNC",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_NC		},
	{"JC",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_C			},
	{"JPO",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_PO		},
	{"JPE",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_PE		},
	{"JNV",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_NV		},
	{"JV",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_V			},
	// Jump if Positive cannot be parsed, same as JumP
	{"JM",		0,	IS_OPCODE,		0,			0,			0,			parse_jp_intel,	F_M			},

	// call
	{"CALL",	0,	IS_OPCODE,		0,			0,			0,			parse_call,		0			},
	{"RST",		0,	IS_OPCODE,		0,			0,			0,			parse_rst,		0			},
	{"CNZ",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_NZ		},
	{"CZ",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_Z		},
	{"CNC",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_NC		},
	{"CC",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_C		},
	{"CPO",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_PO		},
	{"CPE",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_PE		},
	{"CNV",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_NV		},
	{"CV",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_V		},
	// Call if Positive cannot be parsed, same as ComPare
	{"CM",		0,	IS_OPCODE,		0,			0,			0,			parse_call_intel, F_M		},

	// return
	{"RET",		0,	IS_OPCODE,		0,			0,			0,			parse_ret,		0			},
	{"RETI",	0,	IS_OPCODE,		0,			0,			0,			parse_reti,		0			},
	{"RETN",	0,	IS_OPCODE,		0,			0,			0,			parse_retn,		0			},
	{"RNZ",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_NZ		},
	{"RZ",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_Z			},
	{"RNC",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_NC		},
	{"RC",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_C			},
	{"RPO",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_PO		},
	{"RPE",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_PE		},
	{"RNV",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_NV		},
	{"RV",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_V			},
	{"RP",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_P			},
	{"RM",		0,	IS_OPCODE,		0,			0,			0,			parse_ret_intel,F_M			},

	{ NULL },
};

static keyword_t* keywords_hash;

static void init_keywords(void) {
	for (keyword_t* kw = keywords_table; kw->word != NULL; kw++) {
		HASH_ADD_KEYPTR(hh, keywords_hash, kw->word, strlen(kw->word), kw);
	}
}

static const keyword_t* lookup_keyword(const char* word) {
	keyword_t* kw;
	HASH_FIND_STR(keywords_hash, word, kw);
	return kw;
}
