/*
Z88DK Z80 Macro Assembler

Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Assembly macros.
*/

#include "macros.h"
#include "alloc.h"
#include "errors.h"
#include "str.h"
#include "strutil.h"
#include "utarray.h"
#include "uthash.h"
#include "utstring.h"
#include "types.h"
#include <assert.h>
#include <ctype.h>

#define Is_ident_prefix(x)	((x)=='.' || (x)=='#' || (x)=='$' || (x)=='%' || (x)=='@')
#define Is_ident_start(x)	(isalpha(x) || (x)=='_')
#define Is_ident_cont(x)	(isalnum(x) || (x)=='_')

//-----------------------------------------------------------------------------
//	#define macros
//-----------------------------------------------------------------------------
typedef struct DefMacro
{
	const char	*name;					// string kept in strpool.h
	UT_array	*params;				// list of formal parameters
	UT_string	*text;					// replacement text
	UT_hash_handle hh;      			// hash table
} DefMacro;

static DefMacro *def_macros = NULL;		// global list of #define macros
static UT_array *in_lines = NULL;		// line stream from input
static UT_array *out_lines = NULL;		// line stream to ouput
static UT_string *current_line = NULL;	// current returned line
static bool in_defgroup;				// no EQU transformation in defgroup

static DefMacro *DefMacro_add(char *name)
{
	DefMacro *elem;
	HASH_FIND(hh, def_macros, name, strlen(name), elem);
	if (elem) 
		return NULL;		// duplicate

	elem = m_new(DefMacro);
	elem->name = spool_add(name);
	utarray_new(elem->params, &ut_str_icd);
	utstring_new(elem->text);
	HASH_ADD_KEYPTR(hh, def_macros, elem->name, strlen(name), elem);

	return elem;
}

static void DefMacro_delete_elem(DefMacro *elem)
{
	if (elem) {
		utarray_free(elem->params);
		utstring_free(elem->text);
		HASH_DEL(def_macros, elem);
		m_free(elem);
	}
}

static void DefMacro_delete(char *name)
{
	DefMacro *elem;
	HASH_FIND(hh, def_macros, name, strlen(name), elem);
	DefMacro_delete_elem(elem);		// it is OK to undef a non-existing macro
}

static DefMacro *DefMacro_lookup(char *name)
{
	DefMacro *elem;
	HASH_FIND(hh, def_macros, name, strlen(name), elem);
	return elem;
}

void init_macros()
{
	def_macros = NULL;
	in_defgroup = false;
	utarray_new(in_lines, &ut_str_icd);
	utarray_new(out_lines, &ut_str_icd);
	utstring_new(current_line);
}

void clear_macros()
{
	DefMacro *elem, *tmp;
	HASH_ITER(hh, def_macros, elem, tmp) {
		DefMacro_delete_elem(elem);
	}
	def_macros = NULL;
	in_defgroup = false;

	utarray_clear(in_lines);
	utarray_clear(out_lines);
	utstring_clear(current_line);
}

void free_macros()
{
	clear_macros();

	utarray_free(in_lines);
	utarray_free(out_lines);
	utstring_free(current_line);
}

// fill input stream
static void fill_input(getline_t getline_func)
{
	if (utarray_len(in_lines) == 0) {
		char *line = getline_func();
		if (line)
			utarray_push_back(in_lines, &line);
	}
}

// extract first line from input_stream to current_line
static bool shift_lines(UT_array *lines)
{
	utstring_clear(current_line);
	if (utarray_len(lines) > 0) {
		// copy first from stream
		char *line = *((char **)utarray_front(lines));
		utstring_printf(current_line, "%s", line);
		utarray_erase(lines, 0, 1);
		return true;
	}
	else
		return false;
}

// collect a macro or argument name [\.\#]?[a-z_][a-z_0-9]*
static bool collect_name(char **in, UT_string *out)
{
	char *p = *in;

	utstring_clear(out);
	while (isspace(*p)) p++;

	if (Is_ident_prefix(p[0]) && Is_ident_start(p[1])) {
		utstring_bincpy(out, p, 2); p += 2;
		while (Is_ident_cont(*p)) { utstring_bincpy(out, p, 1); p++; }
		*in = p;
		return true;
	}
	else if (Is_ident_start(p[0])) {
		while (Is_ident_cont(*p)) { utstring_bincpy(out, p, 1); p++; }
		*in = p;
		return true;
	}
	else {
		return false;
	}
}

// collect formal parameters
static bool collect_params(char **p, DefMacro *macro, UT_string *param)
{
#define P (*p)

	if (*P == '(') P++; else return true;
	while (isspace(*P)) P++;
	if (*P == ')') { P++; return true; }

	for (;;) {
		if (!collect_name(p, param)) return false;
		char *param_body = utstring_body(param);
		utarray_push_back(macro->params, &param_body);

		while (isspace(*P)) P++;
		if (*P == ')') { P++; return true; }
		else if (*P == ',') P++;
		else return false;
	}

#undef P
}

// collect macro text
static bool collect_text(char **p, DefMacro *macro, UT_string *text)
{
#define P (*p)

	utstring_clear(text);

	while (isspace(*P)) P++;
	while (*P) {
		if (*P == ';' || *P == '\n') 
			break;
		else if (*P == '\'' || *P == '"') {
			char q = *P; utstring_bincpy(text, P, 1); P++;
			while (*P != q && *P != '\0') {
				if (*P == '\\') {
					utstring_bincpy(text, P, 1); P++;
					if (*P != '\0') {
						utstring_bincpy(text, P, 1); P++;
					}
				}
				else {
					utstring_bincpy(text, P, 1); P++;
				}
			}
			if (*P != '\0') {
				utstring_bincpy(text, P, 1); P++;
			}
		}
		else {
			utstring_bincpy(text, P, 1); P++;
		}
	}

	while (utstring_len(text) > 0 && isspace(utstring_body(text)[utstring_len(text) - 1])) {
		utstring_len(text)--;
		utstring_body(text)[utstring_len(text)] = '\0';
	}

	utstring_printf(macro->text, "%s", utstring_body(text));

	return true;

#undef P
}

// collect white space up to end of line or comment
static bool collect_eol(char **p)
{
#define P (*p)

	while (isspace(*P)) P++; // consumes also \n and \r
	if (*P == ';' || *P == '\0')
		return true;
	else
		return false;

#undef P
}

// is this an identifier?
static bool collect_ident(char **in, char *ident)
{
	char *p = *in;

	size_t idlen = strlen(ident);
	if (strnicompare(p, ident, idlen) == 0 && !Is_ident_cont(p[idlen])) {
		*in = p + idlen;
		return true;
	}
	return false;
}

// is this a "NAME EQU xxx" or "NAME = xxx"?
static bool collect_equ(char **in, UT_string *name)
{
	char *p = *in;

	while (isspace(*p)) p++;

	if (in_defgroup) {
		while (*p != '\0' && *p != ';') {
			if (*p == '}') {
				in_defgroup = false;
				return false;
			}
			p++;
		}
	}
	else if (collect_name(&p, name)) {
		if (stricompare(utstring_body(name), "defgroup") == 0) {
			in_defgroup = true;
			while (*p != '\0' && *p != ';') {
				if (*p == '}') {
					in_defgroup = false;
					return false;
				}
				p++;
			}
			return false;
		}

		while (isspace(*p)) p++;

		if (*p == '=') {
			*in = p + 1;
			return true;
		}
		else if (Is_ident_start(*p) && collect_ident(&p, "equ")) {
			*in = p;
			return true;
		}
	}
	return false;
}

// collect arguments and expand macro
static void macro_expand(DefMacro *macro, char **p, UT_string *out)
{
	if (utarray_len(macro->params) > 0) {
		// collect arguments
		assert(0);
	}

	utstring_printf(out, "%s", utstring_body(macro->text));
}

// parse #define, #undef and expand macros
static void parse1(UT_string *in, UT_string *out, UT_string *name, UT_string *text)
{
	// default output = input
	utstring_clear(out); utstring_concat(out, in);

	char *p = utstring_body(in);

	if (*p == '#') {
		p++;

		if (collect_ident(&p, "define")) {
			utstring_clear(out);

			// get macro name
			if (!collect_name(&p, name)) {
				error_syntax();
				return;
			}

			// create macro, error if duplicate
			DefMacro *macro = DefMacro_add(utstring_body(name));
			if (!macro) {
				error_redefined_macro(utstring_body(name));
				return;
			}

			// get macro params
#if 0
			if (!collect_params(&p, macro, text)) {
				error_syntax();
				return;
			}
#endif

			// get macro text
			if (!collect_text(&p, macro, text)) {
				error_syntax();
				return;
			}
		}
		else if (collect_ident(&p, "undef")) {
			utstring_clear(out);

			// get macro name
			if (!collect_name(&p, name)) {
				error_syntax();
				return;
			}

			// assert end of line
			if (!collect_eol(&p)) {
				error_syntax();
				return;
			}

			DefMacro_delete(utstring_body(name));
		}
		else {
		}
	}
	else {	// expand macros
		utstring_clear(out);
		while (*p != '\0') {
			if ((Is_ident_prefix(p[0]) && Is_ident_start(p[1])) ||
				Is_ident_start(p[0])) {
				// maybe at start of macro call
				collect_name(&p, name);
				DefMacro *macro = DefMacro_lookup(utstring_body(name));
				if (macro)
					macro_expand(macro, &p, out);
				else {
					// try after prefix
					if (Is_ident_prefix(utstring_body(name)[0])) {
						utstring_bincpy(out, utstring_body(name), 1);
						macro = DefMacro_lookup(utstring_body(name) + 1);
						if (macro)
							macro_expand(macro, &p, out);
						else
							utstring_bincpy(out, utstring_body(name) + 1, utstring_len(name) - 1);
					}
					else {
						utstring_bincpy(out, utstring_body(name), utstring_len(name));
					}
				}
			}
			else if (*p == '\'' || *p == '"') {
				char q = *p;
				utstring_bincpy(out, p, 1); p++;
				while (*p != q && *p != '\0') {
					if (*p == '\\') {
						utstring_bincpy(out, p, 1); p++;
						if (*p != '\0') {
							utstring_bincpy(out, p, 1); p++;
						}
					}
					else {
						utstring_bincpy(out, p, 1); p++;
					}
				}
				if (*p != '\0') {
					utstring_bincpy(out, p, 1); p++;
				}
			}
			else if (*p == ';') {
				utstring_bincpy(out, "\n", 1); p += strlen(p);		// skip comments
			}
			else {
				utstring_bincpy(out, p, 1); p++;
			}
		}

		// check other commands after macro expansion
		utstring_clear(in); utstring_concat(in, out);	// in = out

		p = utstring_body(in);
		if (collect_equ(&p, name)) {
			utstring_clear(out); 
			utstring_printf(out, "defc %s = %s", utstring_body(name), p);
		}
	}
}

static void parse()
{
	UT_string *out, *name, *text;
	utstring_new(out);
	utstring_new(name);
	utstring_new(text);

	parse1(current_line, out, name, text);
	if (utstring_len(out) > 0) {
		char *out_body = utstring_body(out);
		utarray_push_back(out_lines, &out_body);
	}

	utstring_free(out);
	utstring_free(name);
	utstring_free(text);
}

// get line and call parser
char *macros_getline(getline_t getline_func)
{
	do {
		if (shift_lines(out_lines))
			return utstring_body(current_line);

		fill_input(getline_func);

		if (!shift_lines(in_lines))
			return NULL;			// end of input

		parse();					// parse current_line, leave output in out_lines
	} while (!shift_lines(out_lines));

	return utstring_body(current_line);
}


#if 0

extern DefMacro *DefMacro_new();
extern void DefMacro_free(DefMacro **self);
extern DefMacro *DefMacro_add(DefMacro **self, char *name, char *text);
extern void DefMacro_add_param(DefMacro *macro, char *param);
extern DefMacro *DefMacro_parse(DefMacro **self, char *line);

/*-----------------------------------------------------------------------------
*   #define macros
*----------------------------------------------------------------------------*/

void DefMacro_free(DefMacro ** self)
{
}

void DefMacro_add_param(DefMacro *macro, char *param)
{
	utarray_push_back(macro->params, &param);
}

// parse #define macro[(arg,arg,...)] text
// return NULL if no #define, or macro pointer if #define found and parsed
DefMacro *DefMacro_parse(DefMacro **self, char *line)
{
	char *p = line;
	while (*p != '\0' && isspace(*p)) p++;			// blanks
	if (*p != '#') return NULL;						// #
	p++; while (*p != '\0' && isspace(*p)) p++;		// blanks
	if (strncmp(p, "define", 6) != 0) return NULL;	// define
	p += 6;


	return NULL;
}


#endif
