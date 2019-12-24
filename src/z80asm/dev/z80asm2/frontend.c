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
	T_LOG_AND, T_LOG_OR, T_LOG_XOR, 
	T_NOT_EQ, T_LESS_EQ, T_GREATER_EQ, 
	T_POWER, 
	T_SHIFT_LEFT, T_SHIFT_RIGHT,
	T_DOUBLE_HASH,
	T_ASMPC,
};

// keywords
enum {
	K_B = 1, K_C, K_D, K_E, K_H, K_L, K_M, K_A, K_IXH, K_IXL, K_IYH, K_IYL, K_F, K_I, K_R,
	K_BC, K_DE, K_HL, K_SP, K_AF, K_PSW, K_IX, K_IY, K_HLI, K_HLD,
	K_NZ, K_Z, K_NC, K_PO, K_PE, K_NV, K_V, K_P,
	K_ASMPC,
};

// bit-flags for keyword_t.flags
enum {
	IS_AF = 0x0001, IS_SP = 0x0002, IS_INTEL = 0x0004, 
	IS_ANY = ~0,
};

// keyword Not Applicable value
enum { NA = -1 };

// parse data
typedef struct parse_t {
	int n;
} parse_t;

// keyword lookup tables
typedef struct {
	const char* word;
	int id;
	int flags, reg8, reg16, zflag;
	bool (*parse_emit)(int arg);	// parse and emit
	int arg;
	bool (*parse)(parse_t* data);
	bool (*emit_void)(void);
	bool (*emit_arg)(int arg);
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

inline bool isident_start(int c) {
	return c == '_' || isalpha(c);
}

inline bool isident(int c) {
	return c == '_' || isalnum(c);
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

#if 0
// scan string
static bool scan_asm_string(const char** pp, token_t* tok) {
	char quote = **pp; (*pp)++;
	const char* ts = *pp;
	while (**pp != '\0' && **pp != quote) (*pp)++;
	if (**pp != quote) goto fail;
	tok->id = T_STR;
	tok->str = safe_strdup_n(ts, *pp - ts);
	(*pp)++;
	return true;
fail:
	missing_quote_error();
	return false;
}
#endif

// scan numbers
static int char_digit(int base, char c) {
	if (base == 2) {
		switch (c) {
		case '-': case '0':	return 0;				// binary
		case '#': case '1': return 1;				// bitmap
		default:			return -1;				// error
		}
	}
	if (isdigit(c)) return c - '0';					// digits
	if (isalpha(c)) return 10 + tolower(c) - 'a';	// digits >= 'A'
	return -1;										// error
}

static int scan_int_part(const char** pp, int base, int max_digits) {
	const char* limit;
	if (max_digits > 0)
		limit = *pp + max_digits;
	else
		limit = *pp + strlen(*pp);

	int value = 0, digit;
	while (*pp < limit && (digit = char_digit(base, **pp)) >= 0 && digit < base) {
		value = value * base + digit;
		(*pp)++;
	}
	return value;
}

static bool scan_int(const char** pp, token_t* tok, int base, char suffix) {
	const char* ts = *pp;
	int value = scan_int_part(pp, base, 0);
	if (*pp == ts)
		goto fail;				// nothing read
	if (suffix) {
		if (**pp != suffix)
			goto fail;			// suffix not found
		else
			(*pp)++;			// skip suffix
	}
	if (isident(**pp))
		goto fail;				// number followed by identifier

	tok->id = T_NUM;
	tok->num = value;
	return true;
fail:
	invalid_number_error();
	return false;
}

static bool scan_num(const char** pp, token_t* tok) {
	const char* ts = *pp;
	char quote;
	int value;

	// check for prefixed number
	switch (**pp) {
	case '#': case '$':
		(*pp)++;
		return scan_int(pp, tok, 16, '\0');
	case '%': case '@':
		(*pp)++;
		switch (**pp) {
		case '"': case '\'':
			quote = **pp; (*pp)++;
			return scan_int(pp, tok, 2, quote);
		default:
			return scan_int(pp, tok, 2, '\0');
		}
	case '0':
		switch (tolower((*pp)[1])) {
		case 'x':
			(*pp) += 2;
			return scan_int(pp, tok, 16, '\0');
		case 'b':									// 0bxxx binary; 0bxxxh hex
			value = scan_int_part(pp, 16, 0);
			if (*pp != ts && tolower(**pp) == 'h') {
				(*pp)++;
				goto ok;
			}
			else {
				(*pp) = ts + 2;
				return scan_int(pp, tok, 2, '\0');
			}
		case 'q':
		case 'o':
			(*pp) += 2;
			return scan_int(pp, tok, 8, '\0');
		}
	}

	// check for suffixed number - binary?
	*pp = ts;
	value = scan_int_part(pp, 2, 0);
	if (*pp != ts && tolower((*pp)[0]) == 'b' && !isident((*pp)[1])) {
		(*pp)++;
		goto ok;
	}

	// check for suffixed number - octal?
	*pp = ts;
	value = scan_int_part(pp, 8, 0);
	if (*pp != ts && (tolower((*pp)[0]) == 'o' || tolower((*pp)[0]) == 'q') && !isident((*pp)[1])) {
		(*pp)++;
		goto ok;
	}

	// check for suffixed number - decimal?
	*pp = ts;
	value = scan_int_part(pp, 10, 0);
	if (*pp != ts && tolower((*pp)[0]) == 'd' && !isident((*pp)[1])) {
		(*pp)++;
		goto ok;
	}

	// check for suffixed number - hexadecimal?
	*pp = ts;
	value = scan_int_part(pp, 16, 0);
	if (*pp != ts && tolower((*pp)[0]) == 'h' && !isident((*pp)[1])) {
		(*pp)++;
		goto ok;
	}

	// check for non-suffixed decimal
	*pp = ts;
	value = scan_int_part(pp, 10, 0);
	if (*pp != ts && !isident((*pp)[0])) 
		goto ok;

	invalid_number_error();
	return false;
ok:
	tok->id = T_NUM;
	tok->num = value;
	return true;
}

static bool scan_bin_or_op(const char** pp, token_t* tok) {
	switch ((*pp)[1]) {
	case '0': case '1': case '\'': case '"': 
		return scan_num(pp, tok); 
	default: 
		tok->id = **pp; 
		(*pp)++;
		return true;
	}
}

static bool scan_hex_or_op(const char** pp, token_t* tok) {
	if (isxdigit((*pp)[1])) {	// differentiate "#define" (hash, identifier) from "#def" (0x0DEF)
		(*pp)++;
		const char* ts = *pp;
		scan_int_part(pp, 16, 0);
		if (ts == *pp || isident(**pp)) {
			*pp = ts;
			tok->id = '#';
			return true;
		}
		else {
			*pp = ts - 1;
			return scan_num(pp, tok);
		}
	}
	else {
		tok->id = **pp;
		(*pp)++;
		return true;
	}
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
		if (*p == '\0' || *p == ';') break;				// end of line or start of comment

		const char* ts = p;
		switch (*p) {
		case '!': if (p[1] == '=') { tok->id = T_NOT_EQ;  p += 2; } else { tok->id = *p++; } break;
		case '&': if (p[1] == '&') { tok->id = T_LOG_AND; p += 2; } else { tok->id = *p++; } break;
		case '|': if (p[1] == '|') { tok->id = T_LOG_OR;  p += 2; } else { tok->id = *p++; } break;
		case '^': if (p[1] == '^') { tok->id = T_LOG_XOR; p += 2; } else { tok->id = *p++; } break;
		case '*': if (p[1] == '*') { tok->id = T_POWER;   p += 2; } else { tok->id = *p++; } break;
		case '%': case '@': if (!scan_bin_or_op(&p, tok)) goto fail; else break;
		case '=': if (p[1] == '=') { tok->id = '=';  p += 2; } else { tok->id = *p++; } break;
		case '<': if (p[1] == '>') { tok->id = T_NOT_EQ; p += 2; }
				  else if (p[1] == '=') { tok->id = T_LESS_EQ; p += 2; }
				  else if (p[1] == '<') { tok->id = T_SHIFT_LEFT; p += 2; }
				  else { tok->id = *p++; } break;
		case '>': if (p[1] == '=') { tok->id = T_GREATER_EQ; p += 2; }
				  else if (p[1] == '>') { tok->id = T_SHIFT_RIGHT;  p += 2; }
				  else { tok->id = *p++; } break;
		case '#': if (p[1] == '#') { tok->id = T_DOUBLE_HASH; p += 2; }
				  else if (!scan_hex_or_op(&p, tok)) goto fail; else break;
		case '$': if (isxdigit(p[1])) { if (!scan_num(&p, tok)) goto fail; else break; }
				  else { tok->id = T_ASMPC; p++; } break;
		default:
			if (isident_start (*p)) {						// T_IDENT
				while (isident(*p)) p++;
				utstring_set_n(str, ts, p - ts);			// identifier

				tok->id = T_IDENT;
				tok->str = safe_strdup(utstring_body(str));	// make a copy

				utstring_toupper(str);						// convert to upper case to lookup keyword
				tok->keyword = lookup_keyword(utstring_body(str));
			}
			else if (isdigit(*p)) {							// T_NUM
				if (!scan_num(&p, tok)) goto fail;
			}
			else {											// any other
				tok->id = *p++;
			}
		}
	}
	utstring_free(str);
	return (token_t*)utarray_front(scanner->tokens);
fail:
	utstring_free(str);
	return NULL;
}

//-----------------------------------------------------------------------------
// errors
//-----------------------------------------------------------------------------
static void error_common(void) {
	num_errors++;
	yy = (token_t*)utarray_back(scanner->tokens);		// skip rest of line
}

void syntax_error(void) {
	fprintf(stderr, "Error at %s line %d: Syntax error\n", input_filename, line_num);
	error_common();
}

void range_error(int n) {
	fprintf(stderr, "Error at %s line %d: Range error: %d\n", input_filename, line_num, n);
	error_common();
}

void invalid_number_error(void) {
	fprintf(stderr, "Error at %s line %d: Invalid number\n", input_filename, line_num);
	error_common();
}

void missing_quote_error(void) {
	fprintf(stderr, "Error at %s line %d: Invalid number\n", input_filename, line_num);
	error_common();
}

void illegal_opcode_error(void) {
	fprintf(stderr, "Error at %s line %d: Illegal instruction\n", input_filename, line_num);
	error_common();
}

void reserved_warning(const char* word) {
	fprintf(stderr, "Warning at %s line %d: Keyword used as symbol: %s\n", input_filename, line_num, word);
}

//-----------------------------------------------------------------------------
// parser
//-----------------------------------------------------------------------------
static bool EOS(void) {
	switch (yy[0].id) {
	case T_END:	return true;
	case ':':	yy++; return true;
	case '\\':	yy++; return true;
	default:	return false;
	}
}

static bool TK(int id) {
	if (yy[0].id == id) {
		yy++;
		return true;
	}
	else
		return false;
}

static bool KW(int id) {
	if (yy[0].id == T_IDENT && yy[0].keyword && yy[0].keyword->id == id) {
		yy++;
		return true;
	}
	else
		return false;
}

static const keyword_t* parse_keyword(int mask) {
	if (yy[0].id == T_IDENT && yy[0].keyword && (yy[0].keyword->flags & mask) != 0) {
		yy++;
		return yy[-1].keyword;
	}
	else
		return NULL;
}

static bool parse_reg8(int* out) {
	token_t* yy0 = yy;
	const keyword_t* kw = parse_keyword(IS_ANY);
	if (kw && kw->reg8 != NA) {
		*out = kw->reg8;
		return true;
	}
	yy = yy0;
	return false;
}

static bool REG8(int* out) {
	token_t* yy0 = yy;
	if (parse_reg8(out) && (*out & R_MASK) != R_M && (*out & IDX_MASK) == IDX_HL)
		return true;
	yy = yy0;
	return false;
}

static bool REG8_X(int* out) {
	token_t* yy0 = yy;
	if (parse_reg8(out) && (*out & R_MASK) != R_M)
		return true;
	yy = yy0;
	return false;
}

static bool REG8_INTEL(int* out) {
	token_t* yy0 = yy;
	if (parse_reg8(out) && (*out & IDX_MASK) == IDX_HL)
		return true;
	yy = yy0;
	return false;
}

static bool IND_C(void) {
    token_t* yy0 = yy;
    if (TK('(') && KW(K_C) && TK(')'))
        return true;
    yy = yy0;
    return false;
}

static bool parse_reg16(int mask, int* out) {
	token_t* yy0 = yy;
	const keyword_t* kw = parse_keyword(mask);
	if (kw && kw->reg16 != NA) {
		*out = kw->reg16;
		return true;
	}
	yy = yy0;
	return false;
}

static bool BCDE(int* out) {
    token_t* yy0 = yy;
    if (parse_reg16(IS_SP, out) && (*out == RR_BC || *out == RR_DE))
        return true;
    yy = yy0;
    return false;
}

static bool BCDEHL(int* out) {
    token_t* yy0 = yy;
    if (parse_reg16(IS_SP, out) && (*out == RR_BC || *out == RR_DE || *out == RR_HL))
        return true;
    yy = yy0;
    return false;
}

static bool REG16_SPX(int* out) {
	token_t* yy0 = yy;
	if (parse_reg16(IS_SP, out))
		return true;
	yy = yy0;
	return false;
}

static bool REG16_AFX(int* out) {
	token_t* yy0 = yy;
	if (parse_reg16(IS_AF, out))
		return true;
	yy = yy0;
	return false;
}

static bool REG16_AF_INTEL(int* out) {
	token_t* yy0 = yy;
	if (parse_reg16(K_AF | IS_INTEL, out))
		return true;
	yy = yy0;
	return false;
}

static bool REG16_SP_INTEL(int* out) {
	token_t* yy0 = yy;
	if (parse_reg16(K_SP | IS_INTEL, out))
		return true;
	yy = yy0;
	return false;
}

static bool X(int* out) {
	token_t* yy0 = yy;
	if (parse_reg16(K_SP, out) && (*out & RR_MASK) == RR_HL)
		return true;
	yy = yy0;
	return false;
}

static bool parse_flags(int nflags, int* out) {
	const keyword_t* kw = parse_keyword(IS_ANY);
	if (kw && kw->zflag != NA && kw->zflag < nflags) {
		*out = kw->zflag;
		return true;
	}
	else
		return false;
}

static bool FLAGS4(int* out) {
	return parse_flags(4, out);
}

static bool FLAGS8(int* out) {
	return parse_flags(8, out);
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
		if (yy[0].keyword && yy[0].keyword->id == K_ASMPC) {
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

	if (!BCDE(out)) goto fail;				// only BC or DE

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

static bool parse_void(parse_t* data) {
	if (EOS())
		return true;
	syntax_error();
	return false;
}

static bool parse_const(parse_t* data) {
	if (CONST(&data->n) && EOS())
		return true;
	syntax_error();
	return false;
}

static bool parse_expr(parse_t* data) {
	if (EXPR(&data->n) && EOS())
		return true;
	syntax_error();
	return false;
}

static bool check_alu8(int op) {
	int r, n, x, dis;
	token_t* yy0 = yy;
	if (!(KW(K_A) && TK(',')))
		yy = yy0;
	yy0 = yy;
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

static bool check_rot(int op) {
	int r, rr, x, dis;
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
    if (op == OP_SRA && BCDEHL(&rr) && EOS())				// sra bc/de/hl
        return emit_sra_rr(rr);
    yy = yy0;
    if (op == OP_RL && BCDEHL(&rr) && EOS())				// rl bc/de/hl
        return emit_rl_rr(rr);
    yy = yy0;
    if (op == OP_RR && BCDEHL(&rr) && EOS())				// rr bc/de/hl
        return emit_rr_rr(rr);
    yy = yy0;
    return false;
}

static bool parse_rot(int op) {
	if (check_rot(op))
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
	int r, r1, r2, rr, x, x1, x2, n, nn, dis;
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
	if (KW(K_A) && TK(',') && IND_BCDE(&rr) && EOS())			// LD A, (BC/DE)
		return emit_ld_a_indrr(rr);
	yy = yy0;
	if (IND_BCDE(&rr) && TK(',') && KW(K_A) && EOS())			// LD (BC/DE), A
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
	if (KW(K_A) && TK(',') && IND_EXPR(&nn) && EOS())			// LD A, (nn)
		return emit_ld_a_indnn(nn);
	yy = yy0;
	if (IND_EXPR(&nn) && TK(',') && KW(K_A) && EOS())			// LD (nn), A
		return emit_ld_indnn_a(nn);
	yy = yy0;
	if (KW(K_I) && TK(',') && KW(K_A) && EOS())					// LD I, A
		return emit_ld_i_a();
	yy = yy0;
	if (KW(K_R) && TK(',') && KW(K_A) && EOS())					// LD R, A
		return emit_ld_r_a();
	yy = yy0;
	if (KW(K_A) && TK(',') && KW(K_I) && EOS())					// LD A, I
		return emit_ld_a_i();
	yy = yy0;
	if (KW(K_A) && TK(',') && KW(K_R) && EOS())					// LD A, R
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
    if (DE() && TK(',') && SP() && EOS())						// LD DE, SP
        return (
            emit_ex_de_hl() &&
            emit_ld_rr_nn(RR_HL, 0) &&
            emit_add_x_rr(RR_HL, RR_SP) &&
            emit_ex_de_hl());
    yy = yy0;
    if (DE() && TK(',') && SP() && TK('+') && EXPR(&nn) && EOS())	// LD DE, SP+nn
        return (
            emit_ex_de_hl() &&
            emit_ld_rr_nn(RR_HL, nn) &&
            emit_add_x_rr(RR_HL, RR_SP) &&
            emit_ex_de_hl());
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
    yy = yy0;
    if (X(&x1) && TK(',') && X(&x2) && EOS())						// LD HL/IX/IY, HL/IX/IY
        return (
            emit_push_rr(x2) &&
            emit_pop_rr(x1));
    yy = yy0;
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
		return emit_ex_de_x(x);
	yy = yy0;
	if (TK('(') && SP() && TK(')') && TK(',') && X(&x) && EOS())		// EX (SP),HL/IX/IY
		return emit_ex_indsp_x(x);
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

static bool parse_neg(int dummy) {
	if ((KW(K_A) || true) && EOS()) 				// NEG [A]
		return emit_neg();
	syntax_error();
	return false;
}

static bool parse_cpl(int dummy) {
	if ((KW(K_A) || true) && EOS())						// CPL [A]
		return emit_cpl();
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

static bool parse_rlc_rrc(int is_left) {
	token_t* yy0 = yy;
	if (check_rot(is_left ? OP_RLC : OP_RRC))		// Zilog RLC/RRC r
		return true;
	yy = yy0;
	if (EOS())										// Intel RLC/RRC
		return is_left ? emit_rlca() : emit_rrca();
	syntax_error();
	return false;
}

static bool parse_ldi_ldd(int is_inc) {
	int rr;
	token_t* yy0 = yy;
	if (IND_BCDE(&rr) && TK(',') && KW(K_A) && EOS()) 		// LDI/LDD (BC/DE), A
		return (
			emit_ld_indrr_a(rr) &&
			(is_inc ? emit_inc_rr(rr) : emit_dec_rr(rr)));
	yy = yy0;
	if (KW(K_A) && TK(',') && IND_BCDE(&rr) && EOS()) 		// LDI/LDD A, (BC/DE)
		return (
			emit_ld_a_indrr(rr) &&
			(is_inc ? emit_inc_rr(rr) : emit_dec_rr(rr)));
	yy = yy0;
	if (IND_HL() && TK(',') && KW(K_A) && EOS())			// LDI/LDD (HL), A
		return (
			emit_ld_indx_r(RR_HL, 0, R_A) &&
			(is_inc ? emit_inc_rr(RR_HL) : emit_dec_rr(RR_HL)));
	yy = yy0;
	if (KW(K_A) && TK(',') && IND_HL() && EOS())			// LDI/LDD A, (HL)
		return (
			emit_ld_r_indx(R_A, RR_HL, 0) &&
			(is_inc ? emit_inc_rr(RR_HL) : emit_dec_rr(RR_HL)));
	yy = yy0;
	if (EOS())												// LDI/LDD
		return is_inc ? emit_ldi() : emit_ldd();
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

static bool parse_in(int dummy) {
	int r, n;
	token_t* yy0 = yy;
	if (KW(K_F) && TK(',') && IND_C() && EOS()) 	// IN F, (C)
		return emit_in_f_indc();
	yy = yy0;
	if (IND_C() && EOS())							// IN (C)
		return emit_in_f_indc();
	yy = yy0;
	if (REG8(&r) && TK(',') && IND_C() && EOS())	// IN r, (C)
		return emit_in_r_indc(r);
	yy = yy0;
	if (KW(K_A) && TK(',') && IND_EXPR(&n) && EOS())					// IN A, (n)
		return emit_in_a_indn(n);
	yy = yy0;
	if (EXPR(&n) && EOS())												// IN n
		return emit_in_a_indn(n);	
	syntax_error();
	return false;
}

static bool parse_out(int dummy) {
	int r, n;
	token_t* yy0 = yy;
	if (IND_C() && TK(',') && CONST(&n) && EOS())	// OUT (C), 0
		return emit_out_indc_n(n);
	yy = yy0;
	if (IND_C() && TK(',') && REG8(&r) && EOS()) 	// OUT (C), r
		return emit_out_indc_r(r);
	yy = yy0;
	if (IND_EXPR(&n) && TK(',') && KW(K_A) && EOS()) 					// OUT (n), A
		return emit_out_indn_a(n);
	yy = yy0;
	if (EXPR(&n) && EOS())												// OUT n
		return emit_out_indn_a(n);
	syntax_error();
	return false;
}

static bool parse_jp(int dummy) {
	int f, nn, x, rr;
	token_t* yy0 = yy;
	if (FLAGS8(&f) && TK(',') && EXPR(&nn) && EOS())		// JP f, nn
		return emit_jp_f_nn(f, nn);
	yy = yy0;
	if (EXPR(&nn) && EOS()) 								// JP nn
		return emit_jp_nn(nn);
	yy = yy0;
	if (TK('(') && X(&x) && TK(')') && EOS())				// JP (HL)/(IX)/(IY)
		return emit_jp_x(x);
	yy = yy0;
	if (TK('(') && BCDE(&rr) && TK(')') && EOS())			// JP (BC)/(DE)
		return emit_push_rr(rr) && emit_ret();
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

static bool parse_djnz(int dummy) {
	int nn;
	token_t* yy0 = yy;
	if (!(KW(K_B) && TK(',')))									// [b,] optional
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

static bool parse_statement(void) {
	if (EOS())
		return true;
	const keyword_t* kw = parse_keyword(IS_ANY);
	if (kw) {
		if (kw->parse_emit)
			return kw->parse_emit(kw->arg);
		else if (kw->parse) {
			parse_t data;
			if (!kw->parse(&data))
				return false;
			if (kw->emit_void)
				return kw->emit_void();
			else if (kw->emit_arg)
				return kw->emit_arg(data.n);
		}
	}
	syntax_error();
	return false;
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
		if (!yy)
			ok = false;
		else {
			if (!parse_line())
				ok = false;
		}
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
	
	start_backend(utstring_body(output_filename));
	utstring_free(output_filename);

	bool ok = parse_file(input_filename);

	end_backend(!ok);		// delete object if assembly failed

	return ok;
}

//-----------------------------------------------------------------------------
// keywords
//-----------------------------------------------------------------------------
static keyword_t keywords_table[] = {
//word,		id,		flags,			reg8,	reg16,	zflag,		parse(), arg, parse_void(), emit_void(), emit_arg()

// 8-bit registers
{"B",		K_B,	IS_INTEL,		R_B,	RR_BC,	NA,			},
{"C",		K_C,	IS_ANY,			R_C,	NA,		F_C,		},
{"D",		K_D,	IS_INTEL,		R_D,	RR_DE,	NA,			},
{"E",		K_E,	IS_ANY,			R_E,	NA,		NA,			},
{"H",		K_H,	IS_INTEL,		R_H,	RR_HL,	NA,			},
{"L",		K_L,	IS_ANY,			R_L,	NA,		NA,			},
{"M",		K_M,	IS_ANY,			R_M,	NA,		F_M,		},
{"A",		K_A,	IS_ANY,			R_A,	NA,		NA,			},
{"IXH",		K_IXH,	IS_ANY,			R_H|IDX_IX,	NA,	NA,			},
{"IXL",		K_IXL,	IS_ANY,			R_L|IDX_IX,	NA,	NA,			},
{"IYH",		K_IYH,	IS_ANY,			R_H|IDX_IY,	NA,	NA,			},
{"IYL",		K_IYL,	IS_ANY,			R_L|IDX_IY,	NA,	NA,			},
{"I",		K_I,	0,				NA,		NA,		NA,			},
{"R",		K_R,	0,				NA,		NA,		NA,			},
{"F",		K_F,	0,				NA,		NA,		NA,			},

// 16-bit registers
{"BC",		K_BC,	IS_AF|IS_SP|IS_INTEL, NA, RR_BC, NA,		},
{"DE",		K_DE,	IS_AF|IS_SP|IS_INTEL, NA, RR_DE, NA,		},
{"HL",		K_HL,	IS_AF|IS_SP|IS_INTEL, NA, RR_HL, NA,		},
{"SP",		K_SP,	IS_SP|IS_INTEL,	NA,		RR_SP,	NA,			},
{"AF",		K_AF,	IS_AF,			NA,		RR_AF,	NA,			},
{"PSW",		K_PSW,	IS_AF|IS_INTEL,	NA,		RR_AF, 	NA,			},
{"IX",		K_IX,	IS_AF|IS_SP,	NA,		RR_HL|IDX_IX, NA,	},
{"IY",		K_IY,	IS_AF|IS_SP,	NA,		RR_HL|IDX_IY, NA,	},

{"HLD",		K_HLD,	IS_AF|IS_SP,	NA,		RR_HL|POS_DEC, NA,	},
{"HLI",		K_HLI,	IS_AF|IS_SP,	NA,		RR_HL|POS_INC, NA,	},

// flags
{"NZ",		K_NZ,	IS_ANY,			NA,		NA,		F_NZ,		},
{"Z",		K_Z,	IS_ANY,			NA,		NA,		F_Z,		},
{"NC",		K_NC,	IS_ANY,			NA,		NA,		F_NC,		},
{"PO",		K_PO,	IS_ANY,			NA,		NA,		F_PO,		},
{"PE",		K_PE,	IS_ANY,			NA,		NA,		F_PE,		},
{"NV",		K_NV,	IS_ANY,			NA,		NA,		F_NV,		},
{"V",		K_V,	IS_ANY,			NA,		NA,		F_V,		},
{"P",		K_P,	IS_ANY,			NA,		NA,		F_P,		},

// operands
{"ASMPC",	K_ASMPC,0,				NA,		NA,		NA,			},

// load
{"LD",		0,		IS_ANY,			NA,		NA,		NA,			parse_ld,		0			},
{"LDA",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_expr, NULL, emit_ld_a_indnn },
{"STA",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_expr, NULL, emit_ld_indnn_a },
{"LHLD",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_expr, NULL, emit_ld_hl_indnn },
{"SHLD",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_expr, NULL, emit_ld_indnn_hl },
{"LDAX",	0,		IS_ANY,			NA,		NA,		NA,			parse_ldax_stax,1			},
{"STAX",	0,		IS_ANY,			NA,		NA,		NA,			parse_ldax_stax,0			},
{"LXI",		0,		IS_ANY,			NA,		NA,		NA,			parse_lxi,		0			},
{"MOV",		0,		IS_ANY,			NA,		NA,		NA,			parse_mov,		0			},
{"MVI",		0,		IS_ANY,			NA,		NA,		NA,			parse_mvi,		0			},
{"SPHL",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ld_sp_hl },

// increment and decrement
{"INC",		0,		IS_ANY,			NA,		NA,		NA,			parse_inc_dec,	1			},
{"DEC",		0,		IS_ANY,			NA,		NA,		NA,			parse_inc_dec,	0			},
{"INR",		0,		IS_ANY,			NA,		NA,		NA,			parse_inr_dcr,	1			},
{"DCR",		0,		IS_ANY,			NA,		NA,		NA,			parse_inr_dcr,	0			},
{"INX",		0,		IS_ANY,			NA,		NA,		NA,			parse_inx_dcx,	1			},
{"DCX",		0,		IS_ANY,			NA,		NA,		NA,			parse_inx_dcx,	0			},

// exchange
{"EX",		0,		IS_ANY,			NA,		NA,		NA,			parse_ex,		0			},
{"EXX",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_exx },
{"XCHG",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ex_de_hl },
{"XTHL",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ex_indsp_hl },

// stack
{"PUSH",	0,		IS_ANY,			NA,		NA,		NA,			parse_push_pop,	1			},
{"POP",		0,		IS_ANY,			NA,		NA,		NA,			parse_push_pop,	0			},

// arithmetic and logical
{"ADD",		0,		IS_ANY,			NA,		NA,		NA,			parse_add,		0			},
{"ADC",		0,		IS_ANY,			NA,		NA,		NA,			parse_adc,		0			},
{"DAD",		0,		IS_ANY,			NA,		NA,		NA,			parse_dad,		0			},
{"SUB",		0,		IS_ANY,			NA,		NA,		NA,			parse_sub,		0			},
{"SBC",		0,		IS_ANY,			NA,		NA,		NA,			parse_sbc,		0			},
{"CP",		0,		IS_ANY,			NA,		NA,		NA,			parse_alu8,		OP_CP		},
{"CMP",		0,		IS_ANY,			NA,		NA,		NA,			parse_cmp,		OP_CP		},
{"AND",		0,		IS_ANY,			NA,		NA,		NA,			parse_alu8,		OP_AND		},
{"OR",		0,		IS_ANY,			NA,		NA,		NA,			parse_alu8,		OP_OR		},
{"XOR",		0,		IS_ANY,			NA,		NA,		NA,			parse_alu8,		OP_XOR		},
{"DAA",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_daa },
{"CPL",		0,		IS_ANY,			NA,		NA,		NA,			parse_cpl,		0			},
{"CMA",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_cpl },
{"SCF",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_scf },
{"STC",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_scf },
{"CCF",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ccf },
{"CMC",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ccf },
{"NEG",		0,		IS_ANY,			NA,		NA,		NA,			parse_neg,		0			},
{"ADI",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_n, OP_ADD	},
{"ACI",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_n, OP_ADC	},
{"SUI",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_n, OP_SUB	},
{"SBI",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_n, OP_SBC	},
{"ANI",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_n, OP_AND	},
{"ORI",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_n, OP_OR	},
{"XRI",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_n, OP_XOR	},
{"SBB",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_r, OP_SBC	},
{"ANA",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_r, OP_AND	},
{"ORA",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_r, OP_OR	},
{"XRA",		0,		IS_ANY,			NA,		NA,		NA,			parse_intel_alu_r, OP_XOR	},
	
// rotate and shift
{"RLA",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rla },
{"RAL",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rla },
{"RLCA",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rlca },
{"RLC",		0,		IS_ANY,			NA,		NA,		NA,			parse_rlc_rrc,	1			},
{"RL",		0,		IS_ANY,			NA,		NA,		NA,			parse_rot,		OP_RL		},
{"SLA",		0,		IS_ANY,			NA,		NA,		NA,			parse_rot,		OP_SLA		},
{"SLL",		0,		IS_ANY,			NA,		NA,		NA,			parse_rot,		OP_SLL		},
{"SLI",		0,		IS_ANY,			NA,		NA,		NA,			parse_rot,		OP_SLI		},
{"RLD",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rld },
{"RRA",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rra },
{"RAR",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rra },
{"RRCA",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rrca },
{"RRC",		0,		IS_ANY,			NA,		NA,		NA,			parse_rlc_rrc,	0			},
{"RR",		0,		IS_ANY,			NA,		NA,		NA,			parse_rot,		OP_RR		},
{"SRA",		0,		IS_ANY,			NA,		NA,		NA,			parse_rot,		OP_SRA		},
{"SRL",		0,		IS_ANY,			NA,		NA,		NA,			parse_rot,		OP_SRL		},
{"RRD",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rrd },
{"ARHL",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_sra_hl },
{"RRHL",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_sra_hl },
{"RDEL",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rl_de },
{"RLDE",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_rl_de },

// bit manipulation
{"BIT",		0,		IS_ANY,			NA,		NA,		NA,			parse_bit8,		OP_BIT		},
{"RES",		0,		IS_ANY,			NA,		NA,		NA,			parse_bit8,		OP_RES		},
{"SET",		0,		IS_ANY,			NA,		NA,		NA,			parse_bit8,		OP_SET		},

// block transfer
{"LDIR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ldir },
{"LDD",		0,		IS_ANY,			NA,		NA,		NA,			parse_ldi_ldd,	0			},
{"LDI",		0,		IS_ANY,			NA,		NA,		NA,			parse_ldi_ldd,	1			},
{"LDDR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_lddr },

// search
{"CPI",		0,		IS_ANY,			NA,		NA,		NA,			parse_cpi,		0			},
{"CPIR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_cpir },
{"CPD",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_cpd },
{"CPDR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_cpdr },

// input/output
{"IN",		0,		IS_ANY,			NA,		NA,		NA,			parse_in,		0			},
{"INI",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ini },
{"INIR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_inir },
{"IND",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ind },
{"INDR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_indr },
{"OUT",		0,		IS_ANY,			NA,		NA,		NA,			parse_out,		0			},
{"OUTI",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_outi },
{"OTIR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_otir },
{"OUTD",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_outd },
{"OTDR",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_otdr },
	
// cpu control
{"NOP",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_nop },
{"DI",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_di },
{"EI",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_ei },
{"HALT",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_halt },
{"HLT",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_halt },
{"IM",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_const, NULL, emit_im },

// jump
{"JP",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp,		0			},
{"JR",		0,		IS_ANY,			NA,		NA,		NA,			parse_jr,		0			},
{"DJNZ",	0,		IS_ANY,			NA,		NA,		NA,			parse_djnz,		0			},
{"JMP",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp,		0			},
{"PCHL",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_jp_hl	},
{"JNZ",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_NZ		},
{"JZ",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_Z			},
{"JNC",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_NC		},
{"JC",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_C			},
{"JPO",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_PO		},
{"JPE",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_PE		},
{"JNV",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_NV		},
{"JV",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_V			},
// Jump if Positive cannot be parsed, same as JumP
{"JM",		0,		IS_ANY,			NA,		NA,		NA,			parse_jp_intel,	F_M			},

// call
{"CALL",	0,		IS_ANY,			NA,		NA,		NA,			parse_call,		0			},
{"RST",		0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_const, NULL, emit_rst },
{"CNZ",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_NZ		},
{"CZ",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_Z		},
{"CNC",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_NC		},
{"CC",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_C		},
{"CPO",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_PO		},
{"CPE",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_PE		},
{"CNV",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_NV		},
{"CV",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_V		},
// Call if Positive cannot be parsed, same as ComPare
{"CM",		0,		IS_ANY,			NA,		NA,		NA,			parse_call_intel, F_M		},

// return
{"RET",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret,		0			},
{"RETI",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_reti },
{"RETN",	0,		IS_ANY,			NA,		NA,		NA,			NULL, 0, parse_void, emit_retn },
{"RNZ",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_NZ		},
{"RZ",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_Z			},
{"RNC",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_NC		},
{"RC",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_C			},
{"RPO",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_PO		},
{"RPE",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_PE		},
{"RNV",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_NV		},
{"RV",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_V			},
{"RP",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_P			},
{"RM",		0,		IS_ANY,			NA,		NA,		NA,			parse_ret_intel,F_M			},

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
