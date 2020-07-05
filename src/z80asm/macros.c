/*
Z88DK Z80 Macro Assembler

Copyright (C) Paulo Custodio, 2011-2020
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk/

Assembly macros.
*/

#include "alloc.h"
#include "die.h"
#include "errors.h"
#include "macros.h"
#include "str.h"
#include "strutil.h"
#include "types.h"
#include "uthash.h"
#include "utstring.h"
#include "zutils.h"

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
	argv_t		*params;				// list of formal parameters
	UT_string	*text;					// replacement text
	UT_hash_handle hh;      			// hash table
} DefMacro;

static DefMacro *def_macros = NULL;		// global list of #define macros
static argv_t *in_lines = NULL;			// line stream from input
static argv_t *out_lines = NULL;		// line stream to ouput
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
	elem->params = argv_new();
	elem->text = utstr_new();
	HASH_ADD_KEYPTR(hh, def_macros, elem->name, strlen(name), elem);

	return elem;
}

static void DefMacro_delete_elem(DefMacro *elem)
{
	if (elem) {
		argv_free(elem->params);
		utstr_free(elem->text);
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
	in_lines = argv_new();
	out_lines = argv_new();
	current_line = utstr_new();
}

void clear_macros()
{
	DefMacro *elem, *tmp;
	HASH_ITER(hh, def_macros, elem, tmp) {
		DefMacro_delete_elem(elem);
	}
	def_macros = NULL;
	in_defgroup = false;

	argv_clear(in_lines);
	argv_clear(out_lines);
	utstr_clear(current_line);
}

void free_macros()
{
	clear_macros();

	argv_free(in_lines);
	argv_free(out_lines);
	utstr_free(current_line);
}

// fill input stream
static void fill_input(getline_t getline_func)
{
	if (argv_len(in_lines) == 0) {
		char *line = getline_func();
		if (line)
			argv_push(in_lines, line);
	}
}

// extract first line from input_stream to current_line
static bool shift_lines(argv_t *lines)
{
	utstr_clear(current_line);
	if (argv_len(lines) > 0) {
		// copy first from stream
		char *line = *argv_front(lines);
		utstr_set(current_line, line);
		argv_shift(lines);
		return true;
	}
	else
		return false;
}

// collect a macro or argument name [\.\#]?[a-z_][a-z_0-9]*
static bool collect_name(char **in, UT_string *out)
{
	char *p = *in;

	utstr_clear(out);
	while (isspace(*p)) p++;

	if (Is_ident_prefix(p[0]) && Is_ident_start(p[1])) {
		utstr_append_n(out, p, 2); p += 2;
		while (Is_ident_cont(*p)) { utstr_append_n(out, p, 1); p++; }
		*in = p;
		return true;
	}
	else if (Is_ident_start(p[0])) {
		while (Is_ident_cont(*p)) { utstr_append_n(out, p, 1); p++; }
		*in = p;
		return true;
	}
	else {
		return false;
	}
}

// collect formal parameters
/* Prevent warning: defined but not used [-Wunused-function] */
/*
static bool collect_params(char **p, DefMacro *macro, UT_string *param)
{
#define P (*p)

	if (*P == '(') P++; else return true;
	while (isspace(*P)) P++;
	if (*P == ')') { P++; return true; }

	for (;;) {
		if (!collect_name(p, param)) return false;
		argv_push(macro->params, utstr_body(param));

		while (isspace(*P)) P++;
		if (*P == ')') { P++; return true; }
		else if (*P == ',') P++;
		else return false;
	}

#undef P
}
*/

// collect macro text
static bool collect_text(char **p, DefMacro *macro, UT_string *text)
{
#define P (*p)

	utstr_clear(text);

	while (isspace(*P)) P++;
	while (*P) {
		if (*P == ';' || *P == '\n') 
			break;
		else if (*P == '\'' || *P == '"') {
			char q = *P; utstr_append_n(text, P, 1); P++;
			while (*P != q && *P != '\0') {
				if (*P == '\\') {
					utstr_append_n(text, P, 1); P++;
					if (*P != '\0') {
						utstr_append_n(text, P, 1); P++;
					}
				}
				else {
					utstr_append_n(text, P, 1); P++;
				}
			}
			if (*P != '\0') {
				utstr_append_n(text, P, 1); P++;
			}
		}
		else {
			utstr_append_n(text, P, 1); P++;
		}
	}

	while (utstr_len(text) > 0 && isspace(utstr_body(text)[utstr_len(text) - 1])) {
		utstr_len(text)--;
		utstr_body(text)[utstr_len(text)] = '\0';
	}

	utstr_set_str(macro->text, text);

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
	if (strncasecmp(p, ident, idlen) == 0 && !Is_ident_cont(p[idlen])) {
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
		if (strcasecmp(utstr_body(name), "defgroup") == 0) {
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
		
		if (utstr_body(name)[0] == '.') {			// old-style label
			// remove starting dot from name
			UT_string *temp = utstr_new_init(&utstr_body(name)[1]);
			utstr_set_str(name, temp);
			utstr_free(temp);
		}
		else if (*p == ':') {							// colon after name
			p++;
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
		xassert(0);
	}

	utstr_append(out, utstr_body(macro->text));
}

// parse #define, #undef and expand macros
static void parse1(UT_string *in, UT_string *out, UT_string *name, UT_string *text)
{
	// default output = input
	utstr_set_str(out, in);

	char *p = utstr_body(in);

	if (*p == '#') {
		p++;

		if (collect_ident(&p, "define")) {
			utstr_clear(out);

			// get macro name
			if (!collect_name(&p, name)) {
				error_syntax();
				return;
			}

			// create macro, error if duplicate
			DefMacro *macro = DefMacro_add(utstr_body(name));
			if (!macro) {
				error_redefined_macro(utstr_body(name));
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
			utstr_clear(out);

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

			DefMacro_delete(utstr_body(name));
		}
		else {
		}
	}
	else {	// expand macros
		utstr_clear(out);
		while (*p != '\0') {
			if ((Is_ident_prefix(p[0]) && Is_ident_start(p[1])) ||
				Is_ident_start(p[0])) {
				// maybe at start of macro call
				collect_name(&p, name);
				DefMacro *macro = DefMacro_lookup(utstr_body(name));
				if (macro)
					macro_expand(macro, &p, out);
				else {
					// try after prefix
					if (Is_ident_prefix(utstr_body(name)[0])) {
						utstr_append_n(out, utstr_body(name), 1);
						macro = DefMacro_lookup(utstr_body(name) + 1);
						if (macro)
							macro_expand(macro, &p, out);
						else
							utstr_append_n(out, utstr_body(name) + 1, utstr_len(name) - 1);
					}
					else {
						utstr_append_n(out, utstr_body(name), utstr_len(name));
					}
				}
			}
			else if (*p == '\'' || *p == '"') {
				char q = *p;
				utstr_append_n(out, p, 1); p++;
				while (*p != q && *p != '\0') {
					if (*p == '\\') {
						utstr_append_n(out, p, 1); p++;
						if (*p != '\0') {
							utstr_append_n(out, p, 1); p++;
						}
					}
					else {
						utstr_append_n(out, p, 1); p++;
					}
				}
				if (*p != '\0') {
					utstr_append_n(out, p, 1); p++;
				}
			}
			else if (*p == ';') {
				utstr_append_n(out, "\n", 1); p += strlen(p);		// skip comments
			}
			else {
				utstr_append_n(out, p, 1); p++;
			}
		}

		// check other commands after macro expansion
		utstr_set_str(in, out);	// in = out

		p = utstr_body(in);
		if (collect_equ(&p, name)) {
			utstr_set_fmt(out, "defc %s = %s", utstr_body(name), p);
		}
	}
}

static void parse()
{
	UT_string *out, *name, *text;
	out = utstr_new();
	name = utstr_new();
	text = utstr_new();

	parse1(current_line, out, name, text);
	if (utstr_len(out) > 0) {
		argv_push(out_lines, utstr_body(out));
	}

	utstr_free(out);
	utstr_free(name);
	utstr_free(text);
}

// get line and call parser
char *macros_getline(getline_t getline_func)
{
	do {
		if (shift_lines(out_lines))
			return utstr_body(current_line);

		fill_input(getline_func);

		if (!shift_lines(in_lines))
			return NULL;			// end of input

		parse();					// parse current_line, leave output in out_lines
	} while (!shift_lines(out_lines));

	return utstr_body(current_line);
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
	argv_push(macro->params, param);
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
